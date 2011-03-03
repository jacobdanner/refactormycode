server = "refactormycode.com"

set :application, "refactormycode"
set :server,      server
set :repository,  "http://code.macournoyer.com/private/refactormycode/trunk"

role :web,   server
role :app,   server
role :db,    server, :primary => true
role :cron,  server

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :runner, 'deploy'
set :user, 'deploy'

set :mongrel_rails, 'mongrel_rails'
set :mongrel_conf, "/etc/mongrel_cluster/#{application}.yml"

set :thin, {
  :environment => 'production',
  :user        => 'deploy',
  :port        => 5000,
  :group       => 'www-data',
  :servers     => 2,
  :socket      => '/tmp/thin.sock'
}