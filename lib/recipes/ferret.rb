namespace :ferret do
  task :symlink do
    run <<-EOS
      mkdir -p #{shared_path}/index &&
      ln -nfs #{shared_path}/index #{release_path}/index
    EOS
  end
  before 'deploy:finalize_update', 'ferret:symlink'
  
  desc "Rebuild the Ferret index"
  task :rebuild do
    run "cd #{current_path} && rake RAILS_ENV=production ferret:rebuild"
  end
end