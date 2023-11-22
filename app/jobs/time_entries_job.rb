# frozen_string_literal: true

class TimeEntriesJob
  include Sidekiq::Job

  def perform(*_args)
    CreateTimeEntriesTask.create!
  end
end
