require File.dirname(__FILE__) + '/../test_helper'

class CodeTest < Test::Unit::TestCase
  fixtures :codes, :users
  
  def setup
    Code.any_instance.stubs(:announce_article!).returns(true)
    
    @code = Code.find(1)
  end

  def test_has_permalink
    code = create_code :title => 'This is a test'
    
    assert_equal 'this-is-a-test', code.permalink
  end
  
  def test_create_notification
    assert_increases 'Notification.count' do
      code = create_code :notify_me => '1'
      assert_valid code
    end
  end
  
  def test_notify_me_requires_email
    User.update 1, :email => ''
    code = create_code :notify_me => '1', :user_id => 1
    
    assert_not_nil code.errors.on(:user)
  end
  
  def test_dont_create_notification_twice
    code = create_code :notify_me => '1'
    
    assert_difference 'Notification.count', 0 do
      code.title = 'cool'
      code.save!
      code.notify_me = '1'
      code.save!
    end
  end
  
  def test_tag
    @code.tag_list = 'speed, short'
    @code.save
    
    assert_equal %w(speed short), @code.tag_list
    
    @code.tag_list.add 'cool'
    @code.save
    
    assert_equal %w(speed short cool), @code.tag_list
  end
  
  def test_find_by_tag
    test_tag
    assert_equal 1, Code.find_tagged_with('speed').size
  end
end
