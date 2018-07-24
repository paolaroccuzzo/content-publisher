require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContentPublisher
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # The "Slimmer" gem is loaded by the publishing components and will automatically
    # attempt to intercept requests and provide a layout. We don't use that
    # functionality here, so we have to tell slimmer to not do it.
    config.middleware.delete Slimmer::App

    # The "acceptance environment" we're in - not the same as Rails env.
    # Can be production, staging, integration, or development. On AWS it's
    # called `foo-aws-blue`, so we have to jump through some hoops here.
    original_environment_name = ENV.fetch("ERRBIT_ENVIRONMENT_NAME", "development")
    environment_name = original_environment_name.split("-").first
    raise unless environment_name.in?(%w[test development integration staging production])
    config.govuk_environment = environment_name
  end
end
