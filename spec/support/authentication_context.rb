# frozen_string_literal: true

RSpec.shared_context 'authentication' do
  let(:user_params) do
    {
      user: attributes_for(:user)
    }
  end

  let(:user_params_base64) { Base64.encode64(user_params.to_json) }

  before do
    request.headers.merge!(Authorization: "Bearer #{user_params_base64}")
  end
end
