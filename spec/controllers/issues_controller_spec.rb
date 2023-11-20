# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  include_context 'authentication'
  render_views

  describe 'GET #index' do
    it 'returns a success response' do
      project = create(:project)
      create(:issue, project:)
      get :index, params: { project_id: project.id }
      expect(response).to be_successful
    end

    it 'only returns issues of a specific project' do
      project1 = create(:project)
      project2 = create(:project)

      issue = create(:issue, project: project1)
      create(:issue, project: project2)
      create(:issue, project: project2)
      get :index, params: { project_id: project1.id }

      expect(response.parsed_body.pluck('id')).to eql([issue.id])
    end

    it 'when given start_date and end_date only brings the issues in that period' do
      project = create(:project)

      issue = create(:issue, project:, closed_date: '10/08/2020')

      create(:issue, project:, closed_date: '10/05/2020')
      create(:issue, project:, closed_date: '11/09/2020')
      get :index, params: { project_id: project.id, start_date: '10/07/2020', end_date: '10/9/2020' }

      expect(response.parsed_body.pluck('id')).to eql([issue.id])
    end
  end
end
