const DEFAULT_SERIES_COUNT = 5;
export function normalizeChartType(type) {
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
export function cssVariableName(key) {
    const normalized = key
        .trim()
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
    return normalized || "series";
}
export function defaultChartColor(index) {
    return `hsl(var(--chart-${(index % DEFAULT_SERIES_COUNT) + 1}))`;
}
export function resolveCssColor(element, value) {
    const trimmed = value.trim();
    const variableMatch = trimmed.match(/^var\((--[^)]+)\)$/);
    if (!variableMatch)
        return trimmed;
    const resolved = getComputedStyle(element).getPropertyValue(variableMatch[1]).trim();
    return resolved || trimmed;
}
export function seriesKey(dataset, index) {
    if (typeof dataset.key === "string" && dataset.key.length > 0)
        return dataset.key;
    if (typeof dataset.label === "string" && dataset.label.length > 0)
        return dataset.label;
    return `series-${index + 1}`;
}
export function seriesLabel(dataset, config, index) {
    const key = seriesKey(dataset, index);
    return config[key]?.label || dataset.label || key;
}
export function seriesColor(element, dataset, config, index) {
    const key = seriesKey(dataset, index);
    const cssVariable = `var(--color-${cssVariableName(key)})`;
    const configured = config[key]?.color || cssVariable;
    const resolved = resolveCssColor(element, configured);
    return resolved === cssVariable ? defaultChartColor(index) : resolved;
}
export function buildLegendItems(element, type, data, config) {
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
    return resolved === color && color.startsWith("var(") ? defaultChartColor(index) : resolved;
}
export function buildChartData(element, type, data, config) {
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
                        ? defaultChartColor(labelIndex)
                        : resolved;
                });
                return {
                    ...dataset,
                    label,
                    backgroundColor: colors.length > 0 ? colors : color,
                    borderColor: "hsl(var(--background))"
                };
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
            };
        })
    };
}
export function buildChartOptions({ renderTooltip }) {
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
    };
}
//# sourceMappingURL=chart_config.js.map