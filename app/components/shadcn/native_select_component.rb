# frozen_string_literal: true

module Shadcn
  # Native Select component for styled native HTML selects
  # Matches shadcn/ui Native Select component
  #
  # @example Basic select
  #   <%= render Shadcn::NativeSelectComponent.new(name: "country") do |select| %>
  #     <% select.with_option(value: "", disabled: true, selected: true) { "Select a country" } %>
  #     <% select.with_option(value: "us") { "United States" } %>
  #     <% select.with_option(value: "uk") { "United Kingdom" } %>
  #     <% select.with_option(value: "ca") { "Canada" } %>
  #   <% end %>
  #
  # @example With optgroups
  #   <%= render Shadcn::NativeSelectComponent.new(name: "car") do |select| %>
  #     <% select.with_optgroup(label: "Swedish Cars") do |group| %>
  #       <% group.with_option(value: "volvo") { "Volvo" } %>
  #       <% group.with_option(value: "saab") { "Saab" } %>
  #     <% end %>
  #     <% select.with_optgroup(label: "German Cars") do |group| %>
  #       <% group.with_option(value: "mercedes") { "Mercedes" } %>
  #       <% group.with_option(value: "audi") { "Audi" } %>
  #     <% end %>
  #   <% end %>
  #
  # @example Disabled
  #   <%= render Shadcn::NativeSelectComponent.new(name: "status", disabled: true) do |select| %>
  #     <% select.with_option(value: "active") { "Active" } %>
  #   <% end %>
  #
  class NativeSelectComponent < BaseComponent
    # Select wrapper classes for positioning the chevron icon
    WRAPPER_CLASSES = "relative"

    # Native select element classes
    SELECT_CLASSES = "h-9 w-full cursor-pointer appearance-none rounded-md border border-input bg-transparent pl-3 pr-8 text-sm shadow-sm focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50"

    # Chevron icon classes (positioned absolutely)
    CHEVRON_CLASSES = "pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground"

    # Option slot
    renders_many :options, "OptionComponent"

    # Optgroup slot
    renders_many :optgroups, "OptgroupComponent"

    # @param name [String, nil] Select name attribute
    # @param id [String, nil] Select ID attribute
    # @param disabled [Boolean] Whether the select is disabled
    # @param required [Boolean] Whether the select is required
    # @param options_html [String, nil] Pre-rendered option tags, useful for Rails FormBuilder output
    # @param select_class [String, nil] Additional classes for the select element
    def initialize(name: nil, id: nil, disabled: false, required: false, options_html: nil, select_class: nil, **options)
      super(**options)
      @name = name
      @id = id
      @disabled = disabled
      @required = required
      @options_html = options_html
      @select_class = select_class
    end

    private

    def wrapper_attributes
      {
        class: merge_classes(WRAPPER_CLASSES)
      }
    end

    def select_attributes
      html_options
        .merge(build_data)
        .merge(
          name: @name,
          id: @id,
          disabled: @disabled || nil,
          required: @required || nil,
          class: select_classes
        )
        .compact
    end

    def select_classes
      cn(SELECT_CLASSES, @select_class)
    end

    def select_content
      if @options_html.present?
        @options_html
      elsif content.present?
        content
      elsif optgroups.any?
        safe_join(optgroups)
      else
        safe_join(options)
      end
    end

    # Option subcomponent
    class OptionComponent < BaseComponent
      # @param value [String] Option value
      # @param disabled [Boolean] Whether the option is disabled
      # @param selected [Boolean] Whether the option is selected
      def initialize(value: nil, disabled: false, selected: false, **options)
        super(**options)
        @value = value
        @disabled = disabled
        @selected = selected
      end

      def call
        tag.option(content, **option_attributes)
      end

      private

      def option_attributes
        {
          value: @value,
          disabled: @disabled || nil,
          selected: @selected || nil
        }.merge(html_options).merge(build_data).compact
      end
    end

    # Optgroup subcomponent
    class OptgroupComponent < BaseComponent
      renders_many :options, OptionComponent

      # @param label [String] Optgroup label
      # @param disabled [Boolean] Whether the optgroup is disabled
      def initialize(label:, disabled: false, **options)
        super(**options)
        @label = label
        @disabled = disabled
      end

      def call
        tag.optgroup(label: @label, disabled: @disabled || nil, **html_options.merge(build_data).compact) do
          safe_join(options)
        end
      end
    end
  end
end
