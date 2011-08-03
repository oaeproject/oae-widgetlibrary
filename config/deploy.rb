default_run_options[:pty] = false
ssh_options[:forward_agent] = true
set :use_sudo, false

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@sakai-widgetlibrary'        # Or whatever env you want it to run in.
set :rvm_bin_path, "/usr/local/rvm/bin"

set :application, "widgetstore"

set :bundle_flags, "--deployment"

set :copy_compression, :bz2

# Deploy from our github repository
set :scm, :git
set :repository, "git@github.com:sakaiproject/sakai-widgetlibrary.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :scm_verbose, true