class Sale < ApplicationRecord
  def self.create_from_order!(order)
    return if order.canceled_at

    order.line_items.each do |line_item|
      genres = line_item.book.genres
      genre_group_key = genres.map(&:id).sort.join(':')

      existing = GenreGroup.find_by(genre_group_key: genre_group_key)
      unless existing
        multiplier = 1.0 / genres.size
        genres.each do |genre|
          GenreGroup.create!(
            genre_group_key: genre_group_key,
            genre: genre,
            multiplier: multiplier
          )
        end
      end

      create!(
        order_line_item_id: line_item.id,
        order_id: order.id,
        book_id: line_item.book_id,
        author_id: line_item.book.author_id,
        buyer_id: order.buyer_id,
        state: order.shipping_address.state,
        genre_group_key: genre_group_key,
        placed_on: order.placed_at.to_date,
        placed_at: order.placed_at,
        revenue: line_item.unit_price * line_item.quantity,
        unit_price: line_item.unit_price,
        quantity: line_item.quantity
      )
    end
  end
end
