class Buyer < ApplicationRecord
  has_many :shipping_addresses
  has_many :orders
end