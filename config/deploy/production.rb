set :deploy_to, "/www/sakai-widgetlibrary"
set :host, 'widgetstore'
role :app, host
role :web, host
role :db, host, :primary => true
set :rails_env, "production"
set :bundle_without, [:test, :development]

namespace :deploy do

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Restart Application by touching restart.txt (how mod_rails handles it)"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Install binstubs"
  task :binstubs, :roles => :app do
    run "cd #{current_release} && bundle --binstubs bin/"
  end

  desc "Link database"
  task :set_db, :roles => :app do
    run "ln -nfs #{shared_path}/db/production.sqlite3 #{current_release}/db/production.sqlite3"
  end
end
after "deploy:symlink", "deploy:set_db"
after "deploy:set_db", "deploy:binstubs"
