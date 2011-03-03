require File.dirname(__FILE__) + '/../test_helper'

class RefactorTest < Test::Unit::TestCase
  fixtures :refactors, :codes

  def test_validate_comment_or_code
    refactor = Refactor.new :language => 'Ruby', :user_name => 'Marc'
    assert !refactor.valid?, 'Should require comment'
    assert_not_nil refactor.errors.on(:comment)
    
    refactor.code = 'code'
    refactor.valid?
    assert_nil refactor.errors.on(:comment)
  end
  
  def test_create_notification
    assert_increases 'Notification.count' do
      refactor = create_refactor :notify_me => '1', :user_email => 'bob@example.com'
      assert_valid refactor
    end
  end
  
  def test_notify_me_requires_email
    refactor = create_refactor :notify_me => '1', :user_email => ''
    
    assert_not_nil refactor.errors.on(:user_email)
  end
  
  def test_dont_create_notification_twice
    test_create_notification
    
    assert_difference 'Notification.count', 0 do
      refactor = create_refactor :notify_me => '1', :user_email => 'bob@example.com'
      assert_valid refactor
    end
  end
  
  def test_user_info_takes_precendance_over_saved_data
    user = User.find(1)
    refactor = create_refactor :user_id => 1, :user_name => 'Bob', :user_email => 'bob@example.com'
    
    assert_equal user.name, refactor.user_name
    assert_equal user.email, refactor.user_email
  end
  
  def test_update_counter_caches
    assert_difference_in_counter_cache do
      create_refactor :user_id => 1, :code_id => 1
    end
  end
  
  def test_do_not_update_counter_caches_when_spam
    assert_difference_in_counter_cache 0 do
      create_refactor :user_id => 1, :code_id => 1, :spam => true
    end
  end
  
  def test_update_counter_caches_when_spamed
    refactor = create_refactor :user_id => 1, :code_id => 1
    assert_difference_in_counter_cache -1 do
      refactor.report_as_spam
    end
  end
  
  def test_update_counter_caches_when_unspamed
    refactor = create_refactor :user_id => 1, :code_id => 1, :spam => true
    assert_difference_in_counter_cache 1 do
      refactor.report_as_ham
    end
  end
  
  def test_destroy_decrement_counter
    refactor = create_refactor :user_id => 1, :code_id => 1
    assert_difference_in_counter_cache -1 do
      refactor.destroy
    end
  end
  
  def test_destroy_do_not_decrement_counter_if_spam
    refactor = create_refactor :user_id => 1, :code_id => 1, :spam => true
    assert_difference_in_counter_cache 0 do
      refactor.destroy
    end
  end
  
  def test_send_notifications
    Refactor.any_instance.expects(:send_notifications).once
    create_refactor :user_id => 1, :code_id => 1
  end
  
  def test_dont_send_notifications_when_spam
    Refactor.any_instance.expects(:send_notifications).never
    create_refactor :user_id => 1, :code_id => 1, :spam => true
  end
  
  def test_send_notifications_when_unspamed
    refactor = create_refactor :user_id => 1, :code_id => 1, :spam => true
    Refactor.any_instance.expects(:send_notifications).once
    refactor.report_as_ham
  end
  
  private
    def assert_difference_in_counter_cache(count=1)
      assert_increases 'Code.find(1).refactors_count', count do
        assert_increases 'User.find(1).refactors_count', count do
          yield
        end
      end
    end
end
