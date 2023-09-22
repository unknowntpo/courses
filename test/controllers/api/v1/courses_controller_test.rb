require "test_helper"

class Api::V1::CoursesControllerTest < ActionDispatch::IntegrationTest
  test "should get –no-assets" do
    get api_v1_courses_–no-assets_url
    assert_response :success
  end
end
