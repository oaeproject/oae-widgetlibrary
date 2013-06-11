default_run_options[:pty] = false
ssh_options[:forward_agent] = true
set :use_sudo, false

set :stages, %w(production qa)
set :default_stage, "qa"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require "whenever/capistrano"

require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_type, :system
set :rvm_ruby_string, '1.9.3-p429@sakai-widgetlibrary'        # Or whatever env you want it to run in.
set :rvm_bin_path, "/usr/local/rvm/bin"
set :rvm_path, "/usr/local/rvm"

set :application, "widgetstore"

set :bundle_flags, "--deployment"

set :copy_compression, :bz2

# Deploy from our github repository
set :scm, :git
set :repository, "git://github.com/sakaiproject/sakai-widgetlibrary.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true

namespace :deploy do

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Set reCaptcha keys"
  task :recaptcha, :roles => :app do
    # Remove the dev captcha that is in github
    run "rm #{current_release}/config/initializers/recaptcha.rb"
    run "ln -nfs #{shared_path}/config/initializers/recaptcha.rb #{current_release}/config/initializers/recaptcha.rb"
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Set mailer settings"
  task :mailer_settings, :roles => :app do
    run "ln -nfs #{shared_path}/config/initializers/mailer_settings.rb #{current_release}/config/initializers/mailer_settings.rb"
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Symlink the database.yml file"
  task :db_symlink, :roles => :app do
    run "rm #{current_release}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{current_release}/config/database.yml"
  end

  desc "Symlink the backup config files"
  task :backup_symlink, :roles => :app do
    run "rm #{current_release}/db/backup/config.rb"
    run "ln -nfs #{shared_path}/db/backup/config.rb #{current_release}/db/backup/config.rb"
    run "rm #{current_release}/config/schedule.rb"
    run "ln -nfs #{shared_path}/config/schedule.rb #{current_release}/config/schedule.rb"
  end

  desc "Install binstubs"
  task :binstubs, :roles => :app do
    run "cd #{current_release} && bundle --binstubs bin/"
  end

  desc "Restart Application by touching restart.txt (how mod_rails handles it)"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

end

# need to do this right after update_code or the precompile won't work
after "deploy:update_code", "deploy:db_symlink"
after "deploy:update_code", "deploy:backup_symlink"

after "deploy:symlink", "deploy:binstubs"
after "deploy:binstubs", "deploy:recaptcha"
after "deploy:recaptcha", "deploy:mailer_settings"

before "deploy:restart", "delayed_job:restart"
after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"
