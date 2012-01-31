set :deploy_to, "/www/sakai-widgetlibrary"
set :host, 'widgetstore'
role :app, host
role :web, host
role :db, host, :primary => true
set :rails_env, "production"
set :bundle_without, [:development, :test]

namespace :deploy do

 # no custom tasks needed for prod right now

end
