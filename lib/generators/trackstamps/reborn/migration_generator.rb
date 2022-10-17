require 'rails/generators/active_record'

class Trackstamps::Reborn::MigrationGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)
  argument :table, :type => :string, :default => "application"
  desc 'Generate migration file required for trackstamps'

  def install
    migration_template 'migration.rb', "db/migrate/add_trackstamps_to_#{table}.rb"
  end

  def migration_data
    <<-RUBY
    add_column :#{table}, :created_by_id, :integer
    add_column :#{table}, :updated_by_id, :integer
    RUBY
  end

  def table_name
    table
  end

  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end
end
