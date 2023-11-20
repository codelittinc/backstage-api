# frozen_string_literal: true

json.extract! payment, :id, :date, :amount, :statement_of_work_id, :created_at, :updated_at
json.url payment_url(payment, format: :json)
