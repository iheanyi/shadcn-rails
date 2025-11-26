# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

# Load shadcn-rails from parent directory
require "shadcn/rails"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.active_support.deprecation = :stderr

    # ViewComponent configuration
    config.view_component.previews.paths = [Rails.root.join("../../test/components/previews")]
    config.view_component.previews.default_layout = "component_preview"

    # Lookbook configuration
    config.lookbook.preview_paths = [Rails.root.join("../../test/components/previews")]
  end
end
