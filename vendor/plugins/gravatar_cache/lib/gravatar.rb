require 'net/http'
require 'md5'

# Base class for caching Gravatar (gravatar.com) locally.
# Usage:
# 
#   image_tag Gravatar.new('an@email.com').url
# 
# Based on http://svn.hiddenloop.com/public/plugins/mephisto_gravatar_cache/
# by Matthew Hutchinson
# and http://snippets.dzone.com/posts/show/2587
# by Daniel Haran
class Gravatar
  attr_reader :default, :size, :email, :host

  # Path to the temp dir in which Gravatar should be cached
  cattr_accessor :cache_path
  self.cache_path = "#{RAILS_ROOT}/tmp/cache/gravatars"
  
  def initialize(email, options={})
    @email   = email
    @default = options[:default] || "avatar.gif"
    @size    = options[:image]   || 80
    @host    = options[:host]
  end
  
  # Unique ID of the Gravatar
  def id
    @id ||= email.blank? ? nil : Digest::MD5.hexdigest(email)
  end
  
  # URL to the Gravatar...
  #  - in cache if cached
  #  - to default image if no email
  # You need to setup a symlink from public/gravatars to tmp/cache/gravatars for this to work
  def url
    return default if email.blank? || !ActionController::Base.perform_caching
    
    # If no yet cached, creates a place holder for when it is.
    # So it is usable inside a cached page.
    symlink_to_default unless cached?
    
    "gravatars/#{id}.gif"
  end
  
  # Path to the cached Gravatar
  def cached_path
    "#{self.class.cache_path}/#{id}.gif"
  end
  
  # Returns +true+ if the email corresponds to a Gravatar
  def has_gravatar?
    return false if email.blank?
    http = Net::HTTP.new('www.gravatar.com', 80)
    resp, data = http.get(gravatar_url, nil)
    # A redirection means he has no Gravatar
    resp.code.to_i == 200
  end
  
  # In cache?
  def cached?
    File.exists?(cached_path)
  end
  
  # Cache the Gravatar locally if not already done
  def cache
    cache! unless cached?
  end

  # Cache the Gravatar locally overriding older one if successfull
  def cache!
    return if email.blank?
    logger.info "[Gravatar] caching gravatar for #{email}"
    wget_path = cached_path + '.wget'
    
    if has_gravatar?
      logger.info "[Gravatar] Gravatar found for '#{email}', caching in #{cached_path}"
      # wget to a temp path, so if the process fails in the middle the previous cache
      # is not overriden.
      wget wget_path
      FileUtils.mv wget_path, cached_path
    else
      logger.info "[Gravatar] no Gravatar found for '#{email}', using #{default_path}"
      symlink_to_default
    end
  rescue Exception => e
    logger.error "[Gravatar] error while fetching gravatar for '#{email}': " +
                 "#{e.class.name} - #{e.message}"
  ensure
    # Wathever happened ensure and avatar is present and that no
    # tempfile is left
    FileUtils.rm_rf wget_path
    symlink_to_default unless File.exist?(cached_path)
  end
  
  protected
    def wget(to)
      `wget -r -O #{to} '#{gravatar_url}' &> /dev/null`
    end
  
    def gravatar_url
      return default_url if email.blank?
      "http://www.gravatar.com/avatar.php?size=#{size}&gravatar_id=#{id}&default=#{default_url}"
    end
  
    def default_url
      "#{host}/images/#{default}"
    end
    
    def default_path
      File.expand_path "#{RAILS_ROOT}/public/images/#{default}"
    end

    def host
      ActionController::Base.asset_host || @host || raise("Host required")
    end
    
    def logger
      RAILS_DEFAULT_LOGGER
    end
    
    def symlink_to_default
      FileUtils.rm_rf cached_path
      File.symlink default_path, cached_path
      cached_path
    end
end