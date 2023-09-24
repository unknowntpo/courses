require 'rails_helper'

RSpec.describe "Api::V1::Courses", type: :request do
  let(:api_path) { "/api/v1/courses" }

  describe "GET /api/v1/courses" do
    before {get api_path}
    it "works! (now write some real specs)" do
      # get "/api/v1/courses"
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /api/v1/courses" do
    before { post api_path, params: course_params }

    context "with valid parameters" do
      let(:course_params) { { name: "Course Name", description: "Course Description" } } # Example valid params
      it 'new courses should be created' do
        expect(response).to have_http_status(200)
      end
    end
    context "when we create new courses with wrong params" do
      let(:course_params) { { name: "", description: "" } } # Example invalid params
      it 'should return bad request status code' do
        expect(response).to have_http_status(400)
      end
    end
  end
end
