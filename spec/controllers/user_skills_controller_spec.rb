# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSkillsController, type: :controller do
  let(:user) { double("User", id: 1) }
  let(:skill) { double("Skill", id: 1, name: 'Ruby') }
  let(:user_skill) { double("UserSkill", id: 1, user_id: user.id, skill_id: skill.id, years_of_experience: 3, last_applied_in_year: 2021, level: 'beginner') }

  before do
    # Mocking UserSkill model interactions
    allow(UserSkill).to receive(:where).and_return([user_skill])
    allow(UserSkill).to receive(:new).and_return(user_skill)
    allow(user_skill).to receive(:save).and_return(true)
    allow(user_skill).to receive(:destroy).and_return(true)
    allow(UserSkill).to receive(:find).and_return(user_skill)
  end

  describe 'GET #index' do
    it 'returns a list of user skills' do
      get :index, params: { user_id: user.id }

      expect(UserSkill).to have_received(:where).with(user_id: user.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'creates a new user skill' do
      post :create, params: {
        user_skill: {
          user_id: user.id,
          skill_id: skill.id,
          years_of_experience: 3,
          last_applied_in_year: 2021,
          level: 'beginner'
        }
      }

      expect(UserSkill).to have_received(:new).with(
        'user_id' => user.id.to_s,
        'skill_id' => skill.id.to_s,
        'years_of_experience' => '3',
        'last_applied_in_year' => '2021',
        'level' => 'beginner'
      )
      expect(user_skill).to have_received(:save)
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH #bulk_update' do
    it 'updates the user skills' do
      allow(UserSkill).to receive(:destroy_all).and_return(true)
      patch :bulk_update, params: {
        user_id: user.id,
        user_skills: [
          {
            last_applied_in_year: 2023,
            level: 'intermediate',
            years_of_experience: 2,
            skill_id: skill.id
          }
        ]
      }

      expect(UserSkill).to have_received(:destroy_all).with(user_id: user.id)
      expect(UserSkill).to have_received(:new).with(
        'last_applied_in_year' => 2023,
        'level' => 'intermediate',
        'years_of_experience' => 2,
        'skill_id' => skill.id,
        'user_id' => user.id
      )
      expect(user_skill).to have_received(:save)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user skill' do
      delete :destroy, params: { id: user_skill.id }

      expect(UserSkill).to have_received(:find).with(user_skill.id.to_s)
      expect(user_skill).to have_received(:destroy)
      expect(response).to have_http_status(:no_content)
    end
  end
end
