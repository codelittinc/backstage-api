# frozen_string_literal: true

class IssuesCreator < ApplicationService
  def initialize(project)
    super()
    @project = project
  end

  def call
    issues = issues_client_class.new(@project).list
    issues.map do |issue|
      next unless issue.user

      Issue.create!(project: @project, effort: issue.effort, user: issue.user, state: issue.state,
                    closed_date: issue.closed_date, issue_id: issue.issue_id, title: issue.title,
                    issue_type: issue.issue_type)
    end
  end

  private

  def issues_client_class
    customer = @project.customer
    Object.const_get("Clients::Tts::#{customer.ticket_tracking_system.capitalize}::Issue")
  end
end
