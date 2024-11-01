# frozen_string_literal: true

json.array! @user_skills, partial: 'user_skills/user_skill', as: :user_skill
