source "https://rubygems.org"

ruby "3.3.11"

# Rails core
gem "rails", "~> 7.1.0"
gem "sqlite3", ">= 1.4"
gem "pg", "~> 1.5"
gem "puma", "~> 6.4"

# Asset Pipeline
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# Tailwind CSS
gem "tailwindcss-rails"

# Authentication
gem "devise"

# JSON
gem "jbuilder"

# Redis for Turbo Streams broadcasting (optional)
gem "redis", ">= 4.0.1"

# Windows timezone data
gem "tzinfo-data", platforms: %i[windows jruby]

# Performance
gem "bootsnap", require: false

group :development, :test do
  gem "faker"
  gem "rails-i18n"
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :development do
  gem "letter_opener"
end
