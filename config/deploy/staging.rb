set :deploy_to, "/www/widgetstore"
set :host, 'widgetstore'
role :app, host
role :web, host
role :db, host, :primary => true
set :rails_env, "test"

namespace :deploy do

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Restart Application by touching restart.txt (how mod_rails handles it)"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "set ENV['RAILS_ENV'] for mod_rails (phusion passenger)"
  task :set_rails_env, :roles => :app do
    tmp = "#{current_release}/tmp/environment.rb"
    final = "#{current_release}/config/environment.rb"
    run <<-CMD
      echo 'ENV["RAILS_ENV"] = "#{rails_env}"' > #{tmp};
      cat #{final} >> #{tmp} && mv #{tmp} #{final};
    CMD
  end
  desc "Link database"
  task :set_db, :roles => :app do
    run "ln -nfs #{shared_path}/db/test.sqlite3 #{current_release}/db/test.sqlite3"
  end
end
after "deploy:symlink", "deploy:set_db"
after "deploy:set_db", "deploy:set_rails_env"