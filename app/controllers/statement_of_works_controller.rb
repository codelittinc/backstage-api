# frozen_string_literal: true

class StatementOfWorksController < ApplicationController
  before_action :set_project
  before_action :set_statement_of_work, only: %i[show update destroy]

  def index
    if @project
      @statement_of_works = @project.statement_of_works
    elsif filter_params[:start_date].present? && filter_params[:end_date].present?
      @statement_of_works = StatementOfWork.active_in_period(filter_params[:start_date], filter_params[:end_date])
    end

    @statement_of_works = @statement_of_works.order(:start_date).reverse
  end

  def show; end

  def create
    @statement_of_work = @project.statement_of_works.new(statement_of_work_params.except(:contract_model_attributes))
    update_or_build_contract_model

    if @statement_of_work.save
      render :show, status: :created, location: [@statement_of_work]
    else
      render json: @statement_of_work.errors, status: :unprocessable_entity
    end
  end

  def update
    ApplicationRecord.transaction do
      update_or_build_contract_model

      if @statement_of_work.update(statement_of_work_params.except(:contract_model_attributes))
        render :show, status: :ok, location: [@statement_of_work]
      else
        render json: @statement_of_work.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @statement_of_work.destroy
    head :no_content
  end

  private

  def set_project
    @project = Project.friendly.find(params[:project_id])
  end

  def set_statement_of_work
    @statement_of_work = @project.statement_of_works.find(params[:id])
  end

  def statement_of_work_params
    params.require(:statement_of_work).permit(
      :total_revenue, :start_date, :end_date, :name,
      :contract_model_type, :contract_model_id,
      contract_model_attributes: [
        # For TimeAndMaterialsAtCostContractModel
        :id, :allow_overflow, :hours_amount, :limit_by, :management_factor,
        # For TimeAndMaterialsContractModel
        :hourly_price,
        # For MaintenanceContractModel
        :accumulate_hours, :charge_upfront, :delivery_period, :expected_hours_per_period, :hourly_cost, :revenue_per_period,
        # For FixedBidContractModel
        :fixed_timeline,
        # For the polymorphic association type
        :contract_model_type
      ]
    )
  end

  def filter_params
    params.require(:filters).permit(:start_date, :end_date)
  end

  def update_or_build_contract_model
    contract_model_params = statement_of_work_params[:contract_model_attributes]
    return unless contract_model_params

    # Extract the type and id from params and then remove the type field
    contract_model_type = contract_model_params[:contract_model_type]

    contract_model_params.delete(:contract_model_type)
    contract_model_id = contract_model_params[:id]

    # Find or initialize the contract model
    if contract_model_id
      contract_model = contract_model_type.constantize.find(contract_model_id)
      contract_model.assign_attributes(contract_model_params)
    else
      contract_model = contract_model_type.constantize.new(contract_model_params)
      @statement_of_work.contract_model = contract_model
    end
  end
end
