# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :set_default_response_format
  before_action :authenticate
  attr_reader :current_user

  def authenticate
    if authorization_header
      authenticate_user
    elsif customer_service_auth_key
      authenticate_customer_service
    else
      user_invalid!
    end
  end

  private

  def authenticate_user
    user = User.find_or_initialize_by({
                                        email: user_auth_params['email'],
                                        google_id: user_auth_params['google_id']
                                      })
    return user_invalid! unless user.valid?

    save_user!(user)
    @current_user = user
  end

  def authenticate_customer_service
    customer_service_auth = CustomerServiceAuth.find_by(auth_key: customer_service_auth_key)
    return user_invalid! unless customer_service_auth

    @current_user = customer_service_auth.customer
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
    render_error('Invalid user', :unauthorized)
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

  def customer_service_auth_key
    request.headers['Customer-Service-Auth-Key']
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
