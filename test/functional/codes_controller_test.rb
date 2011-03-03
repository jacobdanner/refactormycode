require File.dirname(__FILE__) + '/../test_helper'
require 'codes_controller'

# Re-raise errors caught by the controller.
class CodesController; def rescue_action(e) raise e end; end

class CodesControllerTest < Test::Unit::TestCase
  fixtures :codes, :refactors, :users

  def setup
    @controller = CodesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    Code.any_instance.stubs(:announce_article!).returns(true)
  end

  def test_should_get_new
    login_as :marc
    get :new
    assert_response :success
  end
  
  def test_should_create_code
    login_as :marc
    assert_increases 'Code.count' do
      post :create, :code => { :title => 'Bazwel', :comment => 'hi', :code => 'def cool; end', :language => 'Ruby' }
    end
    
    assert_redirected_to code_path(assigns(:code))
  end

  def test_should_show_code
    get :show, :id => 1
    assert_response :success
  end
  
  def test_should_show_code_as_xml
    get :show, :id => 1, :fomat => 'xml'
    assert_response :success
    assert_select 'email', 0
    assert_select 'user_email', 0
  end

  def test_should_show_code_with_permalink
    get :show, :id => '1-first'
    assert_response :success
  end
  
  def test_show_pastable
    get :pastable, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    login_as :marc
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_not_edit_unless_author
    login_as :arthur
    assert_not_equal users(:arthur), Code.find(1).user
    get :edit, :id => 1
    assert_redirected_to code_path(:id => '1-first')
  end
  
  def test_should_update_code
    login_as :marc
    put :update, :id => 1, :code => { :code => '...' }
    assert_redirected_to code_path(assigns(:code))
  end
  
  def test_should_destroy_code
    login_as :marc
    assert_difference 'Code.count', -1 do
      delete :destroy, :id => 1
    end
    
    assert_redirected_to home_path
  end
  
  def test_follow_code
    Notification.delete_all
    login_as :marc
    assert_increases 'Notification.count' do
      xhr :post, :follow, :id => 1
    end
  end
  
  def test_follow_code_with_no_email_show_error
    users(:marc).update_attribute :email, nil
    login_as :marc
    assert_difference 'Notification.count', 0 do
      xhr :post, :follow, :id => 1
    end
    
    assert_not_nil assigns(:error)
  end
end
