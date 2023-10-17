# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  billable      :boolean          default(TRUE), not null
#  end_date      :date
#  metadata      :json
#  name          :string
#  slack_channel :string
#  start_date    :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :bigint           not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
class Project < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
  validates :billable, inclusion: { in: [true, false] }, presence: true
  validates :slack_channel, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
