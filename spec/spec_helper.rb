require 'bundler/setup'
require 'mongoid'
require 'mongoid_list'

Dir["#{File.dirname(__FILE__)}/support/models/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    Mongoid.load!('spec/support/mongoid.yml', :test)

    Mongoid.logger.level = Logger::ERROR
    Mongo::Logger.logger.level = Logger::ERROR
  end

  config.before(:each) do
    Mongoid.client(:default).database.collections.each(&:drop)
  end
end
