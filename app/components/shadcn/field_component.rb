# frozen_string_literal: true

module Shadcn
  # Field component for form field wrapper with label, input, description, and error
  # Provides a consistent pattern for form fields
  #
  # @example Basic field
  #   <%= render Shadcn::FieldComponent.new do |field| %>
  #     <% field.with_label { "Email" } %>
  #     <% field.with_input(type: :email, placeholder: "you@example.com") %>
  #   <% end %>
  #
  # @example With description
  #   <%= render Shadcn::FieldComponent.new do |field| %>
  #     <% field.with_label { "Username" } %>
  #     <% field.with_input %>
  #     <% field.with_description { "This is your public display name." } %>
  #   <% end %>
  #
  # @example With error
  #   <%= render Shadcn::FieldComponent.new do |field| %>
  #     <% field.with_label { "Password" } %>
  #     <% field.with_input(type: :password) %>
  #     <% field.with_error { "Password is required." } %>
  #   <% end %>
  #
  # @example With custom content
  #   <%= render Shadcn::FieldComponent.new do |field| %>
  #     <% field.with_label { "Bio" } %>
  #     <% field.with_control do %>
  #       <%= render Shadcn::TextareaComponent.new(placeholder: "Tell us about yourself") %>
  #     <% end %>
  #   <% end %>
  #
  class FieldComponent < BaseComponent
    BASE_CLASSES = "group/field flex w-full gap-3 data-[invalid=true]:text-destructive"
    ORIENTATION_CLASSES = {
      vertical: "flex-col [&>*]:w-full [&>.sr-only]:w-auto",
      horizontal: "flex-row items-center [&>[data-slot=field-label]]:flex-auto has-[>[data-slot=field-content]]:items-start has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px",
      responsive: "flex-col @md/field-group:flex-row @md/field-group:items-center [&>*]:w-full @md/field-group:[&>*]:w-auto [&>.sr-only]:w-auto @md/field-group:[&>[data-slot=field-label]]:flex-auto @md/field-group:has-[>[data-slot=field-content]]:items-start @md/field-group:has-[>[data-slot=field-content]]:[&>[role=checkbox],[role=radio]]:mt-px"
    }.freeze

    # Label slot
    renders_one :label, lambda { |required: false, **options, &block|
      options[:for] ||= @input_id
      options[:required] = required
      FieldLabelComponent.new(**options, &block)
    }

    # Input slot - renders an Input component
    # @param error [Boolean] Whether to show error styles on the input
    # Note: If using with_error slot, call it BEFORE with_input for automatic error detection,
    # or pass error: true explicitly
    renders_one :input, lambda { |error: nil, **options|
      options[:id] ||= @input_id
      options[:name] ||= @name
      # Use explicit error param if provided, otherwise check error slot
      has_error = error.nil? ? error? : error
      if has_error
        options[:class_name] = cn("border-destructive focus-visible:ring-destructive", options[:class_name])
      end
      Shadcn::InputComponent.new(**options)
    }

    # Control slot - for custom controls (textarea, select, etc.)
    renders_one :control
    renders_one :field_content, "FieldContentComponent"
    renders_one :title, "FieldTitleComponent"
    renders_one :separator, "FieldSeparatorComponent"

    # Description slot
    renders_one :description, "FieldDescriptionComponent"

    # Error slot
    renders_one :error, "FieldErrorComponent"

    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input ID (auto-generated if not provided)
    # @param orientation [Symbol] Field layout (:vertical, :horizontal, :responsive)
    # @param invalid [Boolean, nil] Whether to mark the field invalid
    # @param disabled [Boolean, nil] Whether to expose disabled state to child classes
    def initialize(name: nil, id: nil, orientation: :vertical, invalid: nil, disabled: nil, **options)
      super(**options)
      @name = name
      @input_id = id || generate_id
      @orientation = orientation.to_sym
      @invalid = invalid
      @disabled = disabled
    end

    def call
      tag.div(**field_attributes) do
        safe_join([
          label,
          control || input,
          field_content,
          description,
          separator,
          error
        ].compact)
      end
    end

    private

    def generate_id
      "field-#{SecureRandom.hex(4)}"
    end

    def field_classes
      cn(BASE_CLASSES, ORIENTATION_CLASSES.fetch(@orientation, ORIENTATION_CLASSES[:vertical]))
    end

    def field_attributes
      merge_html_attributes(
        {
          role: "group",
          class: merge_classes(field_classes),
          "data-slot": "field",
          "data-orientation": @orientation,
          "data-invalid": invalid_value,
          "data-disabled": @disabled
        }
      )
    end

    def invalid_value
      return @invalid unless @invalid.nil?

      true if error?
    end

    class FieldSetComponent < BaseComponent
      BASE_CLASSES = "flex flex-col gap-6 has-[>[data-slot=checkbox-group]]:gap-3 has-[>[data-slot=radio-group]]:gap-3"

      def call
        tag.fieldset(content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-set" }))
      end
    end

    class FieldLegendComponent < BaseComponent
      BASE_CLASSES = "mb-3 font-medium data-[variant=legend]:text-base data-[variant=label]:text-sm"

      def initialize(variant: :legend, **options)
        super(**options)
        @variant = variant.to_sym
      end

      def call
        tag.legend(content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-legend", "data-variant": @variant }))
      end
    end

    class FieldGroupComponent < BaseComponent
      BASE_CLASSES = "group/field-group @container/field-group flex w-full flex-col gap-7 data-[slot=checkbox-group]:gap-3 [&>[data-slot=field-group]]:gap-4"

      def call
        tag.div(content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-group" }))
      end
    end

    class FieldContentComponent < BaseComponent
      BASE_CLASSES = "group/field-content flex flex-1 flex-col gap-1.5 leading-snug"

      def call
        tag.div(content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-content" }))
      end
    end

    class FieldLabelComponent < BaseComponent
      BASE_CLASSES = "group/field-label peer/field-label flex w-fit gap-2 leading-snug group-data-[disabled=true]/field:opacity-50 has-[>[data-slot=field]]:w-full has-[>[data-slot=field]]:flex-col has-[>[data-slot=field]]:rounded-md has-[>[data-slot=field]]:border [&>*]:data-[slot=field]:p-4 has-data-[state=checked]:border-primary has-data-[state=checked]:bg-primary/5 dark:has-data-[state=checked]:bg-primary/10"

      def initialize(for: nil, required: false, **options)
        super(**options)
        @for = binding.local_variable_get(:for)
        @required = required
      end

      def call
        tag.label(label_content, **merge_html_attributes({ for: @for, class: merge_classes(BASE_CLASSES), "data-slot": "field-label" }))
      end

      private

      def label_content
        return content unless @required

        safe_join([content, tag.span(" *", class: "text-destructive", "aria-hidden": true)])
      end
    end

    class FieldTitleComponent < BaseComponent
      BASE_CLASSES = "flex w-fit items-center gap-2 text-sm leading-snug font-medium group-data-[disabled=true]/field:opacity-50"

      def call
        tag.div(content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-label" }))
      end
    end

    # Description subcomponent
    class FieldDescriptionComponent < BaseComponent
      BASE_CLASSES = "text-sm leading-normal font-normal text-muted-foreground group-has-[[data-orientation=horizontal]]/field:text-balance last:mt-0 nth-last-2:-mt-1 [[data-variant=legend]+&]:-mt-1.5 [&>a]:underline [&>a]:underline-offset-4 [&>a:hover]:text-primary"

      def call
        tag.p(content, **merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-description" }))
      end
    end

    class FieldSeparatorComponent < BaseComponent
      BASE_CLASSES = "relative -my-2 h-5 text-sm group-data-[variant=outline]/field-group:-mb-2"
      CONTENT_CLASSES = "relative mx-auto block w-fit bg-background px-2 text-muted-foreground"

      def call
        tag.div(**merge_html_attributes({ class: merge_classes(BASE_CLASSES), "data-slot": "field-separator", "data-content": separator_content.present? })) do
          safe_join([separator, content_span].compact)
        end
      end

      private

      def separator_content
        content
      end

      def separator
        render Shadcn::SeparatorComponent.new(class_name: "absolute inset-0 top-1/2")
      end

      def content_span
        return unless separator_content.present?

        tag.span(separator_content, class: CONTENT_CLASSES, "data-slot": "field-separator-content")
      end
    end

    # Error subcomponent
    class FieldErrorComponent < BaseComponent
      BASE_CLASSES = "text-sm font-normal text-destructive"

      def call
        tag.div(content, **merge_html_attributes({ role: "alert", class: merge_classes(BASE_CLASSES), "data-slot": "field-error" }))
      end
    end

    SetComponent = FieldSetComponent
    LegendComponent = FieldLegendComponent
    GroupComponent = FieldGroupComponent
    ContentComponent = FieldContentComponent
    LabelComponent = FieldLabelComponent
    TitleComponent = FieldTitleComponent
    DescriptionComponent = FieldDescriptionComponent
    SeparatorComponent = FieldSeparatorComponent
    ErrorComponent = FieldErrorComponent
  end
end
