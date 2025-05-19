# frozen_string_literal: true

json.extract! user, :id, :active, :contract_type, :first_name,
              :last_name, :email, :google_id, :slug, :image_url, :seniority, :profession_id, :country, :internal

# Render the permissions partial for each permission
json.permissions user.permissions, partial: 'permissions/permission', as: :permission

# Render the user_service_identifiers partial for each identifier
json.user_service_identifiers user.user_service_identifiers,
                              partial: 'user_service_identifiers/user_service_identifier', as: :user_service_identifier

json.user_skills user.user_skills, partial: 'user_skills/user_skill', as: :user_skill

json.assignments user.assignments, partial: 'assignments/assignment', as: :assignment
