source "https://rubygems.org"

ruby "3.3.4"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"

gem 'bcrypt'
gem 'jwt'
gem 'rswag'
gem 'rubocop'
gem 'csv'

gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'pry'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'rspec-rails'
  gem 'faker'
end
