# frozen_string_literal: true

module Shadcn
  # Base class for all shadcn ViewComponents
  # Provides common functionality like class merging and data attribute handling
  class BaseComponent < ViewComponent::Base
    # Include class name helper for cn() method
    include Shadcn::Rails::Helpers::ClassNameHelper

    # Common attributes shared by all components
    attr_reader :class_name, :data, :html_options

    # @param class_name [String, nil] Additional CSS classes
    # @param data [Hash] Data attributes (will be prefixed with data-)
    # @param html_options [Hash] Additional HTML attributes
    def initialize(class_name: nil, data: {}, **html_options, &block)
      @class_name = class_name
      @data = data
      @html_options = html_options
      @constructor_block = block
    end

    # Override content to support blocks passed to new()
    # This allows both syntaxes:
    #   render Component.new { "text" }  # block to new()
    #   render Component.new do %>text<% end  # block to render()
    # Note: Only calls blocks with arity 0 (no arguments).
    # Blocks expecting arguments (like slot blocks) are handled by ViewComponent.
    def content
      return super if super.present?
      return @constructor_block.call if @constructor_block && @constructor_block.arity == 0

      nil
    end

    private

    # Merge default classes with user-provided classes
    # @param default_classes [String] Default component classes
    # @return [String] Merged class string
    def merge_classes(default_classes)
      cn(default_classes, class_name)
    end

    # Build data attributes hash
    # Converts Ruby-style keys to HTML data attributes
    # @param additional_data [Hash] Additional data attributes to merge
    # @return [Hash] Merged data attributes
    def build_data(additional_data = {})
      merged = data.merge(additional_data)
      merged.transform_keys { |key| "data-#{key.to_s.dasherize}" }
    end

    # Build the complete HTML attributes hash
    # @param default_classes [String] Default component classes
    # @param additional_data [Hash] Additional data attributes
    # @return [Hash] Complete HTML attributes
    def build_html_attributes(default_classes, additional_data = {})
      attrs = html_options.dup
      attrs[:class] = merge_classes(default_classes)
      attrs.merge!(build_data(additional_data))
      attrs
    end

    # Helper to build Stimulus controller data attributes
    # @param controller [String] Stimulus controller name
    # @param values [Hash] Controller values
    # @param actions [Hash] Controller actions
    # @return [Hash] Stimulus data attributes
    def stimulus_data(controller:, values: {}, actions: {}, targets: {})
      data = { controller: controller }

      values.each do |key, value|
        data[:"#{controller}-#{key}-value"] = value
      end

      actions.each do |event, action|
        data[:action] = [data[:action], "#{event}->#{controller}##{action}"].compact.join(" ")
      end

      targets.each do |name, _|
        data[:"#{controller}-target"] = name
      end

      data
    end

    # Access configuration
    def config
      Shadcn::Rails.configuration
    end

    # Add prefix to Tailwind classes if configured
    def prefix_classes(classes)
      return classes if config.tailwind_prefix.blank?

      classes.split.map { |c| "#{config.tailwind_prefix}#{c}" }.join(" ")
    end

    # Build HTML attributes string for use in templates
    # Combines html_options and data attributes
    # @return [String] HTML-safe attribute string
    def tag_attributes
      attrs = html_options.merge(build_data)
      attrs.map { |k, v| "#{k}=\"#{ERB::Util.html_escape(v)}\"" if v }.compact.join(" ").html_safe
    end
  end
end
