# frozen_string_literal: true

class CreateTimeEntriesTask
  def self.create!
    projects = Project.all

    projects.each do |project|
      TeamMakerProjectCreator.new(project).call
    end
  end
end
