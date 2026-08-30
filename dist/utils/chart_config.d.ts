export type ChartKind = "bar" | "line" | "area" | "pie" | "donut";
export type ChartJsKind = "bar" | "line" | "pie" | "doughnut";
export type ChartSeriesConfig = {
    label?: string;
    color?: string;
};
export type ChartConfig = Record<string, ChartSeriesConfig>;
export type ChartDataset = {
    label?: string;
    data?: unknown;
    key?: string;
    backgroundColor?: unknown;
    borderColor?: unknown;
    pointBackgroundColor?: unknown;
    pointBorderColor?: unknown;
    fill?: boolean | string;
    tension?: number;
    [property: string]: unknown;
};
export type ChartData = {
    labels?: string[];
    datasets?: ChartDataset[];
    [property: string]: unknown;
};
export type LegendItem = {
    label: string;
    color: string;
    datasetIndex: number;
    dataIndex?: number;
};
type TooltipContext = {
    chart: {
        canvas: HTMLCanvasElement;
    };
    tooltip: {
        opacity: number;
        caretX: number;
        caretY: number;
        title?: string[];
        body?: Array<{
            lines: string[];
        }>;
        labelColors?: Array<{
            backgroundColor: string;
            borderColor: string;
        }>;
    };
};
type TooltipRenderer = (context: TooltipContext) => void;
export declare function normalizeChartType(type: string): ChartJsKind;
export declare function cssVariableName(key: string): string;
export declare function defaultChartColor(index: number): string;
export declare function resolveCssColor(element: HTMLElement, value: string): string;
export declare function seriesKey(dataset: ChartDataset, index: number): string;
export declare function seriesLabel(dataset: ChartDataset, config: ChartConfig, index: number): string;
export declare function seriesColor(element: HTMLElement, dataset: ChartDataset, config: ChartConfig, index: number): string;
export declare function buildLegendItems(element: HTMLElement, type: ChartKind, data: ChartData, config: ChartConfig): LegendItem[];
export declare function buildChartData(element: HTMLElement, type: ChartKind, data: ChartData, config: ChartConfig): ChartData;
export declare function buildChartOptions({ renderTooltip }: {
    renderTooltip: TooltipRenderer;
}): Record<string, unknown>;
export {};
//# sourceMappingURL=chart_config.d.ts.map