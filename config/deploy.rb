default_run_options[:pty] = false
ssh_options[:forward_agent] = true
set :use_sudo, false

set :stages, %w(production qa)
set :default_stage, "qa"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.3@sakai-widgetlibrary'        # Or whatever env you want it to run in.
set :rvm_bin_path, "/usr/local/rvm/bin"

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

  desc "Install binstubs"
  task :binstubs, :roles => :app do
    run "cd #{current_release} && bundle --binstubs bin/"
  end

  desc "Restart Application by touching restart.txt (how mod_rails handles it)"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

end
