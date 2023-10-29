# frozen_string_literal: true

json.extract! assignment, :id, :coverage, :requirement_id, :created_at, :updated_at
json.url assignment_url(assignment, format: :json)
