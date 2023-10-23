# frozen_string_literal: true

class CreateIssuesTask
  def self.create!
    projects = Project.active_on(Time.zone.today).with_ticket_system

    projects.each do |project|
      project.issues.destroy_all
      IssuesCreator.call(project)
    end
  end
end
