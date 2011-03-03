require File.dirname(__FILE__) + '/../test_helper'

class CodesMailerTest < Test::Unit::TestCase
  fixtures :refactors, :users

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end
  
  def test_new_refactoring
    refactor = Refactor.find(1)
    user = User.find(1)
    mail = CodesMailer.create_new_refactoring(refactor, user.name, user.email).encoded
    
    assert_field_equal user.email, mail, :to
    assert_field_equal "New refactoring on #{refactor.refactored_code.title}", mail, :subject
    
    assert_match %r/(\w|\s)+ #{user.name}/, mail
    assert_match refactor.refactored_code.title, mail
    assert_match %r{http://refactormycode.com/codes/}, mail
  end
  
  def assert_field_equal(expected, email, field)
    match = email.match(/#{field}: (.*)/i)
    assert_not_nil match, "Field '#{field}' not found in email"
    actual = match[1].chomp
    assert_equal expected, actual
  end
end
