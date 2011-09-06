source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'sqlite3'

# Use jQuery instead of Prototype
gem 'jquery-rails'

# Use Paperclip for image dependency management
gem "paperclip", "~> 2.3"

# Use rubyzip for serving zipped up widget files
gem "rubyzip"

# Use guid for generating random directory names in the tmp folder to 
# use at the root dir for the widget generator.
gem 'guid'

# Deploy with Capistrano
gem 'capistrano'
# Allow for multi-stage deploys with Capistrano
gem 'capistrano-ext'

# Use devise for user authentication
gem 'devise'

# Use CanCan for user authorization
gem 'cancan'

group :test, :development do
  # Use factory_girl as a fixtures replacement
  gem "factory_girl_rails"
end

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
group :development do
  gem 'ruby-debug19', :require => 'ruby-debug'
end

# Assets for Rails 3.1
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'uglifier'
  gem 'yui-compressor'
end
