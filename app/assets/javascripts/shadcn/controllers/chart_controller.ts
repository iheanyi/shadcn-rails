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
  themeObserver: MutationObserver | null = null
  boundBeforeCache: () => void = () => this.destroyChart()

  connect() {
    document.addEventListener("turbo:before-cache", this.boundBeforeCache)
    this.themeObserver = new MutationObserver(() => this.renderChart())
    this.themeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["class"]
    })

    this.renderChart()
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.boundBeforeCache)
    this.themeObserver?.disconnect()
    this.themeObserver = null
    this.destroyChart()
  }

  async renderChart() {
    const token = this.renderToken + 1
    this.renderToken = token
    this.destroyChart()
    this.clearMessage()

    try {
      const chartJs: ChartJsModule = await loadChartJs()
      if (token !== this.renderToken) return

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

    this.tooltipTarget.innerHTML = [
      ...title.map((line) => `<div class="mb-1 font-medium text-foreground">${escapeHtml(line)}</div>`),
      ...rows.map((row) => `
        <div class="flex items-center gap-2">
          <span class="h-2.5 w-2.5 shrink-0 rounded-[2px]" style="background-color: ${escapeHtml(row.color)}"></span>
          <span class="text-muted-foreground">${escapeHtml(row.line)}</span>
        </div>
      `)
    ].join("")
    this.tooltipTarget.style.left = `${tooltip.caretX}px`
    this.tooltipTarget.style.top = `${tooltip.caretY}px`
    this.tooltipTarget.classList.remove("hidden")
  }

  renderLegend(items: LegendItem[]) {
    if (items.length === 0) {
      this.legendTarget.innerHTML = ""
      return
    }

    this.legendTarget.innerHTML = items.map((item) => `
      <div class="flex items-center gap-2">
        <span class="h-2.5 w-2.5 shrink-0 rounded-[2px]" style="background-color: ${escapeHtml(item.color)}"></span>
        <span>${escapeHtml(item.label)}</span>
      </div>
    `).join("")
  }

  showMessage(message: string) {
    this.legendTarget.innerHTML = `<p class="text-sm text-muted-foreground">${escapeHtml(message)}</p>`
  }

  clearMessage() {
    this.tooltipTarget.classList.add("hidden")
    this.tooltipTarget.innerHTML = ""
    this.legendTarget.innerHTML = ""
  }
}

function missingChartJsError(error: unknown): boolean {
  if (!(error instanceof Error)) return true

  return error.message.includes("chart.js") || error.message.includes("Failed to resolve module")
}

function escapeHtml(value: string): string {
  const div = document.createElement("div")
  div.textContent = value
  return div.innerHTML
}
