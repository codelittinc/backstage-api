# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analytics::TimeEntriesController, type: :controller do
  include_context 'authentication'
  render_views

  describe 'GET #index' do
    context 'with the statement of work id' do
      it 'returns a success response' do
        valid_attributes = {
          statement_of_work_id: create(:statement_of_work, :with_maintenance).id,
          start_date: Date.yesterday,
          end_date: Date.tomorrow
        }

        get :index, params: valid_attributes
        expect(response).to be_successful
      end
    end

    context 'without the statement of work id' do
      it 'returns a success response' do
        valid_attributes = {
          start_date: Date.yesterday,
          end_date: Date.tomorrow
        }

        get :index, params: valid_attributes
        expect(response).to be_successful
      end
    end
  end
end
