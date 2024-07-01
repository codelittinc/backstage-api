# frozen_string_literal: true

module Analytics
  class ProjectProgressController < ApplicationController
    before_action :set_project, only: %i[index]
    before_action :set_statement_of_work, only: %i[index]

    def index
      render json: {
        contract_hours: @statement_of_work.contract_model.contract_total_hours,
        consumed_hours: @statement_of_work.contract_model.consumed_hours
      }
    end

    private

    def set_project
      @project = Project.where(id: params[:project_id]).first
    end

    def set_statement_of_work
      @statement_of_work = StatementOfWork.where(id: params[:statement_of_work_id]).first
    end
  end
end
