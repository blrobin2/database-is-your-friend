class Book < ApplicationRecord
  include AASM

  class NoStock < StandardError; end

  aasm do
    state :stocked, initial: true
    state :out_of_print

    event :discontinue do
      transitions \
        from: :stocked,
        to: :out_of_print,
        after: proc { notify_discontinue! }
    end

    event :continue do
      transitions from: :out_of_print, to: :stocked
    end
  end

  def discontinue_with_lock!
    transaction do
      lock!
      sleep 5
      discontinue!
    end
  end

  def notify_discontinue!
    Rails.logger.info("Book discontinued: #{id}, #{title}")
  end

  belongs_to :author
  acts_as_list
  has_many :comments, dependent: :destroy, class_name: 'BookComment'
  has_many :reservations

  validates :title, presence: true, uniqueness: true

  def reserve
    transaction do
      rows_updated = Book.where(id: id)
                         .where('in_stock > 0')
                         .update_all(in_stock: (in_stock - 1))
      raise NoStock unless rows_updated == 1

      reservations.create!(expires_at: 1.day.from_now)
    end
  rescue NoStock
    retry if Book.expire_old_reservations.positive?
  end

  def pickup(reservation_id)
    reservations.find(reservation_id).destroy
  rescue ApplicationRecord::RecordNotFound => _e
    Rails.logger.info 'Record already destroyed, who cares'
  end

  def abandon(reservation_id)
    transaction do
      reservations.find(reservation_id).destroy
      Book.increment_counter(:in_stock, id)
    end
  rescue ApplicationRecord::RecordNotFound => _e
    Rails.logger.info 'Record already destroyed, who cares'
  end

  def self.expire_old_reservations
    expired = 0
    to_expire = Reservation.where('expires_at < ?', Time.zone.now)
    to_expire.each do |reservation|
      transaction do
        reservation.destroy
        Book.increment_counter(:in_stock, reservation.book_id)
        expired += 1
      end
    rescue ApplicationRecord::RecordNotFound => _e
      Rails.logger.info 'Record already destroyed, who cares'
    end
    expired
  end
end
