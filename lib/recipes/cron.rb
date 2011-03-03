namespace :cron do
  desc 'Install the cronjobs'
  task :start, :roles => :cron do
    run "crontab #{current_path}/config/crontab.conf"
  end
  
  desc 'Remove and stop registered cronjobs'
  task :stop, :roles => :cron do
    run "crontab -r"
  end
end
