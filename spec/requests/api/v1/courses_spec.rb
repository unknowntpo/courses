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

  describe "GET /api/v1/courses/:id" do
    let(:course) { FactoryBot.create(:course) } # Assuming you're using FactoryBot or a similar factory tool
    before { get "#{api_path}/#{course.id}" }

    it 'returns the specified course' do
      expect(response).to have_http_status(200)
      # Optionally, test for the presence of specific data in the response:
      # expect(response.body).to include(course.name)
    end
  end

  describe "PATCH /api/v1/courses/:id" do
    let(:course) { FactoryBot.create(:course) }
    let(:updated_params) { { name: "Updated Course Name" } }
    before { patch "#{api_path}/#{course.id}", params: updated_params }

    it 'updates the course' do
      expect(response).to have_http_status(200)
      # Optionally, verify that the course got updated
      # expect(course.reload.name).to eq("Updated Course Name")
    end
  end

  describe "DELETE /api/v1/courses/:id" do
    let!(:course) { FactoryBot.create(:course) } # Use let! to eagerly create the course before the test runs
    before { delete "#{api_path}/#{course.id}" }

    it 'deletes the course' do
      expect(response).to have_http_status(204) # 204 No Content is often used for successful DELETE requests
      # Optionally, ensure the course was actually deleted
      # expect(Course.find_by(id: course.id)).to be_nil
    end
  end
end
