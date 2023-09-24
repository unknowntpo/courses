require 'rails_helper'

RSpec.describe "Api::V1::Courses", type: :request do
  describe "GET /api/v1/courses" do
    it "works! (now write some real specs)" do
      get "/api/v1/courses"
      expect(response).to have_http_status(200)
    end
  end
end
