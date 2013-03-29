require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'

# Bundler tasks
require 'bundler/capistrano'

set :application, "BeamMeUp"
set :repository,  "git@github.com:adammulligan/BeamMeUp.git"

set :scm, :git

set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }

# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :user, "adam"
set :group, user
set :runner, user

set :host, "#{user}@koby.cyanoryx.com" # We need to be able to SSH to that box as this user.
role :web, host
role :app, host

set :rails_env, :production

# Where will it be located on a server?
set :deploy_to, "/var/www/upload.kobayashi.cyanoryx.com/#{application}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/apps.rb #{release_path}/config/apps.rb"
  end
end
