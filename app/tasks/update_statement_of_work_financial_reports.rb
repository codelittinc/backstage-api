# frozen_string_literal: true

class UpdateStatementOfWorkFinancialReports
  def self.update!
    initial_date = 2.years.ago.beginning_of_day.to_date
    today = Time.zone.now.end_of_day.to_date

    StatementOfWorkFinancialReport.destroy_all

    StatementOfWork.active_in_period(initial_date, today).each do |statement_of_work|
      start_date = [initial_date, statement_of_work.start_date].max.to_date

      (start_date..today).each do |end_date|
        previous_period_model_calculator =
          Analytics::Finances::Calculators::CalculatorBuilder.build(statement_of_work,
                                                                    start_date, end_date)
        executed_income_to_start_date = previous_period_model_calculator.total_executed_income

        StatementOfWorkFinancialReport.create!(statement_of_work:, start_date:,
                                               end_date:, total_executed_income: executed_income_to_start_date)
      end
    end
  end
end
