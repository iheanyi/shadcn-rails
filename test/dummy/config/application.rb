# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

# Require shadcn-rails
require "shadcn/rails"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # Configuration for the application, engines, and railties
    config.eager_load = false
  end
end
