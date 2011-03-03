require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < ActiveSupport::TestCase
  fixtures :users, :friendships
  
  def test_creation
    Friendship.delete_all
    
    users(:marc).friendships.create :friend => users(:arthur)
    users(:marc).reload
    
    assert_equal [users(:arthur)], users(:marc).friends
    assert_equal [users(:marc)], users(:arthur).fans
  end
  
  def test_cant_friend_yourself
    friendship = users(:marc).friendships.create :friend => users(:marc)
    assert_not_nil friendship.errors.on(:base)
  end
end
