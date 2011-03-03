namespace :deploy do
  def god(command)
    sudo "god #{command} thin-refactormycode", :as => 'root'
  end
  
  [:monitor, :start, :stop, :restart].each do |command|
    desc "Send #{command} command to Thin processes."
    task command, :roles => :app do
      god command
    end
  end
  
  task :status, :roles => :app do
    sudo "god status && free -m && df -h && uptime && ps aux | grep thin", :as => 'root'
  end
end

namespace :god do
  task :start, :roles => :app do
    sudo "god -c #{current_path}/config/thin.god", :as => 'root'
  end
  
  task :stop, :roles => :app do
    sudo "god quit", :as => 'root'
  end
end