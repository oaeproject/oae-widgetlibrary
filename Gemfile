source :rubygems

gem 'rails', '3.2.6'

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
gem 'devise', '~> 1.5.3'

# Use CanCan for user authorization
gem 'cancan'

# Use for decode json strings to object
gem 'yajl-ruby'

#Use Markdown for parsing Markdown files
gem 'markdown'

# Use reCAPTCHA
gem "recaptcha", :require => "recaptcha/rails"

# Use Redcarpet for parsing Markdown files
gem 'redcarpet'

# handle ajax image uploads
gem 'remotipart'

# Platforms without a native javascript interpreter can use this ruby one
gem 'therubyracer', :platforms => :ruby

# Use will_paginate for query and view pagination
gem 'will_paginate'

# Autolink URLs in text
gem 'rails_autolink'

gem 'delayed_job_active_record'

gem 'daemons'

group :test, :development do
  # Use factory_girl as a fixtures replacement
  gem "factory_girl_rails"
  gem 'sqlite3'
  # User faker for nice fake data generation
  gem 'ffaker'
  # Use populator to populate the db with fake data
  gem 'populator'
  # Installation instructions are on
  # https://confluence.sakaiproject.org/display/3AK/Widget+Library+Development+Setup
  gem "linecache19", "0.5.13"
  gem 'ruby-debug-base19', "0.11.26"
  gem 'ruby-debug19', "0.11.6"
end

group :development do
  # Deploy with Capistrano
  gem 'rvm-capistrano'
  # Allow for multi-stage deploys with Capistrano
  gem 'capistrano-ext'
  # Mailcatcher allows debugging of outgoing mail
  gem 'mailcatcher'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'flexmock'
  gem 'simplecov'
end

# Assets for Rails 3.1
group :assets do
  # Use compass for out of the box mixins
  gem 'compass-rails'

  gem 'sass-rails', '~> 3.2.5'
  gem 'uglifier', ">= 1.0.3"
  gem 'yui-compressor'
end

group :qa, :production do
  gem 'mysql2'
  gem 'backup'
  gem 'whenever'
end
