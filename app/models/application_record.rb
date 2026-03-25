# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  delegate :render, to: :ApplicationController
  delegate :dom_id, to: "ActionView::RecordIdentifier"
  primary_abstract_class
  self.implicit_order_column = "created_at"
end
