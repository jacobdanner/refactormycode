require "#{File.dirname(__FILE__)}/../test_helper"

class CachingTest < ActionController::IntegrationTest
  fixtures :users, :codes
  
  def test_cache_browse_pages
    assert_cache_pages home_path,
                       recent_codes_path,
                       popular_codes_path,
                       recent_refactors_path,
                       best_refactorers_path
  end
  
  warn 'Ignoring: test_expire_browse_pages_on_update_code'
  def ignore_test_expire_browse_pages_on_update_code
    session = new_session_as :marc
    assert_expire_pages '/' do
      session.get code_path(1)
      session.put code_path(1), :code => { :title => "Won't you cache it baby, yeah!"}
      puts session.response.body
    end
  end
end
