require File.dirname(__FILE__) + '/../test_helper'

class NotificationTest < Test::Unit::TestCase
  fixtures :notifications, :refactors, :codes, :users

  warn "NotificationTest#test_send_for disabled"
  def xtest_send_for
    refactor = Refactor.find(1)
    assert_equal 1, refactor.refactored_code.id
    
    Notification.delete_all
    Notification.create :code_id => 1, :name => 'Bob', :email => 'bob@example.com'
    Notification.create :code_id => 1, :name => 'Bob2', :email => 'bob2@example.com'
    Notification.create :code_id => 2, :name => 'Bob3', :email => 'bob3@example.com'
    # Do not notify the owner of the refactoring
    Notification.create :code_id => 1, :name => 'Owner', :email => refactor.user_email
    
    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      Notification.send_for(refactor)
    end
  end
  
  def test_user_info_takes_precendance_over_saved_data
    user = User.find(1)
    notif = Notification.create :code_id => 1, :user_id => 1, :name => 'Bob', :email => 'bob@example.com'
    notif.reload
    
    assert_equal user.name, notif.name
    assert_equal user.email, notif.email
  end
end
