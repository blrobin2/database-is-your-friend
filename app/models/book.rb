class Book < ApplicationRecord
  include AASM

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
  has_many :comments, dependent: :destroy, class_name: 'BookComment'

  validates :title, presence: true, uniqueness: true
end
