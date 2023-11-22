# frozen_string_literal: true

class CreateIssuesTask
  def self.create!
    projects = Project.active_on(Time.zone.today).with_ticket_system.where(sync_ticket_tracking_system: true)

    projects.each do |project|
      ProjectIssuesWorker.perform_async(project.name)
    end
  end
end
