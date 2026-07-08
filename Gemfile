source "https://rubygems.org"

# Assets & front end
gem "rails", github: "rails/rails", branch: "main"
gem "propshaft"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "importmap-rails"
gem "lexxy", "~> 0.9.12.beta"

# Deployment and drivers
gem "puma", ">= 5.0"
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "pg"
gem "roo"
gem "mission_control-jobs"
gem "image_processing", "~> 1.2"

# Features
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "postmark-rails"

group :development do
  gem "ruby-lsp", "~> 0.26.9"
  gem "rbs", "~> 3.10"
  gem "pp"
  gem "letter_opener"
  gem "web-console"
  gem "rack-mini-profiler"
  gem "memory_profiler"
  gem "stackprof"
  gem "seed_dump"
end

group :test do
  gem "sqlite3", ">= 2.1"
  gem "capybara"                                                      # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "selenium-webdriver"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude" # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "brakeman", require: false                                      # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "rubocop-rails-omakase", require: false                         # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
end