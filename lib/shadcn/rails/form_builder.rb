# frozen_string_literal: true

module Shadcn
  module Rails
    # Custom form builder with shadcn component integration
    class FormBuilder < ActionView::Helpers::FormBuilder
      # Render a shadcn text input
      def shadcn_text_field(method, options = {})
        render_shadcn_input(:text, method, options)
      end

      # Render a shadcn email input
      def shadcn_email_field(method, options = {})
        render_shadcn_input(:email, method, options)
      end

      # Render a shadcn password input
      def shadcn_password_field(method, options = {})
        render_shadcn_input(:password, method, options)
      end

      # Render a shadcn number input
      def shadcn_number_field(method, options = {})
        render_shadcn_input(:number, method, options)
      end

      # Render a shadcn textarea
      def shadcn_text_area(method, options = {})
        @template.render(Ui::TextareaComponent.new(
          name: field_name(method),
          value: object.try(method),
          placeholder: options.delete(:placeholder),
          disabled: options.delete(:disabled) || false,
          required: options.delete(:required) || false,
          rows: options.delete(:rows) || 3,
          class_name: options.delete(:class),
          **options
        ))
      end

      # Render a shadcn select
      def shadcn_select(method, choices, options = {}, html_options = {})
        selected_value = object.try(method)

        component = Ui::SelectComponent.new(
          name: field_name(method),
          value: selected_value,
          placeholder: options.delete(:placeholder) || options.delete(:prompt),
          disabled: html_options.delete(:disabled) || false,
          required: html_options.delete(:required) || false,
          class_name: html_options.delete(:class),
          **html_options
        )

        @template.render(component) do |select|
          choices.each do |choice|
            value, label = choice.is_a?(Array) ? [choice.last, choice.first] : [choice, choice]
            select.with_option(value: value, selected: value.to_s == selected_value.to_s) { label }
          end
        end
      end

      # Render a shadcn checkbox
      def shadcn_check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        @template.render(Ui::CheckboxComponent.new(
          name: field_name(method),
          value: checked_value,
          checked: object.try(method).present?,
          disabled: options.delete(:disabled) || false,
          required: options.delete(:required) || false,
          id: options.delete(:id) || field_id(method),
          class_name: options.delete(:class),
          **options
        ))
      end

      # Render a shadcn switch
      def shadcn_switch(method, options = {})
        @template.render(Ui::SwitchComponent.new(
          name: field_name(method),
          checked: object.try(method).present?,
          disabled: options.delete(:disabled) || false,
          id: options.delete(:id) || field_id(method),
          class_name: options.delete(:class),
          **options
        ))
      end

      # Render a shadcn label
      def shadcn_label(method, text = nil, options = {})
        @template.render(Ui::LabelComponent.new(
          for_id: field_id(method),
          required: options.delete(:required) || false,
          class_name: options.delete(:class),
          **options
        )) { text || method.to_s.humanize }
      end

      # Render a shadcn submit button
      def shadcn_submit(value = nil, options = {})
        value ||= submit_default_value

        @template.render(Ui::ButtonComponent.new(
          type: "submit",
          variant: options.delete(:variant) || :default,
          size: options.delete(:size) || :default,
          disabled: options.delete(:disabled) || false,
          class_name: options.delete(:class),
          **options
        )) { value }
      end

      private

      def render_shadcn_input(type, method, options)
        @template.render(Ui::InputComponent.new(
          type: type.to_s,
          name: field_name(method),
          value: object.try(method),
          placeholder: options.delete(:placeholder),
          disabled: options.delete(:disabled) || false,
          required: options.delete(:required) || false,
          autocomplete: options.delete(:autocomplete),
          class_name: options.delete(:class),
          **options
        ))
      end

      def field_name(method)
        "#{object_name}[#{method}]"
      end

      def field_id(method)
        "#{object_name}_#{method}"
      end
    end
  end
end
