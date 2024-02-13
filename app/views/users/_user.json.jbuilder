# frozen_string_literal: true

json.extract! user, :id, :active, :contract_type, :first_name,
              :last_name, :email, :google_id, :slug, :image_url, :seniority, :profession_id, :country, :internal

# Render the profession partial
json.profession user.profession, partial: 'professions/profession', as: :profession

# Render the permissions partial for each permission
json.permissions user.permissions, partial: 'permissions/permission', as: :permission

# Render the salaries partial for each salary
# json.salaries user.salaries, partial: 'salaries/salary', as: :salary

# Render the user_service_identifiers partial for each identifier
json.user_service_identifiers user.user_service_identifiers,
                              partial: 'user_service_identifiers/user_service_identifier', as: :user_service_identifier
