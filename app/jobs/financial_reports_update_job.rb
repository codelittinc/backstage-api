# frozen_string_literal: true

class FinancialReportsUpdateJob
  include Sidekiq::Job

  def perform(*_args)
    UpdateStatementOfWorkFinancialReports.update!
  end
end
