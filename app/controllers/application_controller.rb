# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_default_response_format

  before_action :authenticate
  attr_reader :current_user

  def authenticate
    user = User.find_or_initialize_by({
                                        email: user_params['email'],
                                        google_id: user_params['google_id']
                                      })
    return user_invalid! unless user.valid?

    save_user!(user) if user.new_record?

    @current_user = user
  end

  def save_user!(user)
    user.first_name = user_params['first_name']
    user.last_name = user_params['last_name']
    user.save!
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
    return @user_params if @user_params

    @user_params = user_data['user']
    @user_params['first_name'] = convert_to_utf8(@user_params['first_name'])
    @user_params['last_name'] = convert_to_utf8(@user_params['last_name'])
    @user_params
  end

  def valid_email_domain?
    user_params.match?(ENV.fetch('VALID_USER_DOMAIN', nil))
  end

  def set_default_response_format
    request.format = :json
  end

  def convert_to_utf8(str)
    str.force_encoding('ISO-8859-1').encode('UTF-8')
  end
end
