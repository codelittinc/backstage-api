# frozen_string_literal: true

class Profession < ApplicationRecord
  has_many :users, dependent: :nullify
  validates :name, presence: true
end
