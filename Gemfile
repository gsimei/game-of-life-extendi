source "https://rubygems.org"

ruby "3.3.6"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
#  Use Rack Cors for Cross-Origin Resource Sharing []
gem "rack-cors"
# Use Devise JWT for authentication []
gem "devise-jwt"
# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Devise authentication [https://github.com/heartcombo/devise]
gem "devise"
# Use Thruster for deploying Rails applications [https://github.com/basecamp/thruster]
gem "thruster"

gem "dotenv-rails", groups: [ :development, :test ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Use RSpec for unit and integration tests [https://rspec.info/]
  gem "rspec-rails"

  # Use FactoryBot for test data [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails"

  # Use Faker for generating fake data [https://github.com/faker-ruby/faker]
  gem "faker"

  gem "yard"
end
