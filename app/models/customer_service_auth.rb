# frozen_string_literal: true

# == Schema Information
#
# Table name: customer_service_auths
#
#  id          :bigint           not null, primary key
#  auth_key    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#
# Indexes
#
#  index_customer_service_auths_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#

class CustomerServiceAuth < ApplicationRecord
  belongs_to :customer

  before_create :generate_auth_key

  private

  def generate_auth_key
    self.auth_key = SecureRandom.hex(10) # Generates a random hex string of 20 characters
  end
end
