# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMakerProjectCreator, type: :service do
  def create_statement_of_work!
    create(:statement_of_work, :with_maintenance, id: 2)
  end

  def create_professions!
    Profession.create(name: 'Engineer')
    Profession.create(name: 'Project Manager')
    Profession.create(name: 'Designer')
  end

  def create_users!
    create(:user, email: 'pedro.guimaraes@codelitt.com')
    create(:user, email: 'vinicius.medeiros@codelitt.com')
    create(:user, email: 'jadson.dorneles@codelitt.com')
    create(:user, email: 'victor.carvalho@codelitt.com')
    create(:user, email: 'paulo.fernandes@codelitt.com')
    create(:user, email: 'gabriel@codelitt.com')
    create(:user, email: 'david.warren@codelitt.com')
    create(:user, email: 'leonardo.manrique@codelitt.com')
    create(:user, email: 'vinicius.aquino@codelitt.com')
  end

  def create_time_off_types!
    TimeOffType.create(name: 'vacation')
    TimeOffType.create(name: 'sick leave')
    TimeOffType.create(name: 'errand')
  end

  before do
    create_statement_of_work!
    create_professions!
    create_users!
    create_time_off_types!
  end

  describe '#call' do
    it 'creates the requirements' do
      VCR.use_cassette('clients#team-maker#list') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(Requirement, :count).by(8)
      end
    end

    it 'does not duplicate the requirement' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        StatementOfWork.all.each do |sow|
          TeamMakerProjectCreator.new(sow).call
          TeamMakerProjectCreator.new(sow).call
        end

        expect(Requirement.count).to eql(8)
      end
    end

    it 'creates the assignments' do
      VCR.use_cassette('clients#team-maker#list') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(Assignment, :count).by(9)
      end
    end

    it 'does not duplicate the assignments' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
            sow.reload
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(Assignment, :count).by(9)
      end
    end

    it 'creates the assignments time off entries' do
      VCR.use_cassette('clients#team-maker#list') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(TimeOff, :count).by(152)
      end
    end

    it 'does not duplicate the time off entries' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(TimeOff, :count).by(152)
      end
    end

    it 'creates the time entries' do
      VCR.use_cassette('clients#team-maker#list') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(TimeEntry, :count).by(405)
      end
    end

    it 'does not duplicate the time entries' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(TimeEntry, :count).by(405)
      end
    end

    it 'does not throw an error when the response from team maker is empty' do
      VCR.use_cassette('clients#team-maker#no-error-on-no-project') do
        create(:statement_of_work, :with_maintenance, id: 100)

        expect do
          StatementOfWork.all.each do |sow|
            TeamMakerProjectCreator.new(sow).call
          end
        end.to change(Requirement, :count).by(8)
      end
    end
  end
end
