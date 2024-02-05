# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatementOfWorksController, type: :controller do
  include_context 'authentication'
  render_views

  let(:project) { create(:project) }

  let(:valid_attributes) do
    obj = attributes_for(:statement_of_work, project_id: project.id)
    obj[:contract_model_attributes] =
      attributes_for(:maintenance_contract_model, contract_model_type: 'MaintenanceContractModel')
    obj
  end

  let(:invalid_attributes) do
    {
      start_date: Date.tomorrow,
      end_date: Date.yesterday
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create(:statement_of_work, :with_maintenance, project:)
      get :index, params: { project_id: project.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      statement_of_work = create(:statement_of_work, :with_maintenance, project:)
      get :show, params: { id: statement_of_work.to_param, project_id: project.id }
      expect(response.parsed_body['id']).to eql(statement_of_work.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new StatementOfWork' do
        expect do
          post :create, params: { statement_of_work: valid_attributes, project_id: project.id }
        end.to change(StatementOfWork, :count).by(1)
      end

      it 'renders a JSON response with the new statement_of_work' do
        post :create, params: { statement_of_work: valid_attributes, project_id: project.id }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new statement_of_work' do
        post :create, params: { statement_of_work: invalid_attributes, project_id: project.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          end_date: Time.zone.today + 2.days
        }
      end

      it 'updates the requested statement_of_work' do
        statement_of_work = create(:statement_of_work, :with_maintenance, project:)

        put :update,
            params: { id: statement_of_work.to_param, statement_of_work: new_attributes, project_id: project.id }
        statement_of_work.reload
        expect(statement_of_work.end_date.to_date).to eql(Time.zone.today + 2.days)
      end

      it 'renders a JSON response with the statement_of_work' do
        statement_of_work = create(:statement_of_work, :with_maintenance, project:)

        put :update,
            params: { id: statement_of_work.to_param, statement_of_work: new_attributes, project_id: project.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the statement_of_work' do
        statement_of_work = create(:statement_of_work, :with_maintenance, project:)

        put :update,
            params: { id: statement_of_work.to_param, statement_of_work: invalid_attributes, project_id: project.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested statement_of_work' do
      statement_of_work = create(:statement_of_work, :with_maintenance, project:)

      expect do
        delete :destroy, params: { id: statement_of_work.to_param, project_id: project.id }
      end.to change(StatementOfWork, :count).by(-1)
    end
  end
end
