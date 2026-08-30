'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var stimulus = require('@hotwired/stimulus');

const DEFAULT_SERIES_COUNT = 5;
function normalizeChartType(type) {
    switch (type) {
        case "bar":
            return "bar";
        case "line":
        case "area":
            return "line";
        case "pie":
            return "pie";
        case "donut":
            return "doughnut";
        default:
            return "bar";
    }
}
function cssVariableName(key) {
    const normalized = key
        .trim()
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
    return normalized || "series";
}
function defaultChartColor(element, index) {
    return resolveCssColor(element, `hsl(var(--chart-${(index % DEFAULT_SERIES_COUNT) + 1}))`);
}
function resolveCssColor(element, value) {
    const trimmed = value.trim();
    const hslVariableMatch = trimmed.match(/^hsla?\(\s*var\((--[^)]+)\)\s*(?:\/\s*([^)]+))?\)$/);
    if (hslVariableMatch) {
        const resolved = resolveCssVariable(element, hslVariableMatch[1]);
        if (!resolved)
            return trimmed;
        return cssColorValue(resolved, hslVariableMatch[2]);
    }
    const variableMatch = trimmed.match(/^var\((--[^)]+)\)$/);
    if (variableMatch) {
        const resolved = resolveCssVariable(element, variableMatch[1]);
        return resolved ? cssColorValue(resolved) : trimmed;
    }
    return trimmed;
}
function seriesKey(dataset, index) {
    if (typeof dataset.key === "string" && dataset.key.length > 0)
        return dataset.key;
    if (typeof dataset.label === "string" && dataset.label.length > 0)
        return dataset.label;
    return `series-${index + 1}`;
}
function seriesLabel(dataset, config, index) {
    const key = seriesKey(dataset, index);
    return config[key]?.label || dataset.label || key;
}
function seriesColor(element, dataset, config, index) {
    const key = seriesKey(dataset, index);
    const cssVariable = `var(--color-${cssVariableName(key)})`;
    const configured = config[key]?.color || cssVariable;
    const resolved = resolveCssColor(element, configured);
    return resolved === cssVariable ? defaultChartColor(element, index) : resolved;
}
function buildLegendItems(element, type, data, config) {
    if (type === "pie" || type === "donut") {
        return (data.labels || []).map((label, index) => ({
            label: config[label]?.label || label,
            color: resolveLegendColor(element, config[label]?.color || `var(--color-${cssVariableName(label)})`, index),
            datasetIndex: 0,
            dataIndex: index
        }));
    }
    return (data.datasets || []).map((dataset, index) => ({
        label: seriesLabel(dataset, config, index),
        color: seriesColor(element, dataset, config, index),
        datasetIndex: index
    }));
}
function resolveLegendColor(element, color, index) {
    const resolved = resolveCssColor(element, color);
    return resolved === color && color.startsWith("var(") ? defaultChartColor(element, index) : resolved;
}
function buildChartData(element, type, data, config) {
    const isCircular = type === "pie" || type === "donut";
    return {
        ...data,
        datasets: (data.datasets || []).map((dataset, index) => {
            const color = seriesColor(element, dataset, config, index);
            const label = seriesLabel(dataset, config, index);
            if (isCircular) {
                const labels = data.labels || [];
                const colors = labels.map((labelKey, labelIndex) => {
                    const labelConfig = config[labelKey];
                    const configured = labelConfig?.color || `var(--color-${cssVariableName(labelKey)})`;
                    const resolved = resolveCssColor(element, configured);
                    return resolved === configured && configured.startsWith("var(")
                        ? defaultChartColor(element, labelIndex)
                        : resolved;
                });
                return {
                    ...dataset,
                    label,
                    backgroundColor: colors.length > 0 ? colors : color,
                    borderColor: resolveCssColor(element, "hsl(var(--background))")
                };
            }
            return {
                ...dataset,
                label,
                borderColor: color,
                backgroundColor: type === "area" ? translucentColor(color) : dataset.backgroundColor || color,
                pointBackgroundColor: color,
                pointBorderColor: color,
                fill: type === "area" ? true : dataset.fill,
                tension: typeof dataset.tension === "number" ? dataset.tension : 0.4
            };
        })
    };
}
function buildChartOptions({ element, type, renderTooltip }) {
    const options = {
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
        animation: {}
    };
    if (type === "pie" || type === "donut")
        return options;
    options.scales = {
        x: {
            border: {
                display: false
            },
            grid: {
                display: false
            },
            ticks: {
                color: resolveCssColor(element, "hsl(var(--muted-foreground))")
            }
        },
        y: {
            border: {
                display: false
            },
            grid: {
                color: resolveCssColor(element, "hsl(var(--border))")
            },
            ticks: {
                color: resolveCssColor(element, "hsl(var(--muted-foreground))")
            }
        }
    };
    return options;
}
function resolveCssVariable(element, name) {
    return getComputedStyle(element).getPropertyValue(name).trim();
}
function cssColorValue(value, alpha) {
    const trimmed = value.trim();
    if (isHslComponentToken(trimmed)) {
        return alpha ? `hsl(${trimmed} / ${alpha.trim()})` : `hsl(${trimmed})`;
    }
    return trimmed;
}
function isHslComponentToken(value) {
    return /^-?\d+(?:\.\d+)?(?:deg|rad|turn)?\s+-?\d+(?:\.\d+)?%\s+-?\d+(?:\.\d+)?%$/.test(value);
}
function translucentColor(color) {
    const hslMatch = color.match(/^hsl\(\s*(.+?)(?:\s*\/\s*[\d.]+%?)?\s*\)$/);
    if (!hslMatch)
        return color;
    return `hsl(${hslMatch[1].trim()} / 0.25)`;
}

const loadChartJs = () => import('chart.js/auto');
const INSTALL_MESSAGE = "Chart.js is required for Shadcn::ChartComponent. Install and pin it with: npm install chart.js@^4.5.1";
class default_1 extends stimulus.Controller {
    constructor() {
        super(...arguments);
        this.chart = null;
        this.renderToken = 0;
        this.connected = false;
        this.themeObserver = null;
        this.boundBeforeCache = () => this.invalidateRender();
    }
    static { this.targets = ["canvas", "tooltip", "legend"]; }
    static { this.values = {
        type: String,
        data: Object,
        config: Object
    }; }
    connect() {
        this.connected = true;
        document.addEventListener("turbo:before-cache", this.boundBeforeCache);
        this.themeObserver = new MutationObserver(() => this.renderChart());
        this.themeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ["class"]
        });
        this.renderChart();
    }
    disconnect() {
        this.connected = false;
        document.removeEventListener("turbo:before-cache", this.boundBeforeCache);
        this.themeObserver?.disconnect();
        this.themeObserver = null;
        this.invalidateRender();
    }
    typeValueChanged() {
        this.renderWhenConnected();
    }
    dataValueChanged() {
        this.renderWhenConnected();
    }
    configValueChanged() {
        this.renderWhenConnected();
    }
    async renderChart() {
        if (!this.connected)
            return;
        const token = this.renderToken + 1;
        this.renderToken = token;
        this.destroyChart();
        this.clearMessage();
        try {
            const chartJs = await loadChartJs();
            if (token !== this.renderToken || !this.connected || !this.element.isConnected)
                return;
            const context = this.canvasTarget.getContext("2d");
            if (!context) {
                this.showMessage("Chart canvas is not available in this browser.");
                return;
            }
            const chartData = buildChartData(this.element, this.typeValue, this.dataValue, this.configValue);
            const options = buildChartOptions({
                element: this.element,
                type: this.typeValue,
                renderTooltip: this.renderTooltip.bind(this)
            });
            this.chart = new chartJs.default(context, {
                type: normalizeChartType(this.typeValue),
                data: chartData,
                options
            });
            this.renderLegend(buildLegendItems(this.element, this.typeValue, chartData, this.configValue));
        }
        catch (error) {
            this.showMessage(missingChartJsError(error) ? INSTALL_MESSAGE : "Unable to render chart.");
        }
    }
    destroyChart() {
        if (!this.chart)
            return;
        this.chart.destroy();
        this.chart = null;
    }
    invalidateRender() {
        this.renderToken += 1;
        this.destroyChart();
        this.clearMessage();
    }
    renderTooltip(context) {
        const { tooltip } = context;
        if (tooltip.opacity === 0) {
            this.tooltipTarget.classList.add("hidden");
            return;
        }
        const title = tooltip.title || [];
        const rows = (tooltip.body || []).flatMap((body, index) => {
            const color = tooltip.labelColors?.[index]?.backgroundColor || tooltip.labelColors?.[index]?.borderColor || "hsl(var(--border))";
            return body.lines.map((line) => ({ line, color }));
        });
        const titleNodes = title.map((line) => {
            const titleNode = document.createElement("div");
            titleNode.className = "mb-1 font-medium text-foreground";
            titleNode.textContent = line;
            return titleNode;
        });
        const rowNodes = rows.map((row) => {
            const rowNode = document.createElement("div");
            rowNode.className = "flex items-center gap-2";
            rowNode.append(this.colorSwatch(row.color), this.textNode(row.line, "text-muted-foreground"));
            return rowNode;
        });
        this.tooltipTarget.replaceChildren(...titleNodes, ...rowNodes);
        this.tooltipTarget.style.left = `${tooltip.caretX}px`;
        this.tooltipTarget.style.top = `${tooltip.caretY}px`;
        this.tooltipTarget.classList.remove("hidden");
    }
    renderLegend(items) {
        if (items.length === 0) {
            this.legendTarget.innerHTML = "";
            return;
        }
        const nodes = items.map((item) => {
            const itemNode = document.createElement("div");
            itemNode.className = "flex items-center gap-2";
            itemNode.append(this.colorSwatch(item.color), this.textNode(item.label));
            return itemNode;
        });
        this.legendTarget.replaceChildren(...nodes);
    }
    showMessage(message) {
        const messageNode = document.createElement("p");
        messageNode.className = "text-sm text-muted-foreground";
        messageNode.textContent = message;
        this.legendTarget.replaceChildren(messageNode);
    }
    clearMessage() {
        this.tooltipTarget.classList.add("hidden");
        this.tooltipTarget.replaceChildren();
        this.legendTarget.replaceChildren();
    }
    renderWhenConnected() {
        if (this.connected)
            this.renderChart();
    }
    colorSwatch(color) {
        const swatch = document.createElement("span");
        swatch.className = "h-2.5 w-2.5 shrink-0 rounded-[2px]";
        swatch.style.backgroundColor = color;
        return swatch;
    }
    textNode(text, className) {
        const span = document.createElement("span");
        if (className)
            span.className = className;
        span.textContent = text;
        return span;
    }
}
function missingChartJsError(error) {
    if (!(error instanceof Error))
        return true;
    return error.message.includes("chart.js") || error.message.includes("Failed to resolve module");
}

/**
 * Register the optional Chart controller with a Stimulus application.
 *
 * Chart.js remains an optional peer dependency because the base controller
 * bundle does not import this entrypoint.
 */
function registerShadcnChartController(application) {
    application.register("shadcn--chart", default_1);
}
var chart = { ChartController: default_1, registerShadcnChartController };

exports.ChartController = default_1;
exports.default = chart;
exports.registerShadcnChartController = registerShadcnChartController;
//# sourceMappingURL=chart.js.map
