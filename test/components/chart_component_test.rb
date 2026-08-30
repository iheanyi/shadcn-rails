# frozen_string_literal: true

require "test_helper"

class ChartComponentTest < ViewComponent::TestCase
  DATA = {
    labels: ["January", "February"],
    datasets: [
      { key: "desktop", label: "Desktop", data: [186, 305] },
      { key: "mobile", label: "Mobile", data: [80, 200] }
    ]
  }.freeze

  CONFIG = {
    desktop: { label: "Desktop", color: "hsl(var(--chart-1))" },
    mobile: { label: "Mobile", color: "hsl(var(--chart-2))" }
  }.freeze

  def test_renders_chart_container
    render_inline(Shadcn::ChartComponent.new(type: :bar, data: DATA, config: CONFIG, aria_label: "Visitors by device"))

    assert_selector "[data-controller='shadcn--chart']"
    assert_selector "[data-controller='shadcn--chart']:not([role='img'])"
    assert_selector "[role='img'][aria-label='Visitors by device']"
    assert_selector "canvas[data-shadcn--chart-target='canvas'][aria-hidden='true']"
    assert_selector "[data-shadcn--chart-target='tooltip']"
    assert_selector "[data-shadcn--chart-target='legend']"
  end

  def test_serializes_type_data_and_config
    render_inline(Shadcn::ChartComponent.new(type: :line, data: DATA, config: CONFIG))

    root = page.find("[data-controller='shadcn--chart']")

    assert_equal "line", root["data-shadcn--chart-type-value"]
    assert_includes root["data-shadcn--chart-data-value"], "\"labels\":[\"January\",\"February\"]"
    assert_includes root["data-shadcn--chart-data-value"], "\"key\":\"desktop\""
    assert_includes root["data-shadcn--chart-config-value"], "\"desktop\""
    assert_includes root["data-shadcn--chart-config-value"], "\"label\":\"Desktop\""
  end

  def test_chart_payload_does_not_emit_host_data_attributes
    render_inline(Shadcn::ChartComponent.new(type: :line, data: DATA, config: CONFIG))

    assert_no_selector "[data-labels]"
    assert_no_selector "[data-datasets]"
  end

  def test_appends_host_data_when_using_chart_data_alias
    render_inline(Shadcn::ChartComponent.new(
      type: :line,
      chart_data: DATA,
      data: { testid: "traffic-chart", controller: "analytics" },
      config: CONFIG
    ))

    root = page.find("[data-testid='traffic-chart']")

    assert_includes root["data-controller"], "shadcn--chart"
    assert_includes root["data-controller"], "analytics"
    assert_includes root["data-shadcn--chart-data-value"], "\"labels\":[\"January\",\"February\"]"
  end

  def test_sets_series_css_variables
    render_inline(Shadcn::ChartComponent.new(type: :area, data: DATA, config: CONFIG))

    root = page.find("[data-controller='shadcn--chart']")

    assert_includes root["style"], "--color-desktop: hsl(var(--chart-1))"
    assert_includes root["style"], "--color-mobile: hsl(var(--chart-2))"
  end

  def test_defaults_series_config_to_chart_tokens
    render_inline(Shadcn::ChartComponent.new(
      type: :bar,
      data: DATA,
      config: { "net new" => {} }
    ))

    root = page.find("[data-controller='shadcn--chart']")

    assert_includes root["style"], "--color-net-new: hsl(var(--chart-1))"
    assert_includes root["data-shadcn--chart-config-value"], "\"label\":\"Net new\""
  end

  def test_renders_fallback_slot_as_visually_hidden_content
    render_inline(Shadcn::ChartComponent.new(type: :pie, data: DATA, config: CONFIG)) do |chart|
      chart.with_fallback do
        "<table><caption>Visitors</caption></table>".html_safe
      end
    end

    assert_selector ".sr-only table"
    assert_selector ".sr-only caption", text: "Visitors"
    assert_no_selector "[role='img'] table"
  end

  def test_merges_custom_class
    render_inline(Shadcn::ChartComponent.new(
      type: :donut,
      data: DATA,
      config: CONFIG,
      class_name: "max-w-xl"
    ))

    assert_selector ".max-w-xl"
  end

  def test_rejects_unknown_type
    error = assert_raises(ArgumentError) do
      Shadcn::ChartComponent.new(type: :radar, data: DATA, config: CONFIG)
    end

    assert_includes error.message, "Unknown chart type"
  end
end
