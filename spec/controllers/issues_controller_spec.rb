require "rails_helper"

RSpec.describe IssuesController, type: :controller do
  include_context "authentication"
  render_views

  describe "GET #index" do
    it "returns a success response" do
      issue = FactoryBot.create(:issue)
      get :index
      expect(response).to be_successful
    end
  end
end
