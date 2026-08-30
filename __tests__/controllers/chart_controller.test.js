import {
  buildChartData,
  buildChartOptions,
  buildLegendItems,
  cssVariableName,
  normalizeChartType
} from "../../app/assets/javascripts/shadcn/utils/chart_config.ts"

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
    element.style.setProperty("--color-desktop", "hsl(12 76% 61%)")
    element.style.setProperty("--color-mobile", "hsl(173 58% 39%)")
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
      backgroundColor: "hsl(12 76% 61%)"
    })
  })

  test("builds circular data with per-label colors", () => {
    const element = setupElement()
    element.style.setProperty("--color-january", "hsl(220 70% 50%)")
    element.style.setProperty("--color-february", "hsl(160 60% 45%)")

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
      borderColor: "hsl(var(--background))"
    })
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
    element.style.setProperty("--color-january", "hsl(220 70% 50%)")

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
    const renderTooltip = jest.fn()
    const options = buildChartOptions({ renderTooltip })

    expect(options.plugins.legend.display).toBe(false)
    expect(options.plugins.tooltip.enabled).toBe(false)
    expect(options.plugins.tooltip.external).toBe(renderTooltip)
  })
})
