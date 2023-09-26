# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  include_context 'authentication'

  let(:valid_attributes) do
    {
      name: 'Codelitt'
    }
  end

  let(:invalid_attributes) do
    {
      name: ''
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CustomersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
      Customer.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
      customer = Customer.create! valid_attributes
      get :show, params: { id: customer.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Customer' do
        request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
        expect do
          post :create, params: { customer: valid_attributes }, session: valid_session
        end.to change(Customer, :count).by(1)
      end

      it 'renders a JSON response with the new customer' do
        request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
        post :create, params: { customer: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.location).to eq(customer_url(Customer.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new customer' do
        request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
        post :create, params: { customer: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          name: 'Codelitt - New Name'
        }
      end

      it 'updates the requested customer' do
        request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: new_attributes }, session: valid_session
        customer.reload
        expect(customer.name).to eq('Codelitt - New Name')
      end

      it 'renders a JSON response with the customer' do
        request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: new_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the customer' do
        request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested customer' do
      request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
      customer = Customer.create! valid_attributes
      expect do
        delete :destroy, params: { id: customer.to_param }, session: valid_session
      end.to change(Customer, :count).by(-1)
    end
  end
end
