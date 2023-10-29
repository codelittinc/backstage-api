# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequirementsController, type: :controller do
  include_context 'authentication'
  render_views

  let(:project) { FactoryBot.create(:project) }
  let(:statement_of_work) { FactoryBot.create(:statement_of_work, :with_maintenance, project:) }

  let(:valid_attributes) do
    profession = FactoryBot.create(:profession)
    FactoryBot.attributes_for(:requirement, statement_of_work_id: statement_of_work.id,
                                            profession_id: profession.id)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      FactoryBot.create(:requirement, statement_of_work:)
      get :index, params: { project_id: project.id, statement_of_work_id: statement_of_work.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      requirement = FactoryBot.create(:requirement, statement_of_work:)
      get :show,
          params: { project_id: project.id, statement_of_work_id: statement_of_work.id,
                    id: requirement.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Requirement' do
        expect do
          post :create,
               params: { project_id: project.id, statement_of_work_id: statement_of_work.id,
                         requirement: valid_attributes }
        end.to change(Requirement, :count).by(1)
      end

      it 'renders a JSON response with the new requirement' do
        post :create,
             params: { project_id: project.id, statement_of_work_id: statement_of_work.id,
                       requirement: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:profession) { FactoryBot.create(:profession) }

      let(:new_attributes) do
        {
          profession_id: profession.id
        }
      end

      it 'updates the requested requirement' do
        requirement = FactoryBot.create(:requirement, statement_of_work:)
        put :update,
            params: { project_id: project.id,
                      statement_of_work_id: statement_of_work.id,
                      id: requirement.to_param,
                      requirement: new_attributes }
        requirement.reload
        expect(requirement.profession).to eq(profession)
      end

      it 'renders a JSON response with the requirement' do
        requirement = FactoryBot.create(:requirement, statement_of_work:)
        put :update,
            params: { project_id: project.id,
                      statement_of_work_id: statement_of_work.id,
                      id: requirement.to_param,
                      requirement: new_attributes }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested requirement' do
      requirement = FactoryBot.create(:requirement, statement_of_work:)
      expect do
        delete :destroy,
               params: { project_id: project.id, statement_of_work_id: statement_of_work.id,
                         id: requirement.to_param }
      end.to change(Requirement, :count).by(-1)
    end
  end
end
