namespace :cache do
  task :symlink do
    run "ln -nfs #{shared_path}/cache #{release_path}/tmp/cache"
  end
  before 'deploy:finalize_update', 'cache:symlink'
  
  desc "Clears the cache on the server"
  task :clear do
    run "cd #{release_path} && rake RAILS_ENV=production cache:clear"
  end
  
  desc "Renew cache"
  task :all do
    run "cd #{release_path} && rake RAILS_ENV=production cache:all"
  end
end