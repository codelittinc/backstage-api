# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  include_context 'authentication'
  render_views

  let(:valid_attributes) do
    {
      statement_of_work_id: FactoryBot.create(:statement_of_work, :with_maintenance).id,
      start_date: Date.yesterday,
      end_date: Date.tomorrow
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: valid_attributes
      expect(response).to be_successful
    end
  end
end
