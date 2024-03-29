# frozen_string_literal: true

class TimeOffBuilder < ApplicationService
  def initialize(text, start_datetime, end_datetime)
    @text = text
    @start_datetime = start_datetime.to_time
    @end_datetime = end_datetime.to_time
  end

  def call
    return nil if invalid_params?

    return raise("Many users with the same name. Users: #{users}") unless users.count.eql?(1)
    return raise("No user found with the name #{user_name}") if users.count.eql?(0)

    build_time_off(users.first)
  end

  def build_time_off(user)
    TimeOff.new(
      user:,
      starts_at: @start_datetime,
      ends_at: @end_datetime,
      time_off_type:
    )
  end

  private

  def time_off_type
    TimeOffType.find_or_create_by!(name: time_off_name)
  end

  def users
    @users = User.by_name(user_name)
  end

  def invalid_params?
    @text.blank? || (@start_datetime.nil? || @end_datetime.nil?)
  end

  def user_name
    name_match = @text.match(/^([\w'-]+(?:\s+[\w'-]+)*)(?:\s+on|\s+is)/i)
    name_match ? name_match[1] : @text
  end

  def time_off_name
    case @text
    when /.*Paid Time Off.*/
      'vacation'
    when /.*Unpaid Time Off.*/
      'unpaid leave'
    when /.*Errand.*/, /.*Out of Office.*/
      'errand'
    when /.*Sick.*/
      'sick leave'
    end
  end
end
