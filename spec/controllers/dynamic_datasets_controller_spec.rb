# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DynamicDatasetsController, type: :controller do
  include_context 'authentication'
  render_views

  let(:project) { create(:project) }
  let(:dynamic_dataset) do
    code = 'Customer.all.pluck(:id, :name)'
    create(:dynamic_dataset, code:, project:)
  end

  before do
    create_list(:customer, 5)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      expected_result = [{
        'id' => dynamic_dataset.id,
        'name' => dynamic_dataset.name,
        'project_id' => dynamic_dataset.project_id,
        'data' => Customer.all.pluck(:id, :name)
      }]

      get :index, params: { project_id: project.id }

      expect(response.parsed_body).to eq(expected_result)
    end
  end
end
