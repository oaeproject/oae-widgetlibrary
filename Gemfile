source 'http://rubygems.org'

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

group :test, :development do
  # Use factory_girl as a fixtures replacement
  gem "factory_girl_rails"
  gem 'sqlite3'
  # User faker for nice fake data generation
  gem 'ffaker'
  # Use populator to populate the db with fake data
  gem 'populator'
end

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  # Allow for multi-stage deploys with Capistrano
  gem 'capistrano-ext'
  # Use the Ruby debugger for Ruby 1.9.2+
  gem 'ruby-debug19', :require => 'ruby-debug'
end

# Assets for Rails 3.1
group :assets do
  gem 'sass-rails', "  ~> 3.1.5"
  gem 'uglifier'
  gem 'yui-compressor'
end
