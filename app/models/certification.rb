# frozen_string_literal: true

# == Schema Information
#
# Table name: certifications
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_certifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Certification < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
end
