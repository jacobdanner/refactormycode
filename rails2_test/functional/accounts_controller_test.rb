require File.dirname(__FILE__) + '/../test_helper'
require 'accounts_controller'

# Re-raise errors caught by the controller.
class AccountsController; def rescue_action(e) raise e end; end

class AccountsControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = AccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    login_as :marc
  end

  def test_show
    get :show
    assert_response :success
  end
  
  def test_update
    put :update, :user => { :name => 'Bob', :email => 'cool@example.com' }
    assert_redirected_to account_url
    users(:marc).reload
    assert_equal 'Bob', users(:marc).name
  end
end
