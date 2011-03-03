require File.dirname(__FILE__) + '/../test_helper'
require 'refactors_controller'

# Re-raise errors caught by the controller.
class RefactorsController; def rescue_action(e) raise e end; end

class RefactorsControllerTest < Test::Unit::TestCase
  fixtures :refactors, :codes, :users

  def setup
    @controller = RefactorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @code = Code.find(1)
  end
  
  def test_index
    Refactor.expects(:defensio_stats).returns mock(:accuracy => 0.5, :spam => 1, :ham => 1,
                                                   :false_positives => 1, :false_negatives => 1)
    login_as :marc
    get :index
    assert_response :success
    assert_not_nil assigns(:refactors)
  end

  def test_create
    Refactor.any_instance.expects(:audit_comment)
    post :create, :code_id => 1, :refactor => { :user_name => 'Marc', :comment => 'Code' }
    
    # FIXME
    # assert_select_rjs :insert_html, :refactors
  end
  
  def test_create_when_logged_in
    Refactor.any_instance.expects(:audit_comment)
    login_as :marc
    
    post :create, :code_id => 1, :refactor => { :comment => 'Code' }
    
    # FIXME
    # assert_select_rjs :insert_html, :refactors
    assert_equal 'Marc', assigns(:refactor).user.name
  end
  
  def test_create_spam
    Refactor.any_instance.expects(:audit_comment)
    Refactor.any_instance.stubs(:spam).returns true
    post :create, :code_id => 1, :refactor => { :user_name => 'Marc', :comment => 'Code' }
    
    assert_template 'create'
    assert_select_rjs :replace_html, :new_refactor_notice
  end
  
  def test_cant_edit_unless_author
    login_as :arthur
    xhr :get, :edit, :code_id => 1, :id => 1
    assert_response :redirect
  end
  
  def test_edit
    login_as :marc
    xhr :get, :edit, :code_id => 1, :id => 1
    assert_response :success
  end
  
  def test_update
    login_as :marc
    xhr :put, :update, :code_id => 1, :id => 1
    assert_response :success
    assert assigns(:success)
  end
  
  def test_send_trackback
    @code.trackback_url = 'http://macournoyertest.wordpress.com/2007/09/08/hello-world/trackback/'
    @code.save
    Refactor.any_instance.expects(:audit_comment)
    Net::HTTP.expects(:post_form)
    
    post :create, :code_id => 1, :refactor => { :user_name => 'Marc', :comment => 'Code' }
  end
  
  def test_destroy
    login_as :marc
    xhr :delete, :destroy, :code_id => 1, :id => 1

    assert_template 'destroy'
  end
  
  def test_mark_as_ham
    Refactor.any_instance.expects(:report_as_ham)
    login_as :marc
    xhr :post, :mark_as_ham, :code_id => 1, :id => 1
    
    assert_template 'mark_as_ham'
    assert_not_nil assigns(:stats)
  end

  def test_mark_as_spam
    Refactor.any_instance.expects(:report_as_spam)
    login_as :marc
    xhr :post, :mark_as_spam, :code_id => 1, :id => 1
    
    assert_template 'destroy'
    assert_not_nil assigns(:stats)
  end
  
  def test_rate
    login_as :arthur
    xhr :post, :rate, :code_id => 1, :id => 1, :rating => 1
    
    assert_template 'rate'
    assert_match /1 rating/, @response.body
  end
end
