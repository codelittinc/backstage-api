# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMakerProjectCreator, type: :service do
  let(:project) do
    FactoryBot.create(:project, id: 2)
  end

  let(:professions) do
    Profession.create(name: 'Engineer')
    Profession.create(name: 'Project Manager')
    Profession.create(name: 'Designer')
  end

  let(:users) do
    FactoryBot.create(:user, email: 'pedro.guimaraes@codelitt.com')
    FactoryBot.create(:user, email: 'vinicius.medeiros@codelitt.com')
    FactoryBot.create(:user, email: 'jadson.dorneles@codelitt.com')
    FactoryBot.create(:user, email: 'victor.carvalho@codelitt.com')
    FactoryBot.create(:user, email: 'paulo.fernandes@codelitt.com')
    FactoryBot.create(:user, email: 'gabriel@codelitt.com')
    FactoryBot.create(:user, email: 'david.warren@codelitt.com')
    FactoryBot.create(:user, email: 'leonardo.manrique@codelitt.com')
    FactoryBot.create(:user, email: 'vinicius.aquino@codelitt.com')
  end

  before do
    TimeOffType.create(name: 'vacation')
    TimeOffType.create(name: 'sick leave')
    TimeOffType.create(name: 'errand')
  end

  describe '#call' do
    it 'creates the requirements' do
      VCR.use_cassette('clients#team-maker#list') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(Requirement, :count).by(8)
      end
    end

    it 'does not duplicate the requirement' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        project
        professions
        users

        Project.all.each do |project|
          TeamMakerProjectCreator.new(project).call
          TeamMakerProjectCreator.new(project).call
        end
        expect(Requirement.count).to eql(8)
      end
    end

    it 'creates the assignments' do
      VCR.use_cassette('clients#team-maker#list') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(Assignment, :count).by(9)
      end
    end

    it 'does not duplicate the assignments' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(Assignment, :count).by(9)
      end
    end

    it 'creates the assignments time off entries' do
      VCR.use_cassette('clients#team-maker#list') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(TimeOff, :count).by(152)
      end
    end

    it 'does not duplicate the time off entries' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(TimeOff, :count).by(152)
      end
    end

    it 'creates the time entries' do
      VCR.use_cassette('clients#team-maker#list') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(TimeEntry, :count).by(405)
      end
    end

    it 'does not duplicate the time entries' do
      VCR.use_cassette('clients#team-maker#does-not-duplicate') do
        project
        professions
        users

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(TimeEntry, :count).by(405)
      end
    end

    it 'does not throw an error when the response from team maker is empty' do
      VCR.use_cassette('clients#team-maker#no-error-on-no-project') do
        project
        professions
        users
        FactoryBot.create(:project, id: 100)

        expect do
          Project.all.each do |project|
            TeamMakerProjectCreator.new(project).call
          end
        end.to change(Requirement, :count).by(8)
      end
    end
  end
end
