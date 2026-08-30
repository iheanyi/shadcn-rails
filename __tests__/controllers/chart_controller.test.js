import {
  buildChartData,
  buildChartOptions,
  buildLegendItems,
  cssVariableName,
  normalizeChartType
} from "../../app/assets/javascripts/shadcn/utils/chart_config.ts"
import ChartController from "../../app/assets/javascripts/shadcn/controllers/chart_controller.ts"

describe("chart config builders", () => {
  const data = {
    labels: ["January", "February"],
    datasets: [
      { key: "desktop", label: "Desktop", data: [186, 305] },
      { key: "mobile", label: "Mobile", data: [80, 200], tension: 0.2 }
    ]
  }

  const config = {
    desktop: { label: "Desktop users" },
    mobile: { label: "Mobile users", color: "hsl(173 58% 39%)" }
  }

  const setupElement = () => {
    const element = document.createElement("div")
    element.style.setProperty("--color-desktop", "12 76% 61%")
    element.style.setProperty("--color-mobile", "hsl(173 58% 39%)")
    element.style.setProperty("--chart-1", "12 76% 61%")
    element.style.setProperty("--background", "0 0% 100%")
    element.style.setProperty("--border", "0 0% 89.8%")
    element.style.setProperty("--muted-foreground", "0 0% 45.1%")
    document.body.appendChild(element)
    return element
  }

  afterEach(() => {
    document.body.innerHTML = ""
  })

  test("normalizes supported chart types to Chart.js types", () => {
    expect(normalizeChartType("bar")).toBe("bar")
    expect(normalizeChartType("line")).toBe("line")
    expect(normalizeChartType("area")).toBe("line")
    expect(normalizeChartType("pie")).toBe("pie")
    expect(normalizeChartType("donut")).toBe("doughnut")
    expect(normalizeChartType("unknown")).toBe("bar")
  })

  test("normalizes CSS variable names", () => {
    expect(cssVariableName("Desktop Visitors")).toBe("desktop-visitors")
    expect(cssVariableName(" net_new ")).toBe("net-new")
    expect(cssVariableName("")).toBe("series")
  })

  test("builds line data with resolved series colors", () => {
    const chartData = buildChartData(setupElement(), "line", data, config)

    expect(chartData.datasets[0]).toMatchObject({
      label: "Desktop users",
      borderColor: "hsl(12 76% 61%)",
      backgroundColor: "hsl(12 76% 61%)",
      pointBackgroundColor: "hsl(12 76% 61%)",
      fill: undefined,
      tension: 0.4
    })
    expect(chartData.datasets[1]).toMatchObject({
      label: "Mobile users",
      borderColor: "hsl(173 58% 39%)",
      tension: 0.2
    })
  })

  test("builds area data with fill enabled", () => {
    const chartData = buildChartData(setupElement(), "area", data, config)

    expect(chartData.datasets[0]).toMatchObject({
      fill: true,
      borderColor: "hsl(12 76% 61%)",
      backgroundColor: "hsl(12 76% 61% / 0.25)"
    })
  })

  test("builds circular data with per-label colors", () => {
    const element = setupElement()
    element.style.setProperty("--color-january", "220 70% 50%")
    element.style.setProperty("--color-february", "160 60% 45%")

    const chartData = buildChartData(element, "donut", {
      labels: ["January", "February"],
      datasets: [{ label: "Visitors", data: [275, 505] }]
    }, {
      January: { label: "Jan" },
      February: { label: "Feb" }
    })

    expect(chartData.datasets[0]).toMatchObject({
      label: "Visitors",
      backgroundColor: ["hsl(220 70% 50%)", "hsl(160 60% 45%)"],
      borderColor: "hsl(0 0% 100%)"
    })
  })

  test("resolves hsl var colors to canvas-safe hsl values", () => {
    const element = setupElement()
    const chartData = buildChartData(element, "bar", {
      labels: ["January"],
      datasets: [{ key: "desktop", data: [186] }]
    }, {
      desktop: { color: "hsl(var(--color-desktop))" }
    })

    expect(chartData.datasets[0].backgroundColor).toBe("hsl(12 76% 61%)")
    expect(chartData.datasets[0].borderColor).toBe("hsl(12 76% 61%)")
  })

  test("builds external legend items for cartesian charts", () => {
    const legendItems = buildLegendItems(setupElement(), "bar", data, config)

    expect(legendItems).toEqual([
      { label: "Desktop users", color: "hsl(12 76% 61%)", datasetIndex: 0 },
      { label: "Mobile users", color: "hsl(173 58% 39%)", datasetIndex: 1 }
    ])
  })

  test("builds external legend items for circular charts", () => {
    const element = setupElement()
    element.style.setProperty("--color-january", "220 70% 50%")

    const legendItems = buildLegendItems(element, "pie", {
      labels: ["January"],
      datasets: [{ data: [275] }]
    }, {
      January: { label: "Jan" }
    })

    expect(legendItems).toEqual([
      { label: "Jan", color: "hsl(220 70% 50%)", datasetIndex: 0, dataIndex: 0 }
    ])
  })

  test("builds options with Chart.js legend and tooltip disabled", () => {
    const element = setupElement()
    const renderTooltip = jest.fn()
    const options = buildChartOptions({ element, type: "bar", renderTooltip })

    expect(options.plugins.legend.display).toBe(false)
    expect(options.plugins.tooltip.enabled).toBe(false)
    expect(options.plugins.tooltip.external).toBe(renderTooltip)
    expect(options.scales.x.ticks.color).toBe("hsl(0 0% 45.1%)")
    expect(options.scales.y.grid.color).toBe("hsl(0 0% 89.8%)")
  })

  test("omits cartesian scales for circular charts", () => {
    const element = setupElement()
    const renderTooltip = jest.fn()

    expect(buildChartOptions({ element, type: "pie", renderTooltip }).scales).toBeUndefined()
    expect(buildChartOptions({ element, type: "donut", renderTooltip }).scales).toBeUndefined()
  })
})

describe("ChartController DOM rendering", () => {
  const setupControllerObject = () => {
    const controller = Object.create(ChartController.prototype)
    controller.tooltipTarget = document.createElement("div")
    controller.legendTarget = document.createElement("div")
    controller.renderToken = 0
    controller.connected = true
    controller.chart = null
    controller.themeObserver = null
    controller.boundBeforeCache = () => {}
    return controller
  }

  afterEach(() => {
    document.body.innerHTML = ""
  })

  test("renders legend swatches without interpolating colors into HTML", () => {
    const controller = setupControllerObject()

    controller.renderLegend([
      { label: "<Desktop>", color: "red; background-image: url(javascript:alert(1))", datasetIndex: 0 }
    ])

    expect(controller.legendTarget.textContent).toContain("<Desktop>")
    expect(controller.legendTarget.innerHTML).not.toContain("javascript:alert")
    expect(controller.legendTarget.querySelector("span").style.backgroundColor).toBe("")
  })

  test("renders tooltip swatches with style property assignment", () => {
    const controller = setupControllerObject()

    controller.renderTooltip({
      chart: { canvas: document.createElement("canvas") },
      tooltip: {
        opacity: 1,
        caretX: 20,
        caretY: 30,
        title: ["February"],
        body: [{ lines: ["Desktop: 305"] }],
        labelColors: [{ backgroundColor: "hsl(12 76% 61%)", borderColor: "hsl(12 76% 61%)" }]
      }
    })

    expect(controller.tooltipTarget.textContent).toContain("February")
    expect(controller.tooltipTarget.textContent).toContain("Desktop: 305")
    expect(controller.tooltipTarget.querySelector("span").style.backgroundColor).toMatch(/^rgb\(/)
  })

  test("disconnect invalidates in-flight renders", () => {
    const controller = setupControllerObject()
    const destroy = jest.fn()
    controller.chart = { destroy }

    controller.disconnect()

    expect(controller.connected).toBe(false)
    expect(controller.renderToken).toBe(1)
    expect(destroy).toHaveBeenCalled()
  })

  test("value changes rerender only after connect", () => {
    const controller = setupControllerObject()
    controller.renderChart = jest.fn()

    controller.connected = false
    controller.dataValueChanged()
    expect(controller.renderChart).not.toHaveBeenCalled()

    controller.connected = true
    controller.typeValueChanged()
    controller.configValueChanged()
    expect(controller.renderChart).toHaveBeenCalledTimes(2)
  })
})
