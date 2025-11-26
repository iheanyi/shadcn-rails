# frozen_string_literal: true

module Shadcn
  # Label component for form fields
  # Matches shadcn/ui Label component
  #
  # @example Basic label
  #   <%= render Shadcn::LabelComponent.new(for: "email") { "Email Address" } %>
  #
  # @example Required field label
  #   <%= render Shadcn::LabelComponent.new(for: "name", required: true) { "Name" } %>
  #
  # @example With custom styling
  #   <%= render Shadcn::LabelComponent.new(for: "bio", class_name: "text-lg") { "Biography" } %>
  #
  class LabelComponent < BaseComponent
    BASE_CLASSES = "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"

    # @param for [String, nil] The ID of the input this label is for
    # @param required [Boolean] Whether to show a required indicator
    def initialize(for: nil, required: false, **options)
      super(**options)
      @for = binding.local_variable_get(:for)
      @required = required
    end

    def call
      label_text = content
      label_text = safe_join([label_text, required_indicator]) if @required
      tag.label(label_text, **label_attributes)
    end

    private

    def required_indicator
      content_tag(:span, " *", class: "text-destructive", "aria-hidden": "true")
    end

    def label_attributes
      attrs = {
        for: @for,
        class: merge_classes(BASE_CLASSES)
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
