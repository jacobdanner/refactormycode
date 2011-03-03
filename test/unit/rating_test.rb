require File.dirname(__FILE__) + '/../test_helper'

class RatingTest < Test::Unit::TestCase
  fixtures :ratings, :refactors, :users

  def test_create
    assert_valid create_rating
  end
  
  def test_cant_rate_twice
    create_rating
    rating = create_rating
    
    assert_match /already rated/, rating.errors.on(:user_id)
  end
  
  def test_cache_rating_in_refactor
    assert_valid refactor = create_refactor(:user_id => 1)
    assert_valid rating = create_rating(:user_id => 2, :value => 1, :refactor_id => refactor.id)
    
    refactor.reload
    rating.reload
    
    assert_equal 1, refactor.rating
    assert_equal 1, refactor.user.rating
    assert_equal 1, refactor.ratings_count
    assert rating.user.rated?(refactor)
  end
  
  def test_rate_anonymous_refactor
    assert_valid refactor = create_refactor(:user_id => nil)
    assert_valid rating = create_rating(:user_id => 3, :value => 1, :refactor_id => refactor.id)
    
    refactor.reload
    assert_equal 1, refactor.rating
  end
  
  def test_cant_vote_on_own_refactoring
    assert_valid refactor = create_refactor(:user_id => 2)
    rating = create_rating(:user_id => 2, :value => 1, :refactor_id => refactor.id)
    
    assert_match /vote on his own/, rating.errors.on(:user_id)
  end
  
  def test_new_rating_updates_user_rating
    refactor1 = create_refactor(:user_id => 1)
    refactor2 = create_refactor(:user_id => 1)
    Rating.delete_all
    User.update 1, :rating => 0
    
    rating1 = 1
    rating2 = 3
    rating3 = 5
    
    # Rating 1
    create_rating :user_id => 2, :value => 1, :refactor_id => refactor1.id    
    assert_equal rating1, refactor1.reload.rating
    assert_equal rating1, User.find(1).rating
    
    # Rating 2
    create_rating :user_id => 3, :value => 3, :refactor_id => refactor1.id
    assert_equal (rating1 + rating2) / 2.0, refactor1.reload.rating
    assert_equal (rating1 + rating2) / 2.0, User.find(1).rating
    
    # Rating 3
    create_rating :user_id => 4, :value => 5, :refactor_id => refactor2.id
    assert_equal rating3, refactor2.reload.rating
    assert_equal ((rating1 + rating2) / 2 + rating3) / 2.0, User.find(1).rating
  end
end
