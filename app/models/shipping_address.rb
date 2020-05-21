class ShippingAddress < ApplicationRecord
  belongs_to :buyer
  has_many :orders
end
