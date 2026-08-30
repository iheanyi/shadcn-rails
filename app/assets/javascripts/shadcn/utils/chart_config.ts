export type ChartKind = "bar" | "line" | "area" | "pie" | "donut"
export type ChartJsKind = "bar" | "line" | "pie" | "doughnut"

export type ChartSeriesConfig = {
  label?: string
  color?: string
}

export type ChartConfig = Record<string, ChartSeriesConfig>

export type ChartDataset = {
  label?: string
  data?: unknown
  key?: string
  backgroundColor?: unknown
  borderColor?: unknown
  pointBackgroundColor?: unknown
  pointBorderColor?: unknown
  fill?: boolean | string
  tension?: number
  [property: string]: unknown
}

export type ChartData = {
  labels?: string[]
  datasets?: ChartDataset[]
  [property: string]: unknown
}

export type LegendItem = {
  label: string
  color: string
  datasetIndex: number
  dataIndex?: number
}

type TooltipContext = {
  chart: {
    canvas: HTMLCanvasElement
  }
  tooltip: {
    opacity: number
    caretX: number
    caretY: number
    title?: string[]
    body?: Array<{ lines: string[] }>
    labelColors?: Array<{ backgroundColor: string; borderColor: string }>
  }
}

type TooltipRenderer = (context: TooltipContext) => void
const DEFAULT_SERIES_COUNT = 5

export function normalizeChartType(type: string): ChartJsKind {
  switch (type) {
    case "bar":
      return "bar"
    case "line":
    case "area":
      return "line"
    case "pie":
      return "pie"
    case "donut":
      return "doughnut"
    default:
      return "bar"
  }
}

export function cssVariableName(key: string): string {
  const normalized = key
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")

  return normalized || "series"
}

export function defaultChartColor(index: number): string {
  return `hsl(var(--chart-${(index % DEFAULT_SERIES_COUNT) + 1}))`
}

export function resolveCssColor(element: HTMLElement, value: string): string {
  const trimmed = value.trim()
  const variableMatch = trimmed.match(/^var\((--[^)]+)\)$/)
  if (!variableMatch) return trimmed

  const resolved = getComputedStyle(element).getPropertyValue(variableMatch[1]).trim()
  return resolved || trimmed
}

export function seriesKey(dataset: ChartDataset, index: number): string {
  if (typeof dataset.key === "string" && dataset.key.length > 0) return dataset.key
  if (typeof dataset.label === "string" && dataset.label.length > 0) return dataset.label

  return `series-${index + 1}`
}

export function seriesLabel(dataset: ChartDataset, config: ChartConfig, index: number): string {
  const key = seriesKey(dataset, index)
  return config[key]?.label || dataset.label || key
}

export function seriesColor(element: HTMLElement, dataset: ChartDataset, config: ChartConfig, index: number): string {
  const key = seriesKey(dataset, index)
  const cssVariable = `var(--color-${cssVariableName(key)})`
  const configured = config[key]?.color || cssVariable
  const resolved = resolveCssColor(element, configured)

  return resolved === cssVariable ? defaultChartColor(index) : resolved
}

export function buildLegendItems(element: HTMLElement, type: ChartKind, data: ChartData, config: ChartConfig): LegendItem[] {
  if (type === "pie" || type === "donut") {
    return (data.labels || []).map((label, index) => ({
      label: config[label]?.label || label,
      color: resolveLegendColor(element, config[label]?.color || `var(--color-${cssVariableName(label)})`, index),
      datasetIndex: 0,
      dataIndex: index
    }))
  }

  return (data.datasets || []).map((dataset, index) => ({
    label: seriesLabel(dataset, config, index),
    color: seriesColor(element, dataset, config, index),
    datasetIndex: index
  }))
}

function resolveLegendColor(element: HTMLElement, color: string, index: number): string {
  const resolved = resolveCssColor(element, color)

  return resolved === color && color.startsWith("var(") ? defaultChartColor(index) : resolved
}

export function buildChartData(element: HTMLElement, type: ChartKind, data: ChartData, config: ChartConfig): ChartData {
  const isCircular = type === "pie" || type === "donut"

  return {
    ...data,
    datasets: (data.datasets || []).map((dataset, index) => {
      const color = seriesColor(element, dataset, config, index)
      const label = seriesLabel(dataset, config, index)

      if (isCircular) {
        const labels = data.labels || []
        const colors = labels.map((labelKey, labelIndex) => {
          const labelConfig = config[labelKey]
          const configured = labelConfig?.color || `var(--color-${cssVariableName(labelKey)})`
          const resolved = resolveCssColor(element, configured)

          return resolved === configured && configured.startsWith("var(")
            ? defaultChartColor(labelIndex)
            : resolved
        })

        return {
          ...dataset,
          label,
          backgroundColor: colors.length > 0 ? colors : color,
          borderColor: "hsl(var(--background))"
        }
      }

      return {
        ...dataset,
        label,
        borderColor: color,
        backgroundColor: type === "area" ? color : dataset.backgroundColor || color,
        pointBackgroundColor: color,
        pointBorderColor: color,
        fill: type === "area" ? true : dataset.fill,
        tension: typeof dataset.tension === "number" ? dataset.tension : 0.4
      }
    })
  }
}

export function buildChartOptions({
  renderTooltip
}: {
  renderTooltip: TooltipRenderer
}): Record<string, unknown> {
  return {
    responsive: true,
    maintainAspectRatio: false,
    interaction: {
      intersect: false,
      mode: "index"
    },
    plugins: {
      legend: {
        display: false
      },
      tooltip: {
        enabled: false,
        external: renderTooltip
      }
    },
    scales: {
      x: {
        border: {
          display: false
        },
        grid: {
          display: false
        },
        ticks: {
          color: "hsl(var(--muted-foreground))"
        }
      },
      y: {
        border: {
          display: false
        },
        grid: {
          color: "hsl(var(--border))"
        },
        ticks: {
          color: "hsl(var(--muted-foreground))"
        }
      }
    },
    animation: {}
  }
}
