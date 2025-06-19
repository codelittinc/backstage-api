# frozen_string_literal: true

require 'google-id-token'
require 'net/http'
require 'json'

class GoogleTokenValidator
  GOOGLE_PUBLIC_KEYS_URL = 'https://www.googleapis.com/oauth2/v1/certs'

  def initialize(token)
    @token = token
    @validator = GoogleIDToken::Validator.new
    Rails.logger.info "GoogleTokenValidator initialized with token: #{token[0..50]}..." if token.present?
  end

  def valid?
    return false if @token.blank?

    Rails.logger.info 'Starting Google token validation...'
    Rails.logger.info "Google Client ID from ENV: #{ENV.fetch('GOOGLE_CLIENT_ID', 'NOT_SET')}"

    validate_token_with_google
  rescue GoogleIDToken::ValidationError => e
    Rails.logger.error "GoogleIDToken::ValidationError: #{e.message}"
    false
  rescue JWT::DecodeError => e
    Rails.logger.error "JWT::DecodeError: #{e.message}"
    false
  rescue JWT::ExpiredSignature => e
    Rails.logger.error "JWT::ExpiredSignature: #{e.message}"
    false
  rescue StandardError => e
    Rails.logger.error "Unexpected error during token validation: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    false
  end

  def payload
    return nil unless valid?

    Rails.logger.info 'Extracting payload from valid token...'
    @validator.check(@token, ENV.fetch('GOOGLE_CLIENT_ID', nil))
  end

  private

  def validate_token_with_google
    Rails.logger.info 'Calling GoogleIDToken::Validator#check...'
    payload = @validator.check(@token, ENV.fetch('GOOGLE_CLIENT_ID', nil))

    unless payload
      Rails.logger.error 'GoogleIDToken::Validator#check returned nil'
      return false
    end

    Rails.logger.info "GoogleIDToken::Validator#check returned payload with keys: #{payload.keys}"

    validation_result = validate_payload(payload)
    Rails.logger.info "Payload validation result: #{validation_result}"
    validation_result
  end

  def validate_payload(payload)
    Rails.logger.info 'Validating payload...'

    return false unless validate_expiration(payload)
    return false unless validate_issued_time(payload)
    return false unless validate_audience(payload)
    return false unless validate_issuer(payload)

    Rails.logger.info 'All payload validations passed'
    true
  end

  def validate_expiration(payload)
    return true unless payload['exp']

    expiration_time = Time.zone.at(payload['exp'])
    current_time = Time.current
    valid = expiration_time > current_time

    Rails.logger.info "Token expiration check - Expires: #{expiration_time}, " \
                      "Current: #{current_time}, Valid: #{valid}"
    valid
  end

  def validate_issued_time(payload)
    return true unless payload['iat']

    issued_time = Time.zone.at(payload['iat'])
    current_time = Time.current
    valid = issued_time <= current_time

    Rails.logger.info "Token issued time check - Issued: #{issued_time}, " \
                      "Current: #{current_time}, Valid: #{valid}"
    valid
  end

  def validate_audience(payload)
    expected_audience = ENV.fetch('GOOGLE_CLIENT_ID', nil)
    actual_audience = payload['aud']
    valid = actual_audience == expected_audience

    Rails.logger.info "Audience check - Expected: #{expected_audience}, " \
                      "Actual: #{actual_audience}, Valid: #{valid}"
    valid
  end

  def validate_issuer(payload)
    issuer = payload['iss']
    valid_issuers = ['accounts.google.com', 'https://accounts.google.com']
    valid = valid_issuers.include?(issuer)

    Rails.logger.info "Issuer check - Issuer: #{issuer}, " \
                      "Valid issuers: #{valid_issuers}, Valid: #{valid}"
    valid
  end
end
