# frozen_string_literal: true

# index.json.jbuilder

json.totals do
  json.total_expected_income @finances.total_expected_income
  json.total_executed_income @finances.total_executed_income
  json.total_executed_cost @finances.total_executed_cost
  json.total_expected_cost @finances.total_expected_cost
end

json.details do
  json.array! @finances.financial_items do |assignment|
    json.name assignment.name
    json.slug assignment.slug
    json.expected_hours assignment.expected_hours
    json.executed_hours assignment.executed_hours
    json.expected_income assignment.expected_income
    json.executed_income assignment.executed_income
    json.paid_time_off_hours assignment.paid_time_off_hours
    json.executed_cost assignment.executed_cost
    json.expected_cost assignment.expected_cost
  end
end
