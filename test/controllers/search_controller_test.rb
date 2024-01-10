require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_path
    assert_response :success
  end

  test "should get analytics" do 
    get analytics_path
    assert_response :success  
  end
end
