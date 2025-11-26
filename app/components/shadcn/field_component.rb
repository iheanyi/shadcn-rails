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
    BASE_CLASSES = "space-y-2"

    # Label slot
    renders_one :label, lambda { |required: false, **options, &block|
      options[:for] ||= @input_id
      options[:required] = required
      Shadcn::LabelComponent.new(**options, &block)
    }

    # Input slot - renders an Input component
    renders_one :input, lambda { |**options|
      options[:id] ||= @input_id
      options[:name] ||= @name
      if @has_error
        options[:class_name] = cn("border-destructive focus-visible:ring-destructive", options[:class_name])
      end
      Shadcn::InputComponent.new(**options)
    }

    # Control slot - for custom controls (textarea, select, etc.)
    renders_one :control

    # Description slot
    renders_one :description, "DescriptionComponent"

    # Error slot
    renders_one :error, "ErrorComponent"

    # @param name [String, nil] Input name attribute
    # @param id [String, nil] Input ID (auto-generated if not provided)
    def initialize(name: nil, id: nil, **options)
      super(**options)
      @name = name
      @input_id = id || generate_id
      @has_error = false
    end

    def before_render
      # Track if error is present for styling
      @has_error = error.present?
    end

    def call
      tag.div(class: merge_classes(BASE_CLASSES), **html_options.merge(build_data)) do
        safe_join([
          label,
          control || input,
          description,
          error
        ].compact)
      end
    end

    private

    def generate_id
      "field-#{SecureRandom.hex(4)}"
    end

    # Description subcomponent
    class DescriptionComponent < BaseComponent
      BASE_CLASSES = "text-[0.8rem] text-muted-foreground"

      def call
        tag.p(content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
      end
    end

    # Error subcomponent
    class ErrorComponent < BaseComponent
      BASE_CLASSES = "text-[0.8rem] font-medium text-destructive"

      def call
        tag.p(content, class: merge_classes(BASE_CLASSES), role: "alert", **html_options.merge(build_data))
      end
    end
  end
end
