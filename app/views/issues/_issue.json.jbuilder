# frozen_string_literal: true

json.extract! issue, :id, :effort, :user_id, :state, :closed_date

json.user do |json|
  json.partial! 'users/user', user: issue.user
end
