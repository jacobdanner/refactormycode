require File.dirname(__FILE__) + '/../test_helper'

class FriendsControllerTest < ActionController::TestCase
  fixtures :users, :friendships
  
  def test_should_show
    get :show, :user_id => users(:marc)
    assert_response :success
  end
  
  def test_should_show_as_atom
    get :show, :user_id => users(:marc), :format => "atom"
    assert_response :success
  end
  
  def test_should_create_code
    Friendship.delete_all
    
    login_as :marc
    assert_increases 'Friendship.count' do
      xhr :post, :create, :user_id => users(:arthur)
    end
    
    assert_response :success
  end
  
  def test_should_destroy_code
    assert users(:marc).friends.include?(users(:arthur))
    
    login_as :marc
    assert_difference 'Friendship.count', -1 do
      xhr :delete, :destroy, :user_id => users(:arthur)
    end
    
    assert_response :success
  end
end
