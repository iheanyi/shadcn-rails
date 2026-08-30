declare module "chart.js/auto" {
  type ChartInstance = {
    data: unknown
    options: unknown
    destroy(): void
    update(mode?: string): void
  }

  type ChartConstructor = new (
    context: CanvasRenderingContext2D,
    config: {
      type: string
      data: unknown
      options: unknown
    }
  ) => ChartInstance

  const Chart: ChartConstructor
  export default Chart
}
