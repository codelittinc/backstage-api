# frozen_string_literal: true

json.extract! time_entry, :id, :date, :hours, :user_id, :statement_of_work_id, :created_at, :updated_at
json.url time_entry_url(time_entry, format: :json)
