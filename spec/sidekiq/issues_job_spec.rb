# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssuesJob, type: :job do
  it 'calls the CreateIssuesTask' do
    expect(CreateIssuesTask).to receive(:create!)
    IssuesJob.perform_sync
  end
end
