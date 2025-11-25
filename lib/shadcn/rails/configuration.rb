# frozen_string_literal: true

module Shadcn
  module Rails
    class Configuration
      attr_accessor :components_path, :tailwind_config_path, :default_styles

      def initialize
        @components_path = "app/components/ui"
        @tailwind_config_path = "config/tailwind.config.js"
        @default_styles = {
          rounded: "rounded-md",
          shadow: "shadow-sm",
          transition: "transition-colors"
        }
      end
    end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      def reset_configuration!
        @configuration = Configuration.new
      end
    end
  end
end
