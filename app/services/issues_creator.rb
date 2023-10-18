# frozen_string_literal: true

class IssuesCreator < ApplicationService
  def initialize(project)
    super()
    @project = project
  end

  def call
    issues = Clients::Tts::Azure::Issue.new(@project).list
    issues.map do |issue|
      next unless issue.user

      Issue.create!(
        effort: issue.effort,
        user: issue.user,
        state: issue.state,
        closed_date: issue.closed_date
      )
    end
  end
end
