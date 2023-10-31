# frozen_string_literal: true

class TeamMakerProjectCreator < ApplicationService
  attr_reader :project

  def initialize(project)
    super()
    @project = project
  end

  def call
    data = Clients::TeamMaker::Data.new.list(project.id)
    return if data.project.nil?

    create_requirements!(data.project_requirements)
    create_time_entires!(data.time_entries)
  end

  private

  def create_time_entires!(team_maker_project_time_entries)
    team_maker_project_time_entries.each do |time_entry|
      next if User.find_by(email: time_entry.resource).nil?

      user = User.find_by(email: time_entry.resource)

      TimeEntry.create!(
        statement_of_work:,
        date: time_entry.date,
        user:,
        hours: time_entry.hours
      )
    end
  end

  def create_requirements!(team_maker_project_requirements)
    team_maker_project_requirements.each do |requirement|
      req = create_requirement!(requirement)
      create_assignments!(requirement.assignments, req)
    end
  end

  def create_assignments!(team_maker_project_assignments, requirement)
    team_maker_project_assignments.each do |assignment|
      next if User.find_by(email: assignment.resource).nil?

      Assignment.create!(
        requirement:,
        user: User.find_by(email: assignment.resource),
        start_date: assignment.starts_on,
        end_date: assignment.ends_on,
        coverage: assignment.coverage
      )
    end
  end

  def create_requirement!(team_maker_project_requirement)
    Requirement.create!(
      coverage: team_maker_project_requirement.coverage,
      start_date: team_maker_project_requirement.starts_on,
      end_date: team_maker_project_requirement.ends_on,
      profession: professions[team_maker_project_requirement.role],
      statement_of_work:
    )
  end

  def professions
    @professions ||= {
      'Engineering' => Profession.find_by(name: 'Engineer'),
      'Project Management' => Profession.find_by(name: 'Project Manager'),
      'Designer' => Profession.find_by(name: 'Design')
    }
  end

  def statement_of_work
    return @statement_of_work if @statement_of_work

    @statement_of_work = @project.statement_of_works.first

    @statement_of_work ||= StatementOfWork.create!(
      project:,
      start_date: @project.start_date, end_date: @project.end_date,
      model: 'maintenance', hour_delivery_schedule: 'contract_period',
      total_revenue: 1
    )
    @statement_of_work.requirements.destroy_all
    @statement_of_work
  end
end
