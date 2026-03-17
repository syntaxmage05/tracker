# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  attr_accessor :role

  has_many :team_memberships
  has_many :standups
  has_many :teams, through: :team_memberships
  belongs_to :account, optional: true
end
