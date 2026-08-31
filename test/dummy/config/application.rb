# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "kaminari"
require "pagy"
require "will_paginate"
require "will_paginate/collection"

# Load shadcn-rails from parent directory
require "shadcn/rails"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.active_support.deprecation = :stderr

    # ViewComponent configuration
    # In Docker, the gem is at /shadcn-rails, locally it's at ../..
    preview_path = if File.exist?("/shadcn-rails/test/components/previews")
      "/shadcn-rails/test/components/previews"
    else
      Rails.root.join("../../test/components/previews")
    end
    
    config.view_component.preview_paths = [preview_path]
    config.view_component.default_preview_layout = "component_preview"

    # Lookbook configuration
    config.lookbook.preview_paths = [preview_path]
  end
end
