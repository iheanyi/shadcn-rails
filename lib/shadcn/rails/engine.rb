# frozen_string_literal: true

module Shadcn
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Shadcn::Rails


      # Configure autoloading for components
      initializer "shadcn-rails.autoloading", before: :set_autoload_paths do |app|
        components_path = root.join("app/components")
        app.config.autoload_paths << components_path

        # Enable reloading of engine components in development
        if ::Rails.env.development?
          app.reloaders << app.config.file_watcher.new([], { components_path.to_s => ["rb"] }) do
            # Trigger reload when component files change
          end
        end
      end

      initializer "shadcn-rails.view_component" do
        ActiveSupport.on_load(:view_component) do
          # ViewComponent is loaded
        end
      end

      initializer "shadcn-rails.helpers" do
        ActiveSupport.on_load(:action_view) do
          include Shadcn::Rails::Helpers::ClassNameHelper
          include Shadcn::Rails::Helpers::ComponentHelper
          include Shadcn::Rails::Helpers::PaginationHelper
        end
      end

      initializer "shadcn-rails.assets" do |app|
        if app.config.respond_to?(:assets) && app.config.assets.respond_to?(:paths)
          app.config.assets.paths << root.join("app/assets/stylesheets")
          app.config.assets.paths << root.join("app/assets/javascripts")
        end
      end

      initializer "shadcn-rails.importmap", before: "importmap" do |app|
        if defined?(Importmap)
          app.config.importmap.paths << root.join("config/importmap.rb")
          app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
        end
      end

      # Configure view component preview paths after initialization
      initializer "shadcn-rails.preview_paths", after: :load_config_initializers do |app|
        if defined?(ViewComponent::Base) && app.config.respond_to?(:view_component)
          app.config.view_component.preview_paths ||= []
          app.config.view_component.preview_paths << root.join("test/components/previews")
        end
      end
    end
  end
end
