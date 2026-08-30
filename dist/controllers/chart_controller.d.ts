import { Controller } from "@hotwired/stimulus";
import type { ChartData, ChartConfig, ChartKind, LegendItem } from "../utils/chart_config";
type ChartInstance = {
    data: unknown;
    options: unknown;
    destroy(): void;
    update(mode?: string): void;
};
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        type: StringConstructor;
        data: ObjectConstructor;
        config: ObjectConstructor;
    };
    readonly canvasTarget: HTMLCanvasElement;
    readonly tooltipTarget: HTMLElement;
    readonly legendTarget: HTMLElement;
    readonly typeValue: ChartKind;
    readonly dataValue: ChartData;
    readonly configValue: ChartConfig;
    chart: ChartInstance | null;
    renderToken: number;
    connected: boolean;
    themeObserver: MutationObserver | null;
    boundBeforeCache: () => void;
    connect(): void;
    disconnect(): void;
    typeValueChanged(): void;
    dataValueChanged(): void;
    configValueChanged(): void;
    renderChart(): Promise<void>;
    destroyChart(): void;
    invalidateRender(): void;
    renderTooltip(context: {
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
    }): void;
    renderLegend(items: LegendItem[]): void;
    showMessage(message: string): void;
    clearMessage(): void;
    renderWhenConnected(): void;
    colorSwatch(color: string): HTMLSpanElement;
    textNode(text: string, className?: string): HTMLSpanElement;
}
export {};
//# sourceMappingURL=chart_controller.d.ts.map