# frozen_string_literal: true

class Accounts::ProductsController < ApplicationController
  skip_before_action :authenticate_user!
  layout "devise"

  def index
    @products = Product.where(active: true, displayable: true)
  end
end
