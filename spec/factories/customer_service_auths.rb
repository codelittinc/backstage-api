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
FactoryBot.define do
  factory :customer_service_auth do
    auth_key { 'MyString' }
    customer { nil }
  end
end
