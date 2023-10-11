# frozen_string_literal: true

# == Schema Information
#
# Table name: professions
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Profession < ApplicationRecord
  has_many :users, dependent: :nullify
  validates :name, presence: true
end
