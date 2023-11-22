# frozen_string_literal: true

class ProjectIssuesWorker
  include Sidekiq::Worker

  def perform(project_name)
    project = Project.find_by(name: project_name)
    IssuesCreator.call(project)
  end
end
