# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :account
  has_many :team_memberships, dependent: :destroy
  has_many :users, through: :team_memberships
  has_many :days, class_name: "DaysOfWeekMembership", dependent: :delete_all

  validates :account, :timezone, :name, presence: true

  accepts_nested_attributes_for :days
end
