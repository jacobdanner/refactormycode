require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_new
    get :new
    assert_response :success
  end
  
  def test_invalid_token_clears_cookie
    @request.cookies['token'] = auth_token('This is invalid, ok ?!')
    get :new
    assert_equal [], @response.cookies['token']
  end
  
  def test_create
    post :create, :openid_url => 'macournoyer.myopenid.com'
    assert_match 'http://www.myopenid.com/server', @response.redirected_to
  end
  
  def test_destroy
    delete :destroy
    assert_redirected_to home_url
  end
  
  def test_login_from_cookie
    users(:marc).create_token!
    @request.cookies["token"] = cookie_for(:marc)
    get :new
    assert_not_equal [], @response.cookies['token']
    assert @controller.send(:logged_in?)
  end
  
  private
    def auth_token(token)
      CGI::Cookie.new('name' => 'token', 'value' => token)
    end
    
    def cookie_for(person)
      auth_token users(person).token
    end
end
