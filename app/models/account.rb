# frozen_string_literal: true

class Account < ApplicationRecord
  LIMIT_ATTRIBUTES = %i(users teams integration)
  resourcify

  has_many :users
  has_many :teams

  validates :name, presence: true

  def product
    Product.find_by(product_id: product_id)
  end

  def limits
    OpenStruct.new(Product.find_by(product_id).to_h.slice(*LIMIT_ATTRIBUTES))
  end
end
