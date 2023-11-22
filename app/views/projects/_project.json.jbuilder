# frozen_string_literal: true

json.customer do |json|
  json.partial! 'customers/customer', customer: project.customer
end

json.participants project.participants.map do |participant|
  json.extract! participant, :id, :name, :email, :image_url, :slug
end

json.extract! project, :id, :name, :billable, :slack_channel, :metadata, :slug, :logo_url,
              :sync_source_control, :sync_ticket_tracking_system
