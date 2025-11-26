# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  module Generators
    # Generator for adding individual shadcn components
    # Usage: rails generate shadcn:component button card dialog
    class ComponentGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      argument :components, type: :array, default: [], banner: "component [component ...]"

      class_option :all, type: :boolean, default: false,
        desc: "Install all available components"
      class_option :list, type: :boolean, default: false,
        desc: "List all available components"

      desc "Adds shadcn-rails components to your application"

      # List of all available components
      AVAILABLE_COMPONENTS = %w[
        accordion
        alert
        avatar
        badge
        button
        card
        checkbox
        collapsible
        dialog
        dropdown_menu
        input
        label
        popover
        progress
        scroll_area
        select
        separator
        sheet
        skeleton
        switch
        table
        tabs
        textarea
        toast
        tooltip
      ].freeze

      def validate_components
        if options[:list]
          display_available_components
          exit 0
        end

        if options[:all]
          @components_to_install = AVAILABLE_COMPONENTS
        else
          validate_requested_components
          @components_to_install = components
        end
      end

      def display_installation_plan
        say ""
        say "Installing #{@components_to_install.length} component(s):", :green
        @components_to_install.each { |c| say "  - #{c}" }
        say ""
      end

      def install_components
        @components_to_install.each do |component|
          install_component(component)
        end
      end

      def display_usage_examples
        say ""
        say "=" * 60, :green
        say "  Components installed successfully!", :green
        say "=" * 60, :green
        say ""
        say "Example usage:", :yellow

        @components_to_install.first(3).each do |component|
          display_component_example(component)
        end

        say ""
      end

      private

      def display_available_components
        say ""
        say "Available shadcn-rails components:", :green
        say ""
        AVAILABLE_COMPONENTS.each { |c| say "  - #{c}" }
        say ""
        say "Usage: rails generate shadcn:component button card dialog"
        say "       rails generate shadcn:component --all"
        say ""
      end

      def validate_requested_components
        if components.empty?
          say "Error: Please specify at least one component or use --all", :red
          say ""
          display_available_components
          exit 1
        end

        invalid = components - AVAILABLE_COMPONENTS
        if invalid.any?
          say "Error: Unknown component(s): #{invalid.join(', ')}", :red
          say ""
          display_available_components
          exit 1
        end
      end

      def install_component(name)
        # Components are already available from the gem
        # This generator just confirms installation and provides usage info
        say "  ✓ #{name.titleize}Component is available", :green
      end

      def display_component_example(component)
        case component
        when "button"
          say <<~EXAMPLE

            Button:
              <%= render Shadcn::ButtonComponent.new(variant: :primary) do %>
                Click me
              <% end %>
          EXAMPLE
        when "card"
          say <<~EXAMPLE

            Card:
              <%= render Shadcn::CardComponent.new do |card| %>
                <% card.with_header do %>
                  <% card.with_title { "Card Title" } %>
                <% end %>
                <% card.with_content { "Card content" } %>
              <% end %>
          EXAMPLE
        when "dialog"
          say <<~EXAMPLE

            Dialog:
              <%= render Shadcn::DialogComponent.new do |dialog| %>
                <% dialog.with_trigger do %>
                  <%= render Shadcn::ButtonComponent.new { "Open" } %>
                <% end %>
                <% dialog.with_content do |content| %>
                  <% content.with_title { "Dialog Title" } %>
                  Dialog content here
                <% end %>
              <% end %>
          EXAMPLE
        when "input"
          say <<~EXAMPLE

            Input:
              <%= render Shadcn::LabelComponent.new(for: "email") { "Email" } %>
              <%= render Shadcn::InputComponent.new(
                type: "email",
                id: "email",
                name: "email",
                placeholder: "Enter your email"
              ) %>
          EXAMPLE
        else
          say <<~EXAMPLE

            #{component.titleize}:
              <%= render Shadcn::#{component.camelize}Component.new do %>
                Content here
              <% end %>
          EXAMPLE
        end
      end
    end
  end
end
