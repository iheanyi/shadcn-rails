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
require "view_component"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    # Configuration for the application, engines, and railties
    config.eager_load = false

    # ViewComponent configuration
    config.view_component.preview_paths << Rails.root.join("test/components/previews")
    config.view_component.show_previews = true
  end
end
