# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  target     :string
#  ability    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Permission < ApplicationRecord
  has_many :user_permissions, dependent: :destroy
  has_many :users, through: :user_permissions

  validates :target, presence: true
  validates :ability, presence: true

  def name
    "#{target} - #{ability}"
  end
end
