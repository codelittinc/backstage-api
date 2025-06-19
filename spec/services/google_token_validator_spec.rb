# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GoogleTokenValidator do
  let(:google_client_id) { 'test-client-id.apps.googleusercontent.com' }
  let(:valid_token) { 'valid.google.token' }
  let(:invalid_token) { 'invalid.token' }

  before do
    allow(ENV).to receive(:fetch).with('GOOGLE_CLIENT_ID', nil).and_return(google_client_id)
  end

  describe '#valid?' do
    context 'with a valid Google ID token' do
      let(:mock_payload) do
        {
          'sub' => '115301847601843988893',
          'email' => 'kaio@codelitt.com',
          'given_name' => 'Kaio',
          'family_name' => 'Magalhães',
          'picture' => 'https://lh3.googleusercontent.com/a/ACg8ocIdlNzIlaLKZkAftfvCoQCQJlqEBJNIjF2LSaAKpRNlqoeyrUMw=s96-c',
          'aud' => google_client_id,
          'iss' => 'accounts.google.com',
          'exp' => 1.hour.from_now.to_i,
          'iat' => 1.hour.ago.to_i
        }
      end

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(valid_token, google_client_id)
          .and_return(mock_payload)
      end

      it 'returns true' do
        validator = described_class.new(valid_token)
        expect(validator.valid?).to be true
      end
    end

    context 'with an invalid token' do
      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(invalid_token, google_client_id)
          .and_raise(GoogleIDToken::ValidationError)
      end

      it 'returns false' do
        validator = described_class.new(invalid_token)
        expect(validator.valid?).to be false
      end
    end

    context 'with a blank token' do
      it 'returns false' do
        validator = described_class.new('')
        expect(validator.valid?).to be false
      end

      it 'returns false for nil token' do
        validator = described_class.new(nil)
        expect(validator.valid?).to be false
      end
    end

    context 'with an expired token' do
      let(:expired_payload) do
        {
          'sub' => '115301847601843988893',
          'aud' => google_client_id,
          'iss' => 'accounts.google.com',
          'exp' => 1.hour.ago.to_i,
          'iat' => 2.hours.ago.to_i
        }
      end

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(valid_token, google_client_id)
          .and_return(expired_payload)
      end

      it 'returns false' do
        validator = described_class.new(valid_token)
        expect(validator.valid?).to be false
      end
    end

    context 'with wrong audience' do
      let(:wrong_audience_payload) do
        {
          'sub' => '115301847601843988893',
          'aud' => 'wrong-client-id.apps.googleusercontent.com',
          'iss' => 'accounts.google.com',
          'exp' => 1.hour.from_now.to_i,
          'iat' => 1.hour.ago.to_i
        }
      end

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(valid_token, google_client_id)
          .and_return(wrong_audience_payload)
      end

      it 'returns false' do
        validator = described_class.new(valid_token)
        expect(validator.valid?).to be false
      end
    end

    context 'with wrong issuer' do
      let(:wrong_issuer_payload) do
        {
          'sub' => '115301847601843988893',
          'aud' => google_client_id,
          'iss' => 'malicious-site.com',
          'exp' => 1.hour.from_now.to_i,
          'iat' => 1.hour.ago.to_i
        }
      end

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(valid_token, google_client_id)
          .and_return(wrong_issuer_payload)
      end

      it 'returns false' do
        validator = described_class.new(valid_token)
        expect(validator.valid?).to be false
      end
    end
  end

  describe '#payload' do
    let(:mock_payload) do
      {
        'sub' => '115301847601843988893',
        'email' => 'kaio@codelitt.com',
        'given_name' => 'Kaio',
        'family_name' => 'Magalhães',
        'picture' => 'https://lh3.googleusercontent.com/a/ACg8ocIdlNzIlaLKZkAftfvCoQCQJlqEBJNIjF2LSaAKpRNlqoeyrUMw=s96-c',
        'aud' => google_client_id,
        'iss' => 'accounts.google.com',
        'exp' => 1.hour.from_now.to_i,
        'iat' => 1.hour.ago.to_i
      }
    end

    context 'with a valid token' do
      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(valid_token, google_client_id)
          .and_return(mock_payload)
      end

      it 'returns the payload' do
        validator = described_class.new(valid_token)
        expect(validator.payload).to eq(mock_payload)
      end
    end

    context 'with an invalid token' do
      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .with(invalid_token, google_client_id)
          .and_raise(GoogleIDToken::ValidationError)
      end

      it 'returns nil' do
        validator = described_class.new(invalid_token)
        expect(validator.payload).to be_nil
      end
    end
  end
end
