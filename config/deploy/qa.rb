set :deploy_to, "/www/sakai-widgetlibrary-qa"
set :host, 'widgetstore'
role :app, host
role :web, host
role :db, host, :primary => true
set :rails_env, "qa"
set :bundle_without, [:development, :test]

namespace :deploy do

  desc "set up dummy data for the qa environment"
  task :dummy_data, :roles => :app do
    run "cd #{current_release} && rake environment RAILS_ENV=#{rails_env} setup:dev --trace"
  end

end
