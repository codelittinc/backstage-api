# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfessionsController, type: :controller do
  include_context 'authentication'
  render_views

  describe 'GET #index' do
    it 'returns a success response' do
      create_list(:profession, 3)
      get :index
      expect(response).to be_successful
    end

    it 'returns a list of professions' do
      list = create_list(:profession, 3)
      get :index
      expect(response.parsed_body.first['id']).to eq(list.first.id)
    end
  end
end
