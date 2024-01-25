# frozen_string_literal: true

json.extract! statement_of_work, :id, :total_revenue, :start_date, :end_date, :project_id, :created_at, :updated_at, :name

# Include details about the contract model

# Include details about the contract model
json.contract_model do
  contract_model = statement_of_work.contract_model

  json.merge! contract_model&.slice(:id, :created_at, :updated_at)

  json.contract_model_type statement_of_work.contract_model_type

  case contract_model
  when TimeAndMaterialsAtCostContractModel
    json.extract! contract_model, :allow_overflow, :hours_amount, :limit_by, :management_factor
  when TimeAndMaterialsContractModel
    json.extract! contract_model, :allow_overflow, :hourly_price, :hours_amount, :limit_by
  when MaintenanceContractModel
    json.extract! contract_model, :accumulate_hours, :charge_upfront, :delivery_period,
                  :expected_hours_per_period, :hourly_cost, :revenue_per_period
  when FixedBidContractModel
    json.fixed_timeline contract_model.fixed_timeline
  when RetainerContractModel
    json.extract! statement_of_work.contract_model, :charge_upfront, :expected_hours_per_period, :revenue_per_period
  end
end
