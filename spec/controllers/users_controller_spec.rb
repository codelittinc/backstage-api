# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user_params) do
    {
      user: FactoryBot.attributes_for(:user)
    }
  end

  let(:user_params_base64) { Base64.encode64(user_params.to_json) }

  describe 'GET #me' do
    context 'when user is logged in' do
      it 'returns http success' do
        request.headers.merge!(Authentication: user_params_base64)
        get :me
        expect(response).to have_http_status(:success)
      end

      it 'returns the user data' do
        request.headers.merge!(Authentication: user_params_base64)
        get :me
        expect(response.parsed_body['email']).to eql(user_params[:user][:email])
      end
    end

    context "when the params are valid but the user doesn't exist" do
      it 'creates a new user' do
        request.headers.merge!(Authentication: user_params_base64)
        expect do
          get :me
        end.to change(User, :count).by(1)
      end
    end

    context 'when user email is from a different domain than expected' do
      it 'returns an unauthorized access' do
        invalid_user_params = { user: FactoryBot.attributes_for(:user, email: 'codelitt@wrongdomain.con') }
        invalid_user_params_base64 = Base64.encode64(invalid_user_params.to_json)

        request.headers.merge!(Authentication: invalid_user_params_base64)
        get :me
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
