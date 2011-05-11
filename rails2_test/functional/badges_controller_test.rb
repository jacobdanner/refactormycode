require File.dirname(__FILE__) + '/../test_helper'
require 'badges_controller'

# Re-raise errors caught by the controller.
class BadgesController; def rescue_action(e) raise e end; end

class BadgesControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = BadgesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    login_as :marc
    get :index
    
    assert_response :success
    assert_equal users(:marc), assigns(:user)
    assert_equal 'text/html', @response.content_type
  end
  
  def test_index_not_logged_in
    get :index
    
    assert_redirected_to login_path
  end
  
  def test_position_gif
    get :position, :id => 1, :format => 'gif'
    assert_response :success
    assert_equal 'image/gif', @response.content_type
  end
  
  def test_position_gif_with_cache
    @controller.stubs(:perform_caching).returns(true)
    User.expects(:find).never
    
    @controller.expects(:read_fragment).returns("#{RAILS_ROOT}/public/images/positions/1.gif")
    
    get :position, :id => 1, :format => 'gif'
    
    assert_response :success
    assert_equal 'image/gif', @response.content_type
  end
end
