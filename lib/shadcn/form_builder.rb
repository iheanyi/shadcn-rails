# frozen_string_literal: true

require "action_view"

module Shadcn
  class FormBuilder < ActionView::Helpers::FormBuilder
    ERROR_CLASSES = "border-destructive focus-visible:ring-destructive"
    CHECKABLE_ERROR_CLASSES = "border-destructive focus-visible:ring-destructive"

    INPUT_TYPES = {
      text_field: "text",
      email_field: "email",
      password_field: "password",
      number_field: "number",
      telephone_field: "tel",
      phone_field: "tel",
      url_field: "url",
      search_field: "search",
      date_field: "date",
      datetime_field: "datetime-local",
      datetime_local_field: "datetime-local",
      time_field: "time",
      month_field: "month",
      week_field: "week",
      color_field: "color",
      range_field: "range",
      file_field: "file"
    }.freeze

    INPUT_TYPES.each do |helper_name, input_type|
      define_method(helper_name) do |method, options = {}|
        input_component(method, input_type, options)
      end
    end

    def text_area(method, options = {})
      options = options.dup
      value = options.delete(:value) { value_for(method) }

      render_component(
        Shadcn::TextareaComponent.new(**control_options(method, options, ERROR_CLASSES).merge(value: value))
      )
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      options = options.dup
      checked = options.key?(:checked) ? options.delete(:checked) : checked?(method, checked_value)
      include_hidden = options.key?(:include_hidden) ? options.delete(:include_hidden) : true

      render_component(
        Shadcn::CheckboxComponent.new(
          **control_options(method, options, CHECKABLE_ERROR_CLASSES).merge(
            value: checked_value,
            checked: checked,
            unchecked_value: unchecked_value,
            include_hidden: include_hidden
          )
        )
      )
    end

    def switch(method, options = {}, checked_value = "1", unchecked_value = "0")
      options = options.dup
      checked = options.key?(:checked) ? options.delete(:checked) : checked?(method, checked_value)
      include_hidden = options.key?(:include_hidden) ? options.delete(:include_hidden) : true

      render_component(
        Shadcn::SwitchComponent.new(
          **control_options(method, options, CHECKABLE_ERROR_CLASSES).merge(
            value: checked_value,
            checked: checked,
            unchecked_value: unchecked_value,
            include_hidden: include_hidden
          )
        )
      )
    end

    def radio_button(method, tag_value, options = {})
      options = options.dup
      checked = options.key?(:checked) ? options.delete(:checked) : value_for(method).to_s == tag_value.to_s
      label = options.delete(:label)
      description = options.delete(:description)

      render_component(
        Shadcn::RadioGroupItemComponent.new(
          **control_options(method, options, CHECKABLE_ERROR_CLASSES).merge(
            id: shadcn_field_id(method, tag_value),
            value: tag_value,
            group_name: shadcn_field_name(method),
            selected: checked,
            label: label,
            description: description
          )
        )
      )
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      options = options.dup
      html_options = html_options.dup
      options_html = block_given? ? @template.capture(&block) : option_tags(method, choices, options)

      native_select(method, options_html, html_options)
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      options = options.dup
      selected = options.key?(:selected) ? options[:selected] : value_for(method)
      option_tags = @template.options_from_collection_for_select(collection, value_method, text_method, selected)

      native_select(method, prepend_select_options(option_tags, options), html_options.dup)
    end

    def grouped_collection_select(
      method,
      collection,
      group_method,
      group_label_method,
      option_key_method,
      option_value_method,
      options = {},
      html_options = {}
    )
      options = options.dup
      selected = options.key?(:selected) ? options[:selected] : value_for(method)
      option_tags = @template.option_groups_from_collection_for_select(
        collection,
        group_method,
        group_label_method,
        option_key_method,
        option_value_method,
        selected
      )

      native_select(method, prepend_select_options(option_tags, options), html_options.dup)
    end

    def label(method, text = nil, options = {}, &block)
      options = options.dup
      value = options.delete(:value)
      options[:for] ||= value ? shadcn_field_id(method, value) : shadcn_field_id(method)
      label_text = text || method.to_s.humanize

      render_component(Shadcn::LabelComponent.new(**options)) do
        block_given? ? @template.capture(&block) : label_text
      end
    end

    def submit(value = nil, options = {})
      options = options.dup
      options[:type] = "submit"
      options[:variant] ||= :default
      options[:name] ||= "commit"
      options[:value] ||= value || "Save"

      render_component(Shadcn::ButtonComponent.new(**options)) { value || "Save" }
    end

    def field(method, label: nil, description: nil, as: :text_field, **options, &block)
      field_options = options.delete(:field_options) || {}
      label_options = options.delete(:label_options) || {}
      description_options = options.delete(:description_options) || {}
      error_options = options.delete(:error_options) || {}
      error_messages = errors_for(method)

      render_component(
        Shadcn::FieldComponent.new(name: shadcn_field_name(method), id: shadcn_field_id(method), **field_options)
      ) do |field_component|
        field_component.with_label(**label_options.merge(for: shadcn_field_id(method))) do
          label || method.to_s.humanize
        end

        field_component.with_control do
          if block_given?
            @template.capture(self, &block)
          else
            field_control(method, as, options)
          end
        end

        if description.present?
          field_component.with_description(**description_options) { description }
        end

        if error_messages.any?
          field_component.with_error(**error_options.merge(id: error_id(method))) do
            error_messages.join(", ")
          end
        end
      end
    end

    private

    def render_component(component, &block)
      @template.render(component, &block)
    end

    def input_component(method, input_type, options)
      options = options.dup
      value = options.delete(:value) { input_type == "file" ? nil : value_for(method) }

      render_component(
        Shadcn::InputComponent.new(
          **control_options(method, options, ERROR_CLASSES).merge(type: input_type, value: value)
        )
      )
    end

    def field_control(method, as, options)
      choices = options.delete(:choices)
      select_options = options.delete(:select_options) || {}

      case as.to_sym
      when :text_area, :textarea
        text_area(method, options)
      when :select
        select(method, choices || [], select_options, options)
      when :check_box, :checkbox
        check_box(method, options)
      when :switch
        switch(method, options)
      else
        public_send(as, method, options)
      end
    end

    def native_select(method, options_html, html_options)
      multiple = html_options[:multiple] || html_options["multiple"]
      select_class = html_options.delete(:class) || html_options.delete("class")

      render_component(
        Shadcn::NativeSelectComponent.new(
          **control_options(method, html_options, ERROR_CLASSES, multiple: multiple).merge(
            options_html: options_html.to_s.html_safe,
            select_class: select_class
          )
        )
      )
    end

    def option_tags(method, choices, options)
      selected = options.key?(:selected) ? options[:selected] : value_for(method)
      prepend_select_options(@template.options_for_select(choices || [], selected), options)
    end

    def prepend_select_options(option_tags, options)
      tags = +""

      if options[:include_blank]
        label = options[:include_blank] == true ? "" : options[:include_blank]
        tags << @template.content_tag(:option, label, value: "")
      end

      if options[:prompt]
        label = options[:prompt] == true ? "Please select" : options[:prompt]
        tags << @template.content_tag(:option, label, value: "")
      end

      (tags << option_tags.to_s).html_safe
    end

    def control_options(method, options, error_classes, multiple: false)
      options = options.dup
      options[:name] ||= shadcn_field_name(method, multiple: multiple)
      options[:id] ||= shadcn_field_id(method)
      apply_error_options(options, method, error_classes)
      options
    end

    def apply_error_options(options, method, error_classes)
      return options unless errors_for(method).any?

      options[:class] = Shadcn::Rails.cn(error_classes, options[:class])
      options[:aria] = (options[:aria] || {}).merge(invalid: true)

      describedby = [options.dig(:aria, :describedby), error_id(method)].compact.join(" ")
      options[:aria][:describedby] = describedby if describedby.present?
      options
    end

    def value_for(method)
      return nil unless @object && @object.respond_to?(method)

      @object.public_send(method)
    end

    def checked?(method, checked_value)
      value = value_for(method)

      value == true || value.to_s == checked_value.to_s
    end

    def errors_for(method)
      return [] unless @object&.respond_to?(:errors) && @object.errors.respond_to?(:include?)
      return [] unless @object.errors.include?(method)

      if @object.errors.respond_to?(:full_messages_for)
        @object.errors.full_messages_for(method)
      else
        @object.errors[method]
      end
    end

    def error_id(method)
      "#{shadcn_field_id(method)}_error"
    end

    def shadcn_field_name(method, multiple: false)
      field_name(method, multiple: multiple)
    end

    def shadcn_field_id(method, *suffixes)
      field_id(method, *suffixes)
    end
  end
end
