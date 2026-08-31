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
    WRAPPER_CLASSES = "group/native-select relative w-fit has-[select:disabled]:opacity-50"

    # Native select element classes
    SELECT_CLASSES = "h-9 w-full min-w-0 appearance-none rounded-md border border-input bg-transparent px-3 py-2 pr-9 text-sm shadow-xs transition-[color,box-shadow] outline-none selection:bg-primary selection:text-primary-foreground placeholder:text-muted-foreground disabled:pointer-events-none disabled:cursor-not-allowed data-[size=sm]:h-8 data-[size=sm]:py-1 dark:bg-input/30 dark:hover:bg-input/50 focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40"

    # Chevron icon classes (positioned absolutely)
    CHEVRON_CLASSES = "pointer-events-none absolute top-1/2 right-3.5 size-4 -translate-y-1/2 text-muted-foreground opacity-50 select-none"

    # Native option element classes
    OPTION_CLASSES = "bg-[Canvas] text-[CanvasText]"

    # Native optgroup element classes
    OPTGROUP_CLASSES = "bg-[Canvas] text-[CanvasText]"

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
        "data-slot": "native-select-wrapper",
        class: merge_classes(WRAPPER_CLASSES)
      }
    end

    def select_attributes
      html_options
        .merge(build_data(slot: "native-select"))
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
          selected: @selected || nil,
          class: option_classes
        }.merge(html_options).merge(build_data(slot: "native-select-option")).compact
      end

      def option_classes
        cn(OPTION_CLASSES, class_name)
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
        tag.optgroup(label: @label, disabled: @disabled || nil, class: optgroup_classes, **html_options.merge(build_data(slot: "native-select-optgroup")).compact) do
          safe_join(options)
        end
      end

      private

      def optgroup_classes
        cn(OPTGROUP_CLASSES, class_name)
      end
    end
  end
end
