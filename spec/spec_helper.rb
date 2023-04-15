$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trackstamps/reborn'

require 'database_cleaner'
require 'with_model'

require 'dry/configurable/test_interface'

DatabaseCleaner.strategy = :transaction

Trackstamps::Reborn.enable_test_interface

RSpec.configure do |config|
  config.before :suite do
    ActiveRecord::Base.establish_connection :adapter => 'sqlite3', database: ':memory:'
  end

  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end

  config.extend WithModel

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.order = :random

  Kernel.srand config.seed
end