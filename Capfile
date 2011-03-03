load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'config/deploy'
Dir['lib/recipes/*.rb'].each { |f| load f }

namespace :deploy do
  desc "Create asset packages for production" 
  task :build_assets, :roles => :web do
    run "cd #{release_path} && rake RAILS_ENV=production asset:packager:build_all"
  end
  after 'deploy:update_code', 'deploy:build_assets'
    
  task :symlink_dirs do
    run <<-EOS
      ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml &&
      ln -nfs #{shared_path}/cache/gravatars #{release_path}/public/images/gravatars
    EOS
  end
  before 'deploy:finalize_update', 'deploy:symlink_dirs'
end

task :delete_spam do
  run "cd #{current_path} && script/runner -e production \"Refactor.delete_all 'spam = 1'\""
end
