# frozen_string_literal: true

module Shadcn
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Shadcn::Rails

      config.generators do |g|
        g.test_framework :rspec
      end

      initializer "shadcn-rails.view_helpers" do
        ActiveSupport.on_load(:action_view) do
          include Shadcn::Rails::ViewHelpers
          include Shadcn::Rails::TagHelper
        end
      end

      initializer "shadcn-rails.form_builder" do
        ActiveSupport.on_load(:action_view) do
          # Make the form builder available as a default option
          # Usage: form_with model: @user, builder: Shadcn::Rails::FormBuilder
        end
      end

      initializer "shadcn-rails.assets" do |app|
        # Add asset paths if needed
        if app.config.respond_to?(:assets)
          app.config.assets.paths << root.join("app", "assets", "stylesheets")
        end
      end

      # Autoload component paths
      # We add the parent of components_path (e.g., app/components) so that
      # the ui folder creates the Ui:: namespace properly
      initializer "shadcn-rails.autoload", before: :set_autoload_paths do |app|
        components_path = ::Rails.root.join(Shadcn::Rails.configuration.components_path)
        parent_path = components_path.parent
        if parent_path.exist?
          app.config.autoload_paths << parent_path.to_s
        end
      end

      # Eager load components in production
      initializer "shadcn-rails.eager_load", before: :set_autoload_paths do |app|
        components_path = ::Rails.root.join(Shadcn::Rails.configuration.components_path)
        parent_path = components_path.parent
        if parent_path.exist?
          app.config.eager_load_paths << parent_path.to_s
        end
      end
    end
  end
end
