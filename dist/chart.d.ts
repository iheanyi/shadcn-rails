import type { Application } from "@hotwired/stimulus";
import ChartController from "./controllers/chart_controller";
export { ChartController };
/**
 * Register the optional Chart controller with a Stimulus application.
 *
 * Chart.js remains an optional peer dependency because the base controller
 * bundle does not import this entrypoint.
 */
export declare function registerShadcnChartController(application: Application): void;
declare const _default: {
    ChartController: typeof ChartController;
    registerShadcnChartController: typeof registerShadcnChartController;
};
export default _default;
//# sourceMappingURL=chart.d.ts.map