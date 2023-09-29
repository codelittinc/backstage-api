# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include_context 'authentication'

  describe 'GET #me' do
    context 'when user is logged in' do
      it 'returns http success' do
        get :me
        expect(response).to have_http_status(:success)
      end

      it 'returns the user data' do
        get :me
        expect(response.parsed_body['email']).to eql(user_params[:user][:email])
      end
    end

    context "when the params are valid but the user doesn't exist" do
      it 'creates a new user' do
        expect do
          get :me
        end.to change(User, :count).by(1)
      end
    end

    xcontext 'when user email is from a different domain than expected' do
      it 'returns an unauthorized access' do
        invalid_user_params = { user: FactoryBot.attributes_for(:user, email: 'codelitt@wrongdomain.con') }
        invalid_user_params_base64 = Base64.encode64(invalid_user_params.to_json)

        request.headers.merge!(Authorization: "Bearer #{invalid_user_params_base64}")
        get :me
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of users' do
      FactoryBot.create_list(:user, 5)
      get :index
      # 6 because one is created when we are authenticating
      expect(response.parsed_body.length).to eql(6)
    end
  end
end
