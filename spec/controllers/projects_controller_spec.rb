# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  include_context 'authentication'
  render_views

  let(:valid_attributes) do
    customer = create(:customer)
    {
      name: 'Project 1',
      customer_id: customer.id,
      billable: true,
      slack_channel: 'project-1'
    }
  end

  let(:invalid_attributes) do
    {
      customer_id: 0,
      name: '',
      billable: nil,
      slack_channel: ''
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Project.create! valid_attributes
      get :index, params: { filters: { active_only: 'false' } }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      project = Project.create! valid_attributes
      get :show, params: { id: project.to_param }
      expect(response).to be_successful
    end

    it 'returns the customer' do
      project = Project.create! valid_attributes
      get :show, params: { id: project.to_param }, format: :json

      expect(response.parsed_body['customer']['id']).to eq(project.customer.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect do
          post :create, params: { project: valid_attributes }
        end.to change(Project, :count).by(1)
      end

      it 'renders a JSON response with the new project' do
        post :create, params: { project: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.location).to eq(project_url(Project.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new project' do
        post :create, params: { project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Outnix'
        }
      end

      it 'updates the requested project' do
        project = Project.create! valid_attributes
        put :update, params: { id: project.to_param, project: new_attributes }
        project.reload
        expect(project.name).to eq('Outnix')
      end

      it 'renders a JSON response with the project' do
        project = Project.create! valid_attributes
        put :update, params: { id: project.to_param, project: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the project' do
        project = Project.create! valid_attributes
        put :update, params: { id: project.to_param, project: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested project' do
      project = Project.create! valid_attributes
      expect do
        delete :destroy, params: { id: project.to_param }
      end.to change(Project, :count).by(-1)
    end
  end
end
