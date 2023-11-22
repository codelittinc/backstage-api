# frozen_string_literal: true

class IssuesJob
  include Sidekiq::Job

  def perform(*_args)
    CreateIssuesTask.create!
  end
end
