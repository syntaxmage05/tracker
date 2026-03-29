# frozen_string_literal: true

class Product
  class NotFoundError < StandardError; end

  def self.products
    @_products ||= PRODUCTS.keys.map { |k| PRODUCTS[k] }
  end

  def self.all
    products.map { |product| OpenStruct.new(product) }
  end

  def self.where(args)
    conditions = args.map do |arg_key, arg_val|
      proc { |product| product[arg_key] == arg_val }
    end

    local_products = products.select do |product|
      conditions.all? { |c| c.call(product) }
    end

    return [] if local_products.empty?

    local_products.map { |product| OpenStruct.new(product) }
  end

  def self.find(stripe_id)
    product = products.find { |p| p[:product_id] == stripe_id }

    raise NotFoundError,
      "Could not find Product with stripe_price_id: #{stripe_id}" unless product

    OpenStruct.new(product)
  end

  def self.find_by(args)
    product = Product.where(args)&.first
    return nil if product.nil?

    OpenStruct.new(product)
  end

  def self.find_by!(args)
    product = Product.where(args)&.first

    raise NotFoundError,
      "Could not find Product with #{args.to_a.flatten.first}: #{args.to_a.flatten.last}" unless product

    OpenStruct.new(product)
  end
end
