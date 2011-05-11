require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_create_token
    assert_not_nil users(:marc).create_token!
    assert_not_nil users(:marc).token
  end
  
  def test_position
    best = create_user
    worst = create_user
    
    best.update_attribute :rating, 5
    worst.update_attribute :rating, 2
    
    assert_equal 1, best.position
    assert_equal 2, worst.position
  end
  
  def test_position_with_decimal
    user = create_user
    
    user.update_attribute :rating, 5.1
    assert_equal 1, user.position
    
    user.update_attribute :rating, 5.9
    assert_equal 1, user.position
  end
  
  def test_position_image
    assert_match '/1.gif', mocked_user(:position => 1).position_image
    assert_match '/9.gif', mocked_user(:position => 9).position_image
    assert_match '/top10.gif', mocked_user(:position => 10).position_image
    assert_match '/top20.gif', mocked_user(:position => 11).position_image
    assert_match '/top20.gif', mocked_user(:position => 20).position_image
    assert_match '/top30.gif', mocked_user(:position => 30).position_image
    assert_match '/top100.gif', mocked_user(:position => 99).position_image
    assert_match '/top1000.gif', mocked_user(:position => 101).position_image
    assert_match '/top10000.gif', mocked_user(:position => 2000).position_image
    assert_match '/top10000.gif', mocked_user(:position => 9999999999999999).position_image
  end
  
  def test_create_without_username
    user = User.create(:identity_url => 'http://somethingthatdoesnotexist.myopenid.com')
    
    assert_valid user
    assert_equal 'somethingthatdoesnotexist.myopenid.com', user.name
  end
  
  def test_create_with_username
    user = User.create(:identity_url => 'http://somethingthatdoesnotexist.myopenid.com', :name => 'test')
    
    assert_valid user
    assert_equal 'test', user.name
  end
  
  def test_find_by_identity_url_ignores_trailing_slash
    User.expects(:create).never
    assert_equal users(:marc), User.find_or_create_by_identity_url(users(:marc).identity_url)
    assert_equal users(:marc), User.find_or_create_by_identity_url(users(:marc).identity_url + '/')
  end
  
  def test_find_by_alternative_identity_url
    User.expects(:create).never
    assert_equal users(:marc), User.find_or_create_by_identity_url(users(:marc).alternative_identity_url)
  end
  
  def test_create_by_identity_url
    user = User.find_or_create_by_identity_url('http://ma.myopenid.com', 'nickname' => 'ma', 'email' => 'ma@example.com')
    
    assert_valid user
    assert_equal 'http://ma.myopenid.com', user.identity_url
    assert_equal 'ma', user.name
    assert_equal 'ma@example.com', user.email
  end
  
  private    
    def mocked_user(attributes={})
      user = User.new
      attributes.each_pair do |attr, value|
        user.stubs(attr).returns value
      end
      user
    end
end
