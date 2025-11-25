# frozen_string_literal: true

require "rails/generators"
require "rails/generators/base"

module Shadcn
  class ComponentGenerator < ::Rails::Generators::Base
    source_root File.expand_path("templates/components", __dir__)

    argument :components, type: :array, banner: "component [component ...]"

    class_option :path, type: :string, default: nil, desc: "Custom path to install components"
    class_option :force, type: :boolean, default: false, desc: "Overwrite existing components"
    class_option :list, type: :boolean, default: false, desc: "List all available components"

    desc "Install shadcn UI components into your Rails application"

    def handle_list_option
      return unless options[:list]

      list_available_components
      exit(0)
    end

    def validate_components
      return if options[:list]

      invalid = components - available_components
      return if invalid.empty?

      say_status :error, "Unknown component(s): #{invalid.join(', ')}", :red
      say ""
      say "Available components:", :cyan
      available_components.each_slice(5) do |group|
        say "  #{group.join(', ')}"
      end
      exit(1)
    end

    def install_base_component
      return if options[:list]
      return if File.exist?(File.join(components_path, "base_component.rb"))

      template "../base_component.rb.tt", File.join(components_path, "base_component.rb")
      say_status :create, "#{components_path}/base_component.rb", :green
    end

    def install_components
      return if options[:list]

      components.each do |component|
        install_single_component(component)
      end
    end

    def display_completion_message
      return if options[:list]

      say ""
      say "✅ Component(s) installed successfully!", :green
      say ""
      say "Usage example:", :cyan

      example_component = components.first
      case example_component
      when "button"
        say "  <%= render Ui::ButtonComponent.new(variant: :default) do %>"
        say "    Click me"
        say "  <% end %>"
      when "card"
        say "  <%= render Ui::CardComponent.new do |card| %>"
        say "    <% card.with_header do %>"
        say "      <% card.with_title { 'Card Title' } %>"
        say "    <% end %>"
        say "    <% card.with_content do %>"
        say "      Card content goes here"
        say "    <% end %>"
        say "  <% end %>"
      when "input"
        say "  <%= render Ui::InputComponent.new(name: 'email', type: 'email', placeholder: 'Enter email') %>"
      else
        say "  <%= render Ui::#{example_component.camelize}Component.new do %>"
        say "    Content"
        say "  <% end %>"
      end
      say ""
    end

    private

    def components_path
      @components_path ||= options[:path] || Shadcn::Rails.configuration.components_path
    end

    def available_components
      Shadcn::Rails::AVAILABLE_COMPONENTS
    end

    def install_single_component(component)
      component_name = component.underscore

      rb_source = "#{component_name}_component.rb.tt"
      erb_source = "#{component_name}_component.html.erb.tt"

      rb_dest = File.join(components_path, "#{component_name}_component.rb")
      erb_dest = File.join(components_path, "#{component_name}_component.html.erb")

      # Check for existing files
      if File.exist?(rb_dest) && !options[:force]
        say_status :skip, "#{rb_dest} already exists (use --force to overwrite)", :yellow
        return
      end

      # Copy the component files
      if File.exist?(File.join(self.class.source_root, rb_source))
        template rb_source, rb_dest
        say_status :create, rb_dest, :green
      else
        say_status :error, "Template not found: #{rb_source}", :red
        return
      end

      if File.exist?(File.join(self.class.source_root, erb_source))
        template erb_source, erb_dest
        say_status :create, erb_dest, :green
      end
    end

    def list_available_components
      say ""
      say "Available shadcn components:", :cyan
      say ""

      available_components.each do |component|
        description = component_description(component)
        say "  • #{component.ljust(20)} - #{description}"
      end

      say ""
      say "Install with: rails g shadcn:component <name> [<name> ...]", :yellow
      say "Example: rails g shadcn:component button card input", :yellow
      say ""
    end

    def component_description(component)
      descriptions = {
        "button" => "Clickable button with multiple variants and sizes",
        "card" => "Container with header, content, and footer slots",
        "input" => "Text input field with styling and states",
        "badge" => "Small status indicator with variants",
        "alert" => "Attention-grabbing message with icon support",
        "dialog" => "Modal dialog/popup window",
        "dropdown_menu" => "Dropdown menu with items and separators",
        "avatar" => "User avatar with image and fallback support",
        "checkbox" => "Checkbox input with custom styling",
        "label" => "Form label with required indicator",
        "textarea" => "Multi-line text input",
        "select" => "Dropdown select input",
        "switch" => "Toggle switch input",
        "tabs" => "Tabbed content navigation",
        "tooltip" => "Hover tooltip with positioning",
        "separator" => "Horizontal or vertical separator line",
        "skeleton" => "Loading placeholder animation",
        "spinner" => "Loading spinner indicator",
        "progress" => "Progress bar indicator"
      }
      descriptions[component] || "UI component"
    end
  end
end
