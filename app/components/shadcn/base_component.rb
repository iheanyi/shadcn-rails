# frozen_string_literal: true

module Shadcn
  # Base class for all shadcn ViewComponents
  # Provides common functionality like class merging and data attribute handling
  class BaseComponent < ViewComponent::Base
    # Include class name helper for cn() method
    include Shadcn::Rails::Helpers::ClassNameHelper

    # Common attributes shared by all components
    attr_reader :class_name, :data, :html_options

    # @param class_name [String, nil] Additional CSS classes (preferred)
    # @param class [String, nil] Alias for class_name (for Rails-like API)
    # @param data [Hash] Data attributes (will be prefixed with data-)
    # @param html_options [Hash] Additional HTML attributes
    def initialize(class_name: nil, data: {}, **html_options, &block)
      # Support both class: and class_name: for better Rails compatibility
      # class_name takes precedence if both are provided
      html_class = html_options.delete(:class)
      @class_name = class_name || html_class
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
      prefix_classes(cn(default_classes, class_name))
    end

    # Build data attributes hash.
    # Converts Ruby-style keys to HTML data attributes and appends Stimulus
    # controller/action hooks instead of clobbering either side.
    # @param default_data [Hash] Component-owned data attributes
    # @return [Hash] Merged data attributes
    def build_data(default_data = {})
      merge_data_attributes(default_data, data)
    end

    # Build the complete HTML attributes hash
    # @param default_classes [String] Default component classes
    # @param additional_data [Hash] Additional data attributes
    # @return [Hash] Complete HTML attributes
    def build_html_attributes(default_classes, additional_data = {})
      attrs = merge_html_attributes({}, additional_data)
      attrs[:class] = merge_classes(default_classes)
      attrs
    end

    def merge_html_attributes(default_attrs = {}, default_data = {})
      attrs = default_attrs.dup
      component_data = extract_data_attributes!(attrs).merge(default_data)
      host_attrs = html_options.dup
      host_data = data.merge(extract_data_attributes!(host_attrs))

      attrs.merge!(host_attrs)
      attrs.merge!(merge_data_attributes(component_data, host_data))
      attrs.compact
    end

    def merge_data_attributes(default_data = {}, host_data = {})
      normalized_defaults = normalize_data_hash(default_data)
      normalized_host = normalize_data_hash(host_data)

      normalized_host.each do |key, value|
        if %w[action controller].include?(key) && normalized_defaults[key].present? && value.present?
          normalized_defaults[key] = [normalized_defaults[key], value].join(" ")
        else
          normalized_defaults[key] = value
        end
      end

      normalized_defaults
        .compact
        .transform_keys { |key| "data-#{key.to_s.dasherize}" }
    end

    def extract_data_attributes!(attrs)
      extracted = {}

      attrs.keys.each do |key|
        key_string = key.to_s

        if key_string == "data"
          extracted.merge!(attrs.delete(key) || {})
        elsif key_string.start_with?("data-")
          extracted[key_string.delete_prefix("data-")] = attrs.delete(key)
        end
      end

      extracted
    end

    def normalize_data_hash(attributes)
      attributes.each_with_object({}) do |(key, value), normalized|
        normalized[key.to_s.delete_prefix("data-")] = value
      end
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
      return classes if classes.blank? || config.tailwind_prefix.blank?

      classes.split.map { |class_name| prefix_class_name(class_name) }.join(" ")
    end

    def prefix_class_name(class_name)
      return class_name if class_name.start_with?("shadcn-")

      variant_prefix, utility = split_variant_prefix(class_name)
      important = utility.delete_prefix!("!") ? "!" : ""
      negative = utility.delete_prefix!("-") ? "-" : ""
      return class_name if utility.start_with?(config.tailwind_prefix)

      "#{variant_prefix}#{important}#{negative}#{config.tailwind_prefix}#{utility}"
    end

    def split_variant_prefix(class_name)
      bracket_depth = 0
      split_at = nil

      class_name.each_char.with_index do |char, index|
        bracket_depth += 1 if char == "["
        bracket_depth -= 1 if char == "]"
        split_at = index if char == ":" && bracket_depth.zero?
      end

      return ["", class_name] unless split_at

      [class_name[0..split_at], class_name[(split_at + 1)..]]
    end

    # Build HTML attributes string for use in templates
    # Combines html_options and data attributes
    # Uses html_escape_once to avoid double-escaping already-escaped content
    # @return [String] HTML-safe attribute string
    def tag_attributes
      attrs = html_options.merge(build_data)
      attrs.map { |k, v| "#{k}=\"#{ERB::Util.html_escape_once(v)}\"" if v }.compact.join(" ").html_safe
    end
  end
end
