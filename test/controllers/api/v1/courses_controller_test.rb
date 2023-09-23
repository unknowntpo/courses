require "test_helper"

class Api::V1::CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get all courses" do
    get api_v1_get_courses_url
    assert_response :success
  end
end
