# frozen_string_literal: true

module Shadcn
  module Rails
    # Registry for tracking installed components
    class ComponentRegistry
      class << self
        def installed_components
          @installed_components ||= discover_installed_components
        end

        def installed?(component_name)
          installed_components.include?(component_name.to_s.underscore)
        end

        def refresh!
          @installed_components = discover_installed_components
        end

        private

        def discover_installed_components
          components_path = ::Rails.root.join(Shadcn::Rails.configuration.components_path)
          return [] unless components_path.exist?

          Dir.glob(components_path.join("*_component.rb")).map do |file|
            File.basename(file, "_component.rb")
          end
        rescue StandardError
          []
        end
      end
    end
  end
end
