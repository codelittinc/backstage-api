# frozen_string_literal: true

json.customer do |json|
  json.partial! 'customers/customer', customer: project.customer
end

json.extract! project, :id, :name, :billable, :slack_channel, :start_date, :end_date
