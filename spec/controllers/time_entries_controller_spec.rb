# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeEntriesController, type: :controller do
  include_context 'authentication'
  render_views
  let(:valid_attributes) do
    build(:time_entry).attributes
  end

  describe 'GET #index' do
    it 'returns a success response' do
      sow = create(:statement_of_work)
      sow2 = create(:statement_of_work)
      create_list(:time_entry, 8, statement_of_work: sow, date: Time.zone.today - 5.days)
      create_list(:time_entry, 5, statement_of_work: sow2, date: Time.zone.today - 8.days)

      get :index, params: {
        filters: {
          statement_of_work_ids: [sow.id],
          start_date: Time.zone.today - 6.days,
          end_date: Time.zone.today
        }
      }

      expect(response.parsed_body.size).to eq(8)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      time_entry = TimeEntry.create! valid_attributes
      get :show, params: { id: time_entry.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TimeEntry' do
        expect do
          post :create, params: { time_entry: valid_attributes }
        end.to change(TimeEntry, :count).by(1)
      end

      it 'renders a JSON response with the new time_entry' do
        post :create, params: { time_entry: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.location).to eq(time_entry_url(TimeEntry.last))
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          hours: 1.5
        }
      end

      it 'updates the requested time_entry' do
        time_entry = TimeEntry.create! valid_attributes
        put :update, params: { id: time_entry.to_param, time_entry: new_attributes }
        time_entry.reload
        expect(time_entry.hours).to eq(1.5)
      end

      it 'renders a JSON response with the time_entry' do
        time_entry = TimeEntry.create! valid_attributes
        put :update, params: { id: time_entry.to_param, time_entry: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['hours']).to eq(1.5)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested time_entry' do
      time_entry = TimeEntry.create! valid_attributes
      expect do
        delete :destroy, params: { id: time_entry.to_param }
      end.to change(TimeEntry, :count).by(-1)
    end
  end
end
