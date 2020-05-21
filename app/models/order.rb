class Order < ApplicationRecord
  belongs_to :buyer
  belongs_to :shipping_address
  has_many :order_line_items

  alias_attribute :line_items, :order_line_items
end
