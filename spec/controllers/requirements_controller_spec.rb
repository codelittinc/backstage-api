# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequirementsController, type: :controller do
  include_context 'authentication'
  render_views

  let(:project) { create(:project) }

  let(:statement_of_work) { create(:statement_of_work, :with_maintenance, project:) }

  let(:valid_attributes) do
    profession = create(:profession)
    attributes_for(:requirement, statement_of_work_id: statement_of_work.id,
                                 profession_id: profession.id)
  end

  describe 'GET #index' do
    let(:secondary_statement_of_work) { create(:statement_of_work, project:) }

    before do
      create_list(:requirement, 2, statement_of_work:)
      create_list(:requirement, 5, statement_of_work: secondary_statement_of_work)
    end

    context 'when given the project id' do
      it 'returns all the requirements of that project' do
        get :index,
            params: { start_date: Time.zone.today - 6.days, end_date: Time.zone.today + 6.days, project_id: project.id }

        expect(response.parsed_body.size).to eq(7)
      end
    end

    context 'when given the statement of work id' do
      it 'returns all the requirements of that statement of work' do
        get :index,
            params: { start_date: Time.zone.today - 6.days, end_date: Time.zone.today + 6.days,
                      statement_of_work_id: secondary_statement_of_work.id }

        expect(response.parsed_body.size).to eq(5)
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      requirement = create(:requirement, statement_of_work:)
      get :show,
          params: { id: requirement.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Requirement' do
        expect do
          post :create,
               params: { statement_of_work_id: statement_of_work.id,
                         requirement: valid_attributes }
        end.to change(Requirement, :count).by(1)
      end

      it 'renders a JSON response with the new requirement' do
        post :create,
             params: { statement_of_work_id: statement_of_work.id,
                       requirement: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:profession) { create(:profession) }

      let(:new_attributes) do
        {
          profession_id: profession.id
        }
      end

      it 'updates the requested requirement' do
        requirement = create(:requirement, statement_of_work:)
        put :update,
            params: {

              id: requirement.to_param,
              requirement: new_attributes
            }
        requirement.reload
        expect(requirement.profession).to eq(profession)
      end

      it 'renders a JSON response with the requirement' do
        requirement = create(:requirement, statement_of_work:)
        put :update,
            params: {

              id: requirement.to_param,
              requirement: new_attributes
            }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested requirement' do
      requirement = create(:requirement, statement_of_work:)
      expect do
        delete :destroy,
               params: { id: requirement.to_param }
      end.to change(Requirement, :count).by(-1)
    end
  end
end
