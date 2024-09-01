$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "trackstamps/reborn"

require "database_cleaner"
require "with_model"

require "dry/configurable/test_interface"

DatabaseCleaner.strategy = :transaction

Trackstamps::Reborn.enable_test_interface
Trackstamps::Reborn[:alternative].enable_test_interface

RSpec.configure do |config|
  config.before :suite do
    ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
  end

  config.before do
    Trackstamps::Reborn.reset_config
    Trackstamps::Reborn[:alternative].reset_config
  end

  config.before do
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end

  config.extend WithModel

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed
end
