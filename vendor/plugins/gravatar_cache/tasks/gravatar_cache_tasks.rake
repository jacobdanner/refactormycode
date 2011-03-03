namespace :gravatar do
  def gravatar_emails
    raise "Override gravatar_emails method to return the emails you wanna cache the Gravatars for.\n" +
          "eg.:\n" +
          "  def gravatar_emails\n" +
          "    User.find(:all).collect(&:email)\n" +
          "  end"
  end
  
  desc 'Setup the caching directory for the Gravatar image and a symlink in public/images for displaying them'
  task :setup do
    mkdir "#{RAILS_ROOT}/tmp/cache/gravatars" unless File.exist?("#{RAILS_ROOT}/tmp/cache/gravatars")
    ln_s "#{RAILS_ROOT}/tmp/cache/gravatars", "#{RAILS_ROOT}/public/images/gravatars" unless File.exist?("#{RAILS_ROOT}/public/images/gravatars")
  end
  
  desc 'Cache the Gravatars of the emails returned by gravatar_emails'
  task :cache => :environment do
    cached_emails = [nil, ''] # Default one we wanna ignore
    gravatar_emails.uniq.each do |email|
      unless cached_emails.include? email
        Gravatar.new(email).cache!
        cached_emails << email
      end
    end
    RAILS_DEFAULT_LOGGER.info "#{cached_emails.size-2} Gravatars cached"
  end
  
  desc 'Remove caching directories'
  task :remove do
    rm_rf "#{RAILS_ROOT}/public/images/gravatars"
    rm_rf "#{RAILS_ROOT}/tmp/cache/gravatars"
  end
end