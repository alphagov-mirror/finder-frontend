source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "rails", "6.0.3.3"

gem "chronic"
gem "dalli"
gem "gds-api-adapters"
gem "google-api-client"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_document_types"
gem "govuk_publishing_components"
gem "jwt"
gem "slimmer"

gem "sass-rails"
gem "uglifier"
gem "whenever"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem "sdoc", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem "awesome_print"
  gem "dotenv-rails"
  gem "govuk_schemas"
  gem "jasmine"
  gem "jasmine_selenium_runner", require: false
  gem "listen"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "scss_lint-govuk"
end

group :test do
  gem "climate_control"
  gem "cucumber-rails", require: false
  gem "factory_bot"
  gem "govuk-content-schema-test-helpers"
  gem "govuk_test"
  gem "launchy"
  gem "rails-controller-testing"
  gem "simplecov"
  gem "timecop"
  gem "webdrivers"
  gem "webmock"
end
