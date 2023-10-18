# frozen_string_literal: true

class IssuesController < ApplicationController
  before_action :set_issue, only: %i[show update destroy]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.where.not(closed_date: nil)
  end

  # GET /issues/1
  # GET /issues/1.json
  def show; end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      render :show, status: :created, location: @issue
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    if @issue.update(issue_params)
      render :show, status: :ok, location: @issue
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def issue_params
    params.require(:issue).permit(:effort, :user_id, :state, :closed_date)
  end
end
