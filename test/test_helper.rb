require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'rake'
require 'flexmock'
require 'flexmock/test_unit'

class ActiveSupport::TestCase
end

class ActionController::TestCase
  include Devise::TestHelpers
end

DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  setup do
    call_rake("db:seed")
  end

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  def sign_in_as_user(user)
    visit root_path
    fill_in "user_username", :with => user.username
    fill_in "user_password", :with => user.password
    click_button 'useractions_login_button_login'
    user
  end

  def sign_out
    visit logout_path
  end

  def call_rake(task_name)
    # Make sure you're in the RAILS_ROOT
    oldpwd = Dir.pwd
    Dir.chdir(Rails.root)

    # Get an instance of rake
    rake_app = Rake.application
    rake_app.options.silent = true

    # Back to where you were
    Dir.chdir(oldpwd)

    rake_app.init
    rake_app.load_rakefile

    task = rake_app.tasks.detect {|t| t.name == task_name}
    assert_not_nil task, "No rake task defined: #{task_name}"
    task.reenable
    task.invoke
  end
end