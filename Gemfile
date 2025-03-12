source "https://rubygems.org"
gemspec

rails_version = ENV["RAILS_VERSION"] || "~> 8.0"
gem "activerecord", rails_version
gem "activesupport", rails_version

gem "database_cleaner", "~> 2.0"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.13"
gem "rubocop", "1.66.0"
gem "rubocop-packaging", "0.5.2"
gem "rubocop-performance", "1.21.1"
gem "rubocop-rake", "0.6.0"
gem "rubocop-rspec"
gem "sqlite3", "~> 1.7.3"
if rails_version == "~> 5.2.0"
  gem "with_model", "~> 2.0"
else
  gem "with_model", "~> 2.1.7"
end
