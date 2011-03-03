namespace :db do
  desc "Backup the database"
  task :backup, :roles => :db, :only => { :primary => true } do
    filename = "rmc-dump-#{Time.now.strftime('%Y%m%dT%-%H%M%S')}.bz2" 
    on_rollback { run "rm -f /tmp/#{filename}" }
    run "mysqldump -urmc -pha5esskl refactormycode | bzip2 -c > /tmp/#{filename}" do |channel, stream, data|
      puts data
    end
    get "/tmp/#{filename}", "/Users/ma/backup/#{filename}"
    run "rm /tmp/#{filename}"
  end
end