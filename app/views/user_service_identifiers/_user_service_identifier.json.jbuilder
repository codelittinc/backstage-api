# frozen_string_literal: true

# _user_service_identifier.json.jbuilder

json.extract! user_service_identifier, :id, :identifier, :service_name

# Render the customer associated with the user_service_identifier
json.customer user_service_identifier.customer, partial: 'customers/customer', as: :customer
