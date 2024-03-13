# frozen_string_literal: true

RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)
  if Rails.env.production?
    config.authorize_with do
      authenticate_or_request_with_http_basic('Login required') do |username, password|
        username == ENV['ADMIN_USER'] && password == ENV['ADMIN_PASS']
      end
    end
  end

  config.main_app_name = %w[Backstage]

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.model 'Permission' do
    object_label_method do
      :name
    end
  end

  config.model 'UserPermission' do
    object_label_method do
      :name
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
