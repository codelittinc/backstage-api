# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
end
