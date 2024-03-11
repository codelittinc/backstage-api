# frozen_string_literal: true

json.extract! assignment, :id, :coverage, :requirement_id, :created_at, :updated_at, :start_date, :end_date, :user_id

json.statement_of_work_id assignment.requirement.statement_of_work_id
