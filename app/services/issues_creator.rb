# frozen_string_literal: true

class IssuesCreator < ApplicationService
  def initialize(project)
    super()
    @project = project
  end

  def call
    ActiveRecord::Base.transaction do
      @project.issues.destroy_all

      issues = issues_client_class.new(@project).list
      issues.map do |issue|
        next unless issue.valid?

        Issue.create!(project: @project, effort: issue.effort, user: issue.user, state: issue.state,
                      closed_date: issue.closed_date, title: issue.title,
                      issue_type: issue.issue_type, reported_at: issue.reported_at, tts_id: issue.tts_id, bug: issue.bug?,
                      parent_tts_id: issue.parent_tts_id)
      end.compact
    end
  rescue StandardError => e
    Rails.logger.error("Failed to process issues due to error: #{e.message}")
    raise
  end

  private

  def issues_client_class
    customer = @project.customer
    Object.const_get("Clients::Tts::#{customer.ticket_tracking_system.capitalize}::Issue")
  end
end
