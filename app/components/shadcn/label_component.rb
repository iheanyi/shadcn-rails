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
    BASE_CLASSES = "flex items-center gap-2 text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50"

    # @param for [String, nil] The ID of the input this label is for
    # @param required [Boolean] Whether to show a required indicator
    def initialize(for: nil, required: false, **options)
      super(**options)
      @for = binding.local_variable_get(:for)
      @required = required
    end

    private

    def label_classes
      cn(BASE_CLASSES, class_name)
    end
  end
end
