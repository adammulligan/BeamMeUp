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

# Unicorn control tasks
namespace :deploy do
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/apps.rb #{release_path}/config/apps.rb"
  end
end

namespace :god do
  def god_is_running
    !capture("#{god_command} status >/dev/null 2>/dev/null || echo 'not running'").start_with?('not running')
  end

  def god_command
    "cd #{current_path}; bundle exec god"
  end

  desc "Stop god"
  task :terminate_if_running do
    if god_is_running
      run "if [ -f #{deploy_to}/current ]; then #{god_command} terminate; fi"
    end
  end

  desc "Start god"
  task :start do
    config_file = "#{current_path}/config/unicorn.god"
    run "#{god_command} -c #{config_file}", :env => { PAD_ROOT: "#{deploy_to}/current" }
  end
end

before "deploy:update", "god:terminate_if_running"
after "deploy:update", "god:start"

after 'deploy:update_code', 'deploy:symlink_shared'
