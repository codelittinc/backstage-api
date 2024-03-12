# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignmentsController, type: :controller do
  include_context 'authentication'
  render_views

  let(:valid_attributes) do
    user = create(:user)
    requirement = create(:requirement)
    attributes_for(:assignment, user_id: user.id, requirement_id: requirement.id)
  end

  describe 'GET #index' do
    let(:project) { create(:project) }
    let(:statement_of_work) { create(:statement_of_work, :with_maintenance, project:) }
    let(:secondary_statement_of_work) { create(:statement_of_work, project:) }
    let(:requirement) { create(:requirement, statement_of_work:) }
    let(:secondary_requirement) { create(:requirement, statement_of_work: secondary_statement_of_work) }

    before do
      create_list(:assignment, 2, coverage: 0.5, requirement:)
      create_list(:assignment, 5, coverage: 0.5, requirement: secondary_requirement)
    end

    context 'when given the project id' do
      it 'returns all the assignments of that project' do
        get :index,
            params: { filters: { start_date: Time.zone.today - 6.days, end_date: Time.zone.today + 6.days,
                                 project_id: project.id } }

        expect(response.parsed_body.size).to eq(7)
      end
    end

    context 'when given the statement of work id' do
      it 'returns all the requirements of that statement of work' do
        get :index,
            params: { filters: { start_date: Time.zone.today - 6.days, end_date: Time.zone.today + 6.days,
                                 statement_of_work_ids: [secondary_statement_of_work.id] } }

        expect(response.parsed_body.size).to eq(5)
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      assignment = Assignment.create! valid_attributes
      get :show, params: { id: assignment.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Assignment' do
        expect do
          post :create, params: { assignment: valid_attributes }
        end.to change(Assignment, :count).by(1)
      end

      it 'renders a JSON response with the new assignment' do
        post :create, params: { assignment: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.location).to eq(assignment_url(Assignment.last))
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          coverage: 1
        }
      end

      it 'updates the requested assignment' do
        assignment = Assignment.create! valid_attributes
        put :update, params: { id: assignment.to_param, assignment: new_attributes }
        assignment.reload
        expect(assignment.coverage).to eq(1.0)
      end

      it 'renders a JSON response with the assignment' do
        assignment = Assignment.create! valid_attributes
        put :update, params: { id: assignment.to_param, assignment: new_attributes }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested assignment' do
      assignment = Assignment.create! valid_attributes
      expect do
        delete :destroy, params: { id: assignment.to_param }
      end.to change(Assignment, :count).by(-1)
    end
  end
end
