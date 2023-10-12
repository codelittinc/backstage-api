# frozen_string_literal: true

json.extract! user, :id, :created_at, :updated_at, :active, :contract_type, :first_name,
              :last_name, :email, :google_id, :slug, :image_url, :seniority, :profession_id, :country

# Render the profession partial
json.profession user.profession, partial: 'professions/profession', as: :profession

# Render the permissions partial for each permission
json.permissions user.permissions, partial: 'permissions/permission', as: :permission
