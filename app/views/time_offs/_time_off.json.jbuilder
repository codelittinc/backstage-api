# frozen_string_literal: true

json.extract! time_off, :id, :created_at, :updated_at
json.url time_off_url(time_off, format: :json)
