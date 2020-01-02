# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

Object.send(:remove_const, :ActiveRecord)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'mongoid-rspec'

Mongoid.load!(Rails.root.join("config", "mongoid.yml"))
# Add additional requires below this line. Rails is not loaded until this point!
Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }
require 'faker'

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
