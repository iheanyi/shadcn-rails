# frozen_string_literal: true

module Shadcn
  # Input OTP component for one-time password entry
  # Matches shadcn/ui Input OTP component
  #
  # @example Basic 6-digit OTP
  #   <%= render Shadcn::InputOtpComponent.new(length: 6, name: "otp") %>
  #
  # @example With groups (3 + 3)
  #   <%= render Shadcn::InputOtpComponent.new(length: 6, name: "otp") do |otp| %>
  #     <% otp.with_group(slots: 3) %>
  #     <% otp.with_separator %>
  #     <% otp.with_group(slots: 3) %>
  #   <% end %>
  #
  # @example 4-digit PIN
  #   <%= render Shadcn::InputOtpComponent.new(length: 4, name: "pin", pattern: "^[0-9]*$") %>
  #
  # @example Disabled
  #   <%= render Shadcn::InputOtpComponent.new(length: 6, name: "otp", disabled: true) %>
  #
  class InputOtpComponent < BaseComponent
    BASE_CLASSES = "flex items-center gap-2 has-disabled:opacity-50"
    SLOT_CLASSES = "relative flex h-9 w-9 items-center justify-center border-y border-r border-input text-sm shadow-xs transition-all outline-none first:rounded-l-md first:border-l last:rounded-r-md aria-invalid:border-destructive data-[active=true]:z-10 data-[active=true]:border-ring data-[active=true]:ring-[3px] data-[active=true]:ring-ring/50 data-[active=true]:aria-invalid:border-destructive data-[active=true]:aria-invalid:ring-destructive/20 dark:bg-input/30 dark:data-[active=true]:aria-invalid:ring-destructive/40"
    CARET_CLASSES = "pointer-events-none absolute inset-0 flex items-center justify-center"
    CARET_BLINK_CLASSES = "h-4 w-px animate-caret-blink bg-foreground duration-1000"

    # Groups for visual grouping of slots
    renders_many :groups, "GroupComponent"

    # Separators between groups
    renders_many :separators, "OtpSeparatorComponent"

    # @param length [Integer] Number of OTP digits
    # @param name [String] Input name for form submission
    # @param pattern [String] Regex pattern for validation (defaults to alphanumeric)
    # @param disabled [Boolean] Whether the input is disabled
    # @param required [Boolean] Whether the input is required
    # @param autocomplete [String] Autocomplete attribute (defaults to "one-time-code")
    def initialize(length: 6, name: nil, pattern: nil, disabled: false, required: false, autocomplete: "one-time-code", **options)
      super(**options)
      @length = length
      @name = name
      @pattern = pattern
      @disabled = disabled
      @required = required
      @autocomplete = autocomplete
    end

    def call
      tag.div(**container_attributes) do
        safe_join([
          hidden_input,
          groups.any? ? render_with_groups : render_default_slots
        ])
      end
    end

    private

    def container_attributes
      merge_html_attributes(
        {
          class: merge_classes(BASE_CLASSES),
          "data-slot": "input-otp"
        },
        {
          controller: "shadcn--input-otp",
          "shadcn--input-otp-length-value": @length,
          "shadcn--input-otp-pattern-value": @pattern,
          "shadcn--input-otp-disabled-value": @disabled
        }
      )
    end

    def hidden_input
      tag.input(
        type: "hidden",
        name: @name,
        data: { "shadcn--input-otp-target": "hiddenInput" }
      )
    end

    def render_with_groups
      parts = []
      slot_index = 0

      groups.each_with_index do |group, group_index|
        # Render the group with its slots
        group_slots = group.slots.times.map do |_|
          slot = render_slot(slot_index)
          slot_index += 1
          slot
        end

        parts << tag.div("data-slot": "input-otp-group", class: "flex items-center") { safe_join(group_slots) }

        # Add separator after group if there's another group
        if group_index < groups.size - 1
          separator = separators[group_index]
          parts << (separator || default_separator)
        end
      end

      safe_join(parts)
    end

    def default_separator
      tag.div("data-slot": "input-otp-separator", class: "flex items-center justify-center px-2", role: "separator") do
        tag.span(class: "text-muted-foreground") { "-" }
      end
    end

    def render_default_slots
      # Render all slots in one group
      slots = @length.times.map do |index|
        render_slot(index)
      end

      tag.div("data-slot": "input-otp-group", class: "flex items-center") { safe_join(slots) }
    end

    def render_slot(index)
      tag.div(
        class: SLOT_CLASSES,
        data: {
          "shadcn--input-otp-target": "slot",
          slot: "input-otp-slot",
          active: false,
          index: index,
          action: "click->shadcn--input-otp#focusSlot"
        }
      ) do
        safe_join([
          tag.input(
            type: "text",
            maxlength: 1,
            inputmode: "numeric",
            autocomplete: index == 0 ? @autocomplete : "off",
            disabled: @disabled || nil,
            required: @required && index == 0 || nil,
            class: "absolute inset-0 w-full h-full text-center bg-transparent outline-none border-0 focus:ring-0",
            data: {
              "shadcn--input-otp-target": "input",
              index: index,
              action: "input->shadcn--input-otp#handleInput keydown->shadcn--input-otp#handleKeydown focus->shadcn--input-otp#handleFocus blur->shadcn--input-otp#handleBlur paste->shadcn--input-otp#handlePaste"
            }
          ),
          tag.div(class: CARET_CLASSES, data: { "shadcn--input-otp-target": "caret" }) do
            tag.div(class: CARET_BLINK_CLASSES)
          end
        ])
      end
    end

    # Group subcomponent
    class GroupComponent < BaseComponent
      BASE_CLASSES = "flex items-center"

      # @param slots [Integer] Number of slots in this group
      def initialize(slots: 3, **options)
        super(**options)
        @slots = slots
      end

      attr_reader :slots

      def call
        tag.div(class: merge_classes(BASE_CLASSES), **html_options.merge(build_data(slot: "input-otp-group"))) do
          content
        end
      end
    end

    # Separator subcomponent (named OtpSeparatorComponent to avoid conflict with standalone SeparatorComponent)
    class OtpSeparatorComponent < BaseComponent
      BASE_CLASSES = "flex items-center justify-center px-2"

      def call
        tag.div(class: merge_classes(BASE_CLASSES), role: "separator", **html_options.merge(build_data(slot: "input-otp-separator"))) do
          content.presence || tag.span(class: "text-muted-foreground") { "-" }
        end
      end
    end
  end
end
