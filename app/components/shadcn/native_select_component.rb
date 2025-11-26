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
    BASE_CLASSES = "flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1"

    # Option slot
    renders_many :options, "OptionComponent"

    # Optgroup slot
    renders_many :optgroups, "OptgroupComponent"

    # @param name [String, nil] Select name attribute
    # @param id [String, nil] Select ID attribute
    # @param disabled [Boolean] Whether the select is disabled
    # @param required [Boolean] Whether the select is required
    def initialize(name: nil, id: nil, disabled: false, required: false, **options)
      super(**options)
      @name = name
      @id = id
      @disabled = disabled
      @required = required
    end

    def call
      tag.select(**select_attributes) do
        if optgroups.any?
          safe_join(optgroups)
        else
          safe_join(options)
        end
      end
    end

    private

    def select_attributes
      {
        name: @name,
        id: @id,
        disabled: @disabled || nil,
        required: @required || nil,
        class: merge_classes(BASE_CLASSES)
      }.merge(html_options).merge(build_data).compact
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
