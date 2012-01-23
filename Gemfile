source :rubygems

gem 'rails', '3.1.3'

# Use jQuery instead of Prototype
gem 'jquery-rails'

# Use Paperclip for image dependency management
gem "paperclip", "~> 2.3"

# Use rubyzip for serving zipped up widget files
gem "rubyzip"

# Use guid for generating random directory names in the tmp folder to
# use at the root dir for the widget generator.
gem 'guid'

# Use devise for user authentication
gem 'devise'

# Use CanCan for user authorization
gem 'cancan'

# Use reCAPTCHA
gem "recaptcha", :require => "recaptcha/rails"

# handle ajax image uploads
gem 'remotipart'

# Platforms without a native javascript interpreter can use this ruby one
gem 'therubyracer', :platforms => :ruby

# Use will_paginate for query and view pagination
gem 'will_paginate'

gem 'sass-rails', "  ~> 3.1.5"

group :test, :development do
  # Use factory_girl as a fixtures replacement
  gem "factory_girl_rails"
  gem 'sqlite3'
  # User faker for nice fake data generation
  gem 'ffaker'
  # Use populator to populate the db with fake data
  gem 'populator'
  gem "linecache19", "0.5.13"
  gem 'ruby-debug-base19', "0.11.26"
  gem 'ruby-debug19', "0.11.6"
end

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  # Allow for multi-stage deploys with Capistrano
  gem 'capistrano-ext'
  # Mailcatcher allows debugging of outgoing mail
  gem 'mailcatcher'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
end

# Assets for Rails 3.1
group :assets do
  gem 'mysql2'
  gem 'uglifier'
  gem 'yui-compressor'
end
