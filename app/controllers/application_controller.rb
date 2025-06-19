# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_default_response_format
  before_action :authenticate
  attr_reader :current_user, :current_project

  def authenticate
    if authorization_header
      authenticate_user
    elsif project_auth_key
      authenticate_project
    else
      user_invalid!
    end
  end

  private

  def authenticate_user
    token = extract_token_from_header
    return user_invalid! unless token

    validator = GoogleTokenValidator.new(token)
    return user_invalid! unless validator.valid?

    google_payload = validator.payload
    return user_invalid! unless google_payload

    user = find_or_initialize_user(google_payload)
    return user_invalid! unless user&.valid?

    save_user_safely(user)
    @current_user = user
  end

  def extract_token_from_header
    authorization_header.gsub('Bearer ', '')
  end

  def find_or_initialize_user(google_payload)
    user = User.find_or_initialize_by(email: google_payload['email'])
    update_user_from_payload(user, google_payload)
    user
  end

  def update_user_from_payload(user, google_payload)
    user.email = google_payload['email']
    user.first_name = google_payload['given_name']
    user.last_name = google_payload['family_name']
    user.image_url = google_payload['picture']
    user.google_id = google_payload['sub']
  end

  def save_user_safely(user)
    user.save!
  rescue StandardError => e
    Rails.logger.error { "Failed to save user: #{e.message}" }
    false
  end

  def authenticate_project
    project_auth = ProjectReport.find_by(key: project_auth_key)
    return user_invalid! unless project_auth

    @current_project = project_auth.project
  end

  def save_user!(user)
    if user.new_record?
      user.first_name = user_auth_params['first_name']
      user.last_name = user_auth_params['last_name']
    end
    user.image_url = user_auth_params['image_url']
    user.save!
  end

  def user_invalid!
    render_error('Invalid user or project', :unauthorized)
  end

  def render_error(message, status)
    render json: { error: message }, status:
  end

  def user_data
    token = authorization_header.gsub('Bearer ', '')
    @user_data ||= JSON.parse(Base64.decode64(token))
  end

  def authorization_header
    request.headers['Authorization']
  end

  def project_auth_key
    request.headers['Project-Auth-Key']
  end

  def user_auth_params
    return @user_auth_params if @user_auth_params

    @user_auth_params = user_data['user']
    # move this normalization to the model
    @user_auth_params['first_name'] = convert_to_utf8(@user_auth_params['first_name'])
    @user_auth_params['last_name'] = convert_to_utf8(@user_auth_params['last_name'])
    @user_auth_params['image_url'] = @user_auth_params['image_url']
    @user_auth_params
  end

  def valid_email_domain?
    user_auth_params.match?(ENV.fetch('VALID_USER_DOMAIN', nil))
  end

  def set_default_response_format
    request.format = :json
  end

  def convert_to_utf8(str)
    str.force_encoding('ISO-8859-1').encode('UTF-8')
  end
end
