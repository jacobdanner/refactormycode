namespace :mongrel do
  desc 'Start Mongrel processes on the app server.'
  task :start, :roles => :app do
    run "#{mongrel_rails} cluster::start -C #{mongrel_conf}"
  end
  
  desc 'Stop the Mongrel processes on the app server.'
  task :stop, :roles => :app do
    run "#{mongrel_rails} cluster::stop -C #{mongrel_conf}"
  end

  desc 'Restart the Mongrel processes on the app server by starting and stopping the cluster.'
  task :restart, :roles => :app do
    run "#{mongrel_rails} cluster::restart -C #{mongrel_conf}"
  end
  
  desc 'Check the status of the Mongrel processes on the app server.'
  task :status, :roles => :app do
    run "#{mongrel_rails} cluster::status -C #{mongrel_conf}"
  end
end