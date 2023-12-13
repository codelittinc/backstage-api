# frozen_string_literal: true

module Analytics
  class FinancesController < ApplicationController
    before_action :set_project, only: %i[index]
    before_action :set_statement_of_works, only: %i[index]

    def index
      @finances = Analytics::Finances::Models::FinancialStatementsOfWork.new(@statement_of_works, start_date, end_date,
                                                                             @project)
      @finances.financial_items = @finances.financial_items.sort_by(&:name)
    end

    private

    def set_statement_of_works
      @statement_of_works = if @project
                              @project.statement_of_works.active_in_period(start_date, end_date)
                            else
                              StatementOfWork.active_in_period(start_date, end_date)
                            end
    end

    def set_project
      @project = Project.where(id: params[:project_id]).first
    end

    def start_date
      params[:start_date].to_datetime.beginning_of_day
    end

    def end_date
      params[:end_date].to_datetime.end_of_day
    end
  end
end
