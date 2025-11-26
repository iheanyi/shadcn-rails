# frozen_string_literal: true

module Shadcn
  # Textarea component for multi-line text input
  # Matches shadcn/ui Textarea component
  #
  # @example Basic textarea
  #   <%= render Shadcn::TextareaComponent.new(name: "bio", placeholder: "Tell us about yourself") %>
  #
  # @example With rows
  #   <%= render Shadcn::TextareaComponent.new(name: "message", rows: 6) %>
  #
  class TextareaComponent < BaseComponent
    BASE_CLASSES = "flex min-h-[60px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-base shadow-sm placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"

    # @param name [String, nil] Textarea name attribute
    # @param id [String, nil] Textarea id attribute
    # @param value [String, nil] Initial value
    # @param placeholder [String, nil] Placeholder text
    # @param rows [Integer] Number of visible rows
    # @param cols [Integer, nil] Number of visible columns
    # @param disabled [Boolean] Whether textarea is disabled
    # @param required [Boolean] Whether textarea is required
    # @param readonly [Boolean] Whether textarea is readonly
    # @param autofocus [Boolean] Whether to autofocus
    # @param minlength [Integer, nil] Minimum length
    # @param maxlength [Integer, nil] Maximum length
    def initialize(
      name: nil,
      id: nil,
      value: nil,
      placeholder: nil,
      rows: 3,
      cols: nil,
      disabled: false,
      required: false,
      readonly: false,
      autofocus: false,
      minlength: nil,
      maxlength: nil,
      **options
    )
      super(**options)
      @name = name
      @id = id
      @value = value
      @placeholder = placeholder
      @rows = rows
      @cols = cols
      @disabled = disabled
      @required = required
      @readonly = readonly
      @autofocus = autofocus
      @minlength = minlength
      @maxlength = maxlength
    end

    def call
      content_tag(:textarea, @value || content, textarea_attributes)
    end

    private

    def textarea_attributes
      attrs = {
        name: @name,
        id: @id,
        placeholder: @placeholder,
        rows: @rows,
        cols: @cols,
        disabled: @disabled || nil,
        required: @required || nil,
        readonly: @readonly || nil,
        autofocus: @autofocus || nil,
        minlength: @minlength,
        maxlength: @maxlength,
        class: merge_classes(BASE_CLASSES)
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end
end
