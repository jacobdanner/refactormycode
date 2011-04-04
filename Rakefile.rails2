require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :log do
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

task :setup do
  cp 'config/database_example.yml', 'config/database.yml' unless File.exist?('config/database.yml')
  Rake::Task['cache:setup'].invoke
end

namespace :cache do
  def gravatar_emails
    User.find(:all).collect(&:email) + Refactor.find(:all).collect(&:user_email)
  end
  
  task :setup => 'gravatar:setup'
  
  task :all => 'gravatar:cache'
  
  desc 'Clears the cache'
  task :clear do
    %w(codes refactorers refactorings index.html users tags).each { |f| rm_rf "#{RAILS_ROOT}/public/#{f}" }
    # Do not remove Gravatars
    rm_rf (Dir["#{RAILS_ROOT}/tmp/cache/**"] - Dir["#{RAILS_ROOT}/tmp/cache/gravatars"])
    Rake::Task['cache:setup'].invoke
  end
end

namespace :ferret do
  task :rebuild => :environment do
    Code.rebuild_index Refactor
  end
end