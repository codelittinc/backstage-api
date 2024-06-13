# frozen_string_literal: true

class TimeOffsController < ApplicationController
  skip_before_action :authenticate

  def create
    if text.blank? || start_datetime.nil? || end_datetime.nil?
      render json: { message: 'Invalid parameters' }, status: :ok
      return
    end

    time_off = TimeOffBuilder.call(text, start_datetime, end_datetime)
    time_off&.save!
    success = time_off&.persisted?
    msg = success ? { id: time_off&.id } : 'The time of request creation failed'

    render json: msg, status: success ? :ok : :unprocessable_entity
  rescue StandardError => e
    logger.fatal "Error: TimeOffCreator: #{e.message}, Params: #{time_off_params}"

    render json: { message: e.message }, status: :internal_server_error
  end

  def destroy
    time_off = TimeOffBuilder.new(text, start_datetime, end_datetime).call
    found_time_off = TimeOff.where(user: time_off.user, starts_at: time_off.starts_at, ends_at: time_off.ends_at).first
    found_time_off&.destroy

    render json: { message: 'Time off request deleted' }, status: :ok
  end

  private

  def text
    @text ||= time_off_params[:text]
  end

  def start_datetime
    @start_datetime ||= time_off_params[:start_datetime]
  end

  def end_datetime
    @end_datetime ||= time_off_params[:end_datetime]
  end

  def time_off_params
    params.permit(:text, :start_datetime, :end_datetime).to_h
  end
end
