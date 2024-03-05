# frozen_string_literal: true

class TeamMakerProjectCreator < ApplicationService
  attr_reader :statement_of_work

  def initialize(statement_of_work)
    super()
    @statement_of_work = statement_of_work.reload
  end

  def call
    data = Clients::TeamMaker::Data.new.list(statement_of_work.id)
    return if data.project.nil?

    create_requirements!(data.project_requirements)
    create_time_entries!(data.time_entries)
    create_time_off_entries!(data.time_offs)
  end

  private

  def create_time_off_entries!(time_offs)
    TimeOff.destroy_all

    time_offs.each do |time_off|
      time_off_type = TimeOffType.find_by(name: time_off.type)

      user = User.find_by(email: time_off.resource)
      next if user.nil? || time_off_type.nil?

      TimeOff.create!(starts_at: time_off.starts_on, ends_at: time_off.ends_on, user:, time_off_type:)
    end
  end

  def create_time_entries!(team_maker_project_time_entries)
    statement_of_work.time_entries.destroy_all

    team_maker_project_time_entries.each do |time_entry|
      user = find_user(time_entry.resource)

      TimeEntry.create!(
        statement_of_work:,
        date: time_entry.date,
        user:,
        hours: time_entry.hours
      )
    end
  end

  def create_requirements!(team_maker_project_requirements)
    statement_of_work.requirements.destroy_all

    team_maker_project_requirements.each do |requirement|
      req = create_requirement!(requirement)
      create_assignments!(requirement.assignments, req)
    end
  end

  def create_assignments!(team_maker_project_assignments, requirement)
    team_maker_project_assignments.each do |assignment|
      user = find_user(assignment.resource)

      Assignment.create!(
        requirement:,
        user:,
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
      profession: profession(team_maker_project_requirement.role),
      statement_of_work:
    )
  end

  def professions
    @professions ||= {
      'Engineering' => Profession.find_by(name: 'Engineer'),
      'Project Management' => Profession.find_by(name: 'Project Manager'),
      'Design' => Profession.find_by(name: 'Designer'),
      'UAT' => Profession.find_by(name: 'UX Researcher')
    }
  end

  def profession(name)
    # default behavior in case we don't have the profession here.
    professions[name] || Profession.find_by(name: 'Project Manager')
  end

  def find_user(email)
    user = User.find_by(email:)
    raise StandardError, "User with email #{email} does not exist" if user.nil?

    user
  end
end
