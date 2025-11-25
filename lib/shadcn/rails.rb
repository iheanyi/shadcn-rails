# frozen_string_literal: true

require_relative "rails/version"
require_relative "rails/configuration"
require_relative "rails/view_helpers"
require_relative "rails/tag_helper"
require_relative "rails/form_builder"
require_relative "rails/component_registry"
require_relative "rails/engine"

module Shadcn
  module Rails
    class Error < StandardError; end

    AVAILABLE_COMPONENTS = %w[
      button
      card
      input
      badge
      alert
      dialog
      dropdown_menu
      avatar
      checkbox
      label
      textarea
      select
      switch
      tabs
      tooltip
      separator
      skeleton
      spinner
      progress
    ].freeze

    class << self
      def root
        Pathname.new(File.expand_path("../..", __dir__))
      end

      def components_path
        root.join("lib", "generators", "shadcn", "templates", "components")
      end

      def available_components
        AVAILABLE_COMPONENTS
      end

      def component_exists?(name)
        AVAILABLE_COMPONENTS.include?(name.to_s.underscore)
      end
    end
  end
end
