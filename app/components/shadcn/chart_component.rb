# frozen_string_literal: true

require "json"

module Shadcn
  # Chart component powered by Chart.js and themed with shadcn CSS variables.
  #
  # @example Bar chart
  #   <%= render Shadcn::ChartComponent.new(type: :bar, data: data, config: config) %>
  class ChartComponent < BaseComponent
    renders_one :fallback

    TYPES = %i[bar line area pie donut].freeze
    BASE_CLASSES = "relative flex h-[350px] w-full flex-col gap-4"
    CANVAS_WRAP_CLASSES = "relative min-h-0 flex-1"
    CANVAS_CLASSES = "h-full w-full"
    TOOLTIP_CLASSES = "pointer-events-none absolute z-50 hidden min-w-[8rem] rounded-lg border bg-background px-3 py-2 text-xs text-foreground shadow-xl"
    LEGEND_CLASSES = "flex flex-wrap items-center justify-center gap-4 text-sm text-muted-foreground"
    FALLBACK_CLASSES = "sr-only"

    attr_reader :type, :data, :config, :aria_label

    # @param type [Symbol, String] Chart type: :bar, :line, :area, :pie, or :donut
    # @param data [Hash] Chart.js-compatible data hash
    # @param config [Hash] Series configuration keyed by dataset key or label
    # @param aria_label [String] Accessible label for the chart image region
    def initialize(type:, data:, config: {}, aria_label: "Chart", **options)
      super(**options)
      @type = normalize_type(type)
      @data = data
      @config = config
      @aria_label = aria_label
    end

    def call
      content_tag(:div, **chart_attributes) do
        safe_join([
          canvas_wrap,
          legend,
          fallback_content
        ].compact)
      end
    end

    private

    def normalize_type(type)
      normalized = type.to_sym
      return normalized if TYPES.include?(normalized)

      raise ArgumentError, "Unknown chart type: #{type}. Expected one of: #{TYPES.join(', ')}"
    end

    def chart_attributes
      attrs = merge_html_attributes(
        {
          role: "img",
          "aria-label": aria_label,
          style: style_attribute
        },
        stimulus_data(
          controller: "shadcn--chart",
          values: {
            type: type.to_s,
            data: json_value(data),
            config: json_value(normalized_config)
          }
        )
      )
      attrs[:class] = merge_classes(BASE_CLASSES)
      attrs[:style] = [style_attribute, html_options[:style]].compact.join("; ")
      attrs
    end

    def canvas_wrap
      content_tag(:div, class: CANVAS_WRAP_CLASSES) do
        safe_join([
          tag.canvas(
            class: CANVAS_CLASSES,
            aria: { hidden: true },
            data: { "shadcn--chart-target": "canvas" }
          ),
          content_tag(:div, "", class: TOOLTIP_CLASSES, data: { "shadcn--chart-target": "tooltip" })
        ])
      end
    end

    def legend
      content_tag(:div, "", class: LEGEND_CLASSES, data: { "shadcn--chart-target": "legend" })
    end

    def fallback_content
      return unless fallback

      content_tag(:div, fallback, class: FALLBACK_CLASSES)
    end

    def normalized_config
      config.each_with_index.to_h do |(key, value), index|
        [key, normalize_series_config(key, value, index)]
      end
    end

    def normalize_series_config(key, value, index)
      attrs = value.respond_to?(:to_h) ? value.to_h : {}
      attrs = attrs.transform_keys(&:to_s)
      attrs["label"] ||= key.to_s.humanize
      attrs["color"] ||= "hsl(var(--chart-#{(index % 5) + 1}))"
      attrs
    end

    def style_attribute
      normalized_config.each_with_index.map do |(key, value), index|
        color = value.fetch("color", "hsl(var(--chart-#{(index % 5) + 1}))")
        "--color-#{css_variable_name(key)}: #{color}"
      end.join("; ")
    end

    def css_variable_name(key)
      key.to_s.parameterize.presence || "series"
    end

    def json_value(value)
      JSON.generate(value)
    end
  end
end
