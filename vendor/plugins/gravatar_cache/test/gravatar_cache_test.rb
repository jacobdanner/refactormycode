$:.unshift File.dirname(__FILE__) + '/../lib'
require 'test/unit'
require 'logger'
require 'fileutils'

RAILS_ROOT = File.dirname(__FILE__) + '/fixtures'
RAILS_DEFAULT_LOGGER = Logger.new(nil)

require 'rubygems'
require 'mocha'
require 'active_support'
require 'action_pack'
require 'action_controller'
require 'gravatar'

unless ENV['REAL_REQUEST']
  class Gravatar
    def has_gravatar?
      email == 'macournoyer@yahoo.ca'
    end

    protected
      def wget
        # Do like is was downloaded
        File.open(cache_path, 'w') { |f| f << 'ouch' }
      end
  end
end

class GravatarTest < Test::Unit::TestCase
  def setup
    @cache_path = File.dirname(__FILE__) + '/fixtures/cache'
    FileUtils.mkdir_p @cache_path
    Gravatar.cache_path = @cache_path
    
    ActionController::Base.perform_caching = true
  end
  
  def teardown
    FileUtils.rm_rf @cache_path
  end
  
  def test_email_id
    assert_equal 'aa9c8aff95b1d8eb91ba15adc3e42802', Gravatar.new('my@mail.com').id
    assert_nil Gravatar.new(nil).id
  end
  
  def test_cached
    gravatar = Gravatar.new('macournoyer@yahoo.ca')
    assert ! gravatar.cached?
    gravatar.cache
    assert gravatar.cached?
  end
  
  def test_url
    gravatar = Gravatar.new('macournoyer@yahoo.ca')
    # No cache
    assert_equal 'gravatars/bfec5f7d1a4aaafc5a2451be8c42d26a.gif', gravatar.url
    assert File.symlink?("#{@cache_path}/#{gravatar.id}.gif")

    # Cache
    gravatar.cache
    assert_equal 'gravatars/bfec5f7d1a4aaafc5a2451be8c42d26a.gif', gravatar.url

    # No email
    assert_equal 'avatar.gif', Gravatar.new('').url
  end
  
  def test_has_gravatar
    assert ! Gravatar.new('nothiasdsd@asdasd.com').has_gravatar?
    assert   Gravatar.new('macournoyer@yahoo.ca').has_gravatar?
  end
  
  def test_cache!
    gravatar = Gravatar.new('macournoyer@yahoo.ca')
    gravatar.cache!
    assert File.exist?("#{@cache_path}/#{gravatar.id}.gif")
  end
  
  def test_cache
    gravatar = Gravatar.new('macournoyer@yahoo.ca')
    gravatar.expects(:cache!).once
    gravatar.cache
    
    gravatar.stubs(:cached?).returns(true)
    gravatar.expects(:cache!).never
    gravatar.cache
  end
  
  def test_cache_with_no_gravatar
    gravatar = Gravatar.new('asddsadfbg@asddas.com')
    gravatar.cache!
    assert File.exist?("#{@cache_path}/#{gravatar.id}.gif")
    assert File.symlink?("#{@cache_path}/#{gravatar.id}.gif")
  end
  
  def test_symlink_to_default_on_error
    gravatar = Gravatar.new('macournoyer@yahoo.ca')
    gravatar.expects(:wget).raises(RuntimeError)
    gravatar.cache!
    assert File.exist?("#{@cache_path}/#{gravatar.id}.gif")
    assert File.symlink?("#{@cache_path}/#{gravatar.id}.gif")
  end
end