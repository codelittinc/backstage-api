# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clients::TeamMaker::Data, type: :service do
  describe '#list' do
    it 'returns a project' do
      VCR.use_cassette('clients#team-maker#list') do
        result = Clients::TeamMaker::Data.new.list(1)
        expect(result.project.name).to eql('Donor Direct - development')
      end
    end
  end
end
