# frozen_string_literal: true

# @label Chart
# @display bg_color "#ffffff"
class ChartComponentPreview < ViewComponent::Preview
  MONTHLY_DATA = {
    labels: ["January", "February", "March", "April", "May", "June"],
    datasets: [
      { key: "desktop", label: "Desktop", data: [186, 305, 237, 73, 209, 214] },
      { key: "mobile", label: "Mobile", data: [80, 200, 120, 190, 130, 140] }
    ]
  }.freeze

  MONTHLY_CONFIG = {
    desktop: { label: "Desktop", color: "hsl(var(--chart-1))" },
    mobile: { label: "Mobile", color: "hsl(var(--chart-2))" }
  }.freeze

  DEVICE_DATA = {
    labels: ["Desktop", "Mobile", "Tablet", "Other"],
    datasets: [
      { label: "Visitors", data: [1260, 980, 420, 190] }
    ]
  }.freeze

  DEVICE_CONFIG = {
    "Desktop" => { label: "Desktop", color: "hsl(var(--chart-1))" },
    "Mobile" => { label: "Mobile", color: "hsl(var(--chart-2))" },
    "Tablet" => { label: "Tablet", color: "hsl(var(--chart-3))" },
    "Other" => { label: "Other", color: "hsl(var(--chart-4))" }
  }.freeze

  # @label Default
  # A bar chart using shadcn chart color tokens.
  def default
    render Shadcn::ChartComponent.new(
      type: :bar,
      data: MONTHLY_DATA,
      config: MONTHLY_CONFIG,
      aria_label: "Monthly visitors by device"
    ) do |chart|
      chart.with_fallback { fallback_table("Monthly visitors", MONTHLY_DATA) }
    end
  end

  # @label Line
  def line
    render Shadcn::ChartComponent.new(
      type: :line,
      data: MONTHLY_DATA,
      config: MONTHLY_CONFIG,
      aria_label: "Monthly visitor trends by device"
    )
  end

  # @label Area
  def area
    render Shadcn::ChartComponent.new(
      type: :area,
      data: MONTHLY_DATA,
      config: MONTHLY_CONFIG,
      aria_label: "Monthly visitor area chart by device"
    )
  end

  # @label Pie
  def pie
    render Shadcn::ChartComponent.new(
      type: :pie,
      data: DEVICE_DATA,
      config: DEVICE_CONFIG,
      aria_label: "Visitors by device category"
    )
  end

  # @label Donut
  def donut
    render Shadcn::ChartComponent.new(
      type: :donut,
      data: DEVICE_DATA,
      config: DEVICE_CONFIG,
      aria_label: "Visitors by device category as a donut chart"
    )
  end

  private

  def fallback_table(caption, data)
    labels = data.fetch(:labels)
    datasets = data.fetch(:datasets)

    rows = labels.each_with_index.map do |label, index|
      cells = datasets.map { |dataset| "<td>#{dataset.fetch(:data)[index]}</td>" }.join
      "<tr><th scope=\"row\">#{label}</th>#{cells}</tr>"
    end.join

    <<~HTML.html_safe
      <table>
        <caption>#{caption}</caption>
        <thead>
          <tr>
            <th scope="col">Month</th>
            #{datasets.map { |dataset| "<th scope=\"col\">#{dataset.fetch(:label)}</th>" }.join}
          </tr>
        </thead>
        <tbody>#{rows}</tbody>
      </table>
    HTML
  end
end
