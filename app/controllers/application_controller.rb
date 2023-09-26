# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_default_response_format

  before_action :authenticate
  attr_reader :current_user

  def authenticate
    user = User.find_or_initialize_by(user_params)
    return user_invalid! unless user.valid?

    user.save! if user.new_record?
    @current_user = user
  end

  def user_invalid!
    render_error('Invalid user', :unauthorized)
  end

  def render_error(message, status)
    render json: { error: message }, status:
  end

  def user_data
    authorization_header = request.headers['Authorization']
    token = authorization_header.gsub('Bearer ', '')
    @user_data ||= JSON.parse(Base64.decode64(token))
  end

  def user_params
    @user_params ||= user_data['user']
  end

  def valid_email_domain?
    user_params.match?(ENV.fetch('VALID_USER_DOMAIN', nil))
  end

  def set_default_response_format
    request.format = :json
  end
end
