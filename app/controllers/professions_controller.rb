# frozen_string_literal: true

class ProfessionsController < ApplicationController
  # GET /professions
  # GET /professions.json
  def index
    @professions = Profession.all
  end
end
