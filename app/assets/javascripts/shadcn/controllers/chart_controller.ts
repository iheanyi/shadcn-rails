import { Controller } from "@hotwired/stimulus"
import type { ChartData, ChartConfig, ChartKind, LegendItem } from "../utils/chart_config"
import {
  buildChartData,
  buildChartOptions,
  buildLegendItems,
  normalizeChartType
} from "../utils/chart_config"

const loadChartJs = () => import("chart.js/auto")
const INSTALL_MESSAGE = "Chart.js is required for Shadcn::ChartComponent. Install and pin it with: npm install chart.js@^4.5.1"

type ChartInstance = {
  data: unknown
  options: unknown
  destroy(): void
  update(mode?: string): void
}

type ChartJsModule = {
  default: new (
    context: CanvasRenderingContext2D,
    config: {
      type: string
      data: unknown
      options: unknown
    }
  ) => ChartInstance
}

export default class extends Controller<HTMLElement> {
  static targets = ["canvas", "tooltip", "legend"]
  static values = {
    type: String,
    data: Object,
    config: Object
  }

  declare readonly canvasTarget: HTMLCanvasElement
  declare readonly tooltipTarget: HTMLElement
  declare readonly legendTarget: HTMLElement
  declare readonly typeValue: ChartKind
  declare readonly dataValue: ChartData
  declare readonly configValue: ChartConfig

  chart: ChartInstance | null = null
  renderToken = 0
  connected = false
  themeObserver: MutationObserver | null = null
  boundBeforeCache: () => void = () => this.invalidateRender()

  connect() {
    this.connected = true
    document.addEventListener("turbo:before-cache", this.boundBeforeCache)
    this.themeObserver = new MutationObserver(() => this.renderChart())
    this.themeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class"]
    })

    this.renderChart()
  }

  disconnect() {
    this.connected = false
    document.removeEventListener("turbo:before-cache", this.boundBeforeCache)
    this.themeObserver?.disconnect()
    this.themeObserver = null
    this.invalidateRender()
  }

  typeValueChanged() {
    this.renderWhenConnected()
  }

  dataValueChanged() {
    this.renderWhenConnected()
  }

  configValueChanged() {
    this.renderWhenConnected()
  }

  async renderChart() {
    if (!this.connected) return

    const token = this.renderToken + 1
    this.renderToken = token
    this.destroyChart()
    this.clearMessage()

    try {
      const chartJs: ChartJsModule = await loadChartJs()
      if (token !== this.renderToken || !this.connected || !this.element.isConnected) return

      const context = this.canvasTarget.getContext("2d")
      if (!context) {
        this.showMessage("Chart canvas is not available in this browser.")
        return
      }

      const chartData = buildChartData(this.element, this.typeValue, this.dataValue, this.configValue)
      const options = buildChartOptions({
        element: this.element,
        type: this.typeValue,
        renderTooltip: this.renderTooltip.bind(this)
      })

      this.chart = new chartJs.default(context, {
        type: normalizeChartType(this.typeValue),
        data: chartData,
        options
      })
      this.renderLegend(buildLegendItems(this.element, this.typeValue, chartData, this.configValue))
    } catch (error: unknown) {
      this.showMessage(missingChartJsError(error) ? INSTALL_MESSAGE : "Unable to render chart.")
    }
  }

  destroyChart() {
    if (!this.chart) return

    this.chart.destroy()
    this.chart = null
  }

  invalidateRender() {
    this.renderToken += 1
    this.destroyChart()
    this.clearMessage()
  }

  renderTooltip(context: {
    chart: { canvas: HTMLCanvasElement }
    tooltip: {
      opacity: number
      caretX: number
      caretY: number
      title?: string[]
      body?: Array<{ lines: string[] }>
      labelColors?: Array<{ backgroundColor: string; borderColor: string }>
    }
  }) {
    const { tooltip } = context

    if (tooltip.opacity === 0) {
      this.tooltipTarget.classList.add("hidden")
      return
    }

    const title = tooltip.title || []
    const rows = (tooltip.body || []).flatMap((body, index) => {
      const color = tooltip.labelColors?.[index]?.backgroundColor || tooltip.labelColors?.[index]?.borderColor || "hsl(var(--border))"
      return body.lines.map((line) => ({ line, color }))
    })

    const titleNodes = title.map((line) => {
      const titleNode = document.createElement("div")
      titleNode.className = "mb-1 font-medium text-foreground"
      titleNode.textContent = line
      return titleNode
    })
    const rowNodes = rows.map((row) => {
      const rowNode = document.createElement("div")
      rowNode.className = "flex items-center gap-2"
      rowNode.append(this.colorSwatch(row.color), this.textNode(row.line, "text-muted-foreground"))
      return rowNode
    })

    this.tooltipTarget.replaceChildren(...titleNodes, ...rowNodes)
    this.tooltipTarget.style.left = `${tooltip.caretX}px`
    this.tooltipTarget.style.top = `${tooltip.caretY}px`
    this.tooltipTarget.classList.remove("hidden")
  }

  renderLegend(items: LegendItem[]) {
    if (items.length === 0) {
      this.legendTarget.innerHTML = ""
      return
    }

    const nodes = items.map((item) => {
      const itemNode = document.createElement("div")
      itemNode.className = "flex items-center gap-2"
      itemNode.append(this.colorSwatch(item.color), this.textNode(item.label))
      return itemNode
    })

    this.legendTarget.replaceChildren(...nodes)
  }

  showMessage(message: string) {
    const messageNode = document.createElement("p")
    messageNode.className = "text-sm text-muted-foreground"
    messageNode.textContent = message
    this.legendTarget.replaceChildren(messageNode)
  }

  clearMessage() {
    this.tooltipTarget.classList.add("hidden")
    this.tooltipTarget.replaceChildren()
    this.legendTarget.replaceChildren()
  }

  renderWhenConnected() {
    if (this.connected) this.renderChart()
  }

  colorSwatch(color: string): HTMLSpanElement {
    const swatch = document.createElement("span")
    swatch.className = "h-2.5 w-2.5 shrink-0 rounded-[2px]"
    swatch.style.backgroundColor = color
    return swatch
  }

  textNode(text: string, className?: string): HTMLSpanElement {
    const span = document.createElement("span")
    if (className) span.className = className
    span.textContent = text
    return span
  }
}

function missingChartJsError(error: unknown): boolean {
  if (!(error instanceof Error)) return true

  return error.message.includes("chart.js") || error.message.includes("Failed to resolve module")
}

