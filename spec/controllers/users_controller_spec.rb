# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include_context 'authentication'
  render_views

  describe 'GET #index' do
    before(:each) do
      create_list(:user_service_identifier, 5)
    end

    context 'when there is no identifier' do
      it 'returns all users' do
        get :index
        expect(response.parsed_body.size).to eql(6)
      end
    end

    context 'when there is a identifier' do
      it 'returns only the user with the identifier' do
        user_service_identifier1 = create(:user_service_identifier)
        user1 = user_service_identifier1.user
        user_service_identifier2 = create(:user_service_identifier)
        user2 = user_service_identifier2.user
        get :index,
            params: { query: [user_service_identifier1.identifier, user_service_identifier2.identifier].join(',') }
        expect(response.parsed_body.pluck('id').sort).to eql([user1.id, user2.id].sort)
        expect(response.parsed_body.size).to eql(2)
      end
    end
  end

  describe 'GET #show' do
    context 'when user is logged in' do
      context 'and id is me' do
        it 'returns http success' do
          get :show, params: { id: 'me' }
          expect(response).to have_http_status(:success)
        end

        it 'returns the user data' do
          get :show, params: { id: 'me' }
          expect(response.parsed_body['email']).to eql(user_params[:user][:email])
        end
      end

      context "when the params are valid but the user doesn't exist" do
        it 'creates a new user' do
          expect do
            get :show, params: { id: 'me' }
          end.to change(User, :count).by(1)
        end

        it 'sets the user first name' do
          get :show, params: { id: 'me' }
          expect(response.parsed_body['first_name']).to eql(user_params[:user][:first_name])
        end

        it 'sets the user last name' do
          get :show, params: { id: 'me' }
          expect(response.parsed_body['last_name']).to eql(user_params[:user][:last_name])
        end

        it 'sets the user image_url' do
          get :show, params: { id: 'me' }
          expect(response.parsed_body['image_url']).to eql(user_params[:user][:image_url])
        end
      end

      context 'when user email is from a different domain than expected' do
        it 'returns an unauthorized access' do
          invalid_user_params = { user: attributes_for(:user, email: 'codelitt@wrongdomain.con') }
          invalid_user_params_base64 = Base64.encode64(invalid_user_params.to_json)

          request.headers.merge!(Authorization: "Bearer #{invalid_user_params_base64}")
          get :show, params: { id: 'me' }
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'and id is a number' do
        it 'returns the user with that id' do
          user = create(:user)
          get :show, params: { id: user.id }
          expect(response.parsed_body['email']).to eql(user.email)
        end
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of users' do
      create_list(:user, 5)
      get :index
      # 6 because one is created when we are authenticating
      expect(response.parsed_body.length).to eql(6)
    end
  end

  describe 'PUT #update' do
    let(:user) do
      create(:user)
    end

    context 'when user is logged in' do
      context 'with valid attributes' do
        let(:new_attributes) do
          {
            first_name: 'Updated',
            last_name: 'Name',
            salaries_attributes: [{ yearly_salary: 60_000, start_date: '2023-01-01' }]
          }
        end

        it 'updates the user' do
          put :update, params: { id: user.id, user: new_attributes }
          user.reload

          expect(user.first_name).to eq('Updated')
          expect(user.last_name).to eq('Name')
          expect(user.salaries.first&.yearly_salary).to eq(60_000)
        end

        it 'returns http success' do
          put :update, params: { id: user.id, user: new_attributes }
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { { email: 'not_an_email' } }

        it 'does not update the user' do
          put :update, params: { id: user.id, user: invalid_attributes }
          user.reload
          expect(user.email).not_to eq('not_an_email')
        end

        it 'returns http unprocessable_entity status' do
          put :update, params: { id: user.id, user: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
