require File.dirname(__FILE__) + '/../test_helper'
require 'browse_controller'

# Re-raise errors caught by the controller.
class BrowseController; def rescue_action(e) raise e end; end

class BrowseControllerTest < Test::Unit::TestCase
  ACTIONS           = %w(recent_codes popular_codes recent_refactors best_refactorers)
  FORMATTED_ACTIONS = ACTIONS - %w(best_refactorers)
  API_FORMATS       = %w(atom xml)
  
  def setup
    @controller = BrowseController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  ACTIONS.each do |method|
    define_method "test_#{method}" do
      get method
      assert_response :success
    end
  end
  
  FORMATTED_ACTIONS.each do |method|
    API_FORMATS.each do |format|
      define_method "test_#{method}_#{format}" do
        get method, :format => format
        assert_response :success
        get method, :format => format, :page => 2
        assert_response :success
      end
      
      define_method "test_#{method}_#{format}_with_language" do
        get method, :format => format, :language => 'Ruby'
        assert_response :success
        get method, :format => format, :language => 'Ruby', :page => 2
        assert_response :success
      end
    end
        
    define_method "test_#{method}_with_language" do
      get method, :language => 'Ruby'
      assert_response :success
      get method, :language => 'Ruby', :page => 2
      assert_response :success
    end
  end
  
  def test_search_with_no_query
    get :search, :q => ''
    
    assert_not_nil flash[:notice]
    assert_redirected_to home_path
  end
  
  def test_search
    get :search, :q => 'test'
    
    assert_response :success
    assert_not_nil assigns(:items)
  end
  
  def test_tags
    get :tags, :tags => 'cool'
    assert_response :success
    get :tags, :tags => 'cool', :page => 2
    assert_response :success
  end
  
  API_FORMATS.each do |format|
    define_method "test_tags_#{format}" do
      get :tags, :tags => 'cool', :format => format
      assert_response :success
      get :tags, :tags => 'cool', :format => format, :page => 2
      assert_response :success
    end
  end
end
