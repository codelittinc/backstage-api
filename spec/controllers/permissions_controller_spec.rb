# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionsController, type: :controller do
  include_context 'authentication'
  render_views

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns a list of permissions' do
      permissions = FactoryBot.create_list(:permission, 3)
      get :index
      expect(response.parsed_body.first['id']).to eq(permissions.first.id)
    end
  end
end
