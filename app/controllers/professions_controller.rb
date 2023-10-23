# frozen_string_literal: true

class ProfessionsController < ApplicationController
  def index
    @professions = Profession.all
  end
end
