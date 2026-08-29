import { Controller } from "@hotwired/stimulus";
/**
 * Resizable Panel Controller
 * Handles resizable panel layouts with keyboard and mouse support
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        direction: {
            type: StringConstructor;
            default: string;
        };
        autoSaveId: StringConstructor;
    };
    connect(): void;
    disconnect(): void;
    startResize(event: ShadcnEvent): void;
    resize(event: ShadcnEvent): void;
    stopResize(): void;
    handleKeydown(event: ShadcnEvent): void;
    findAdjacentPanels(): void;
    storePanelSizes(): void;
    getPanelSize(panel: HTMLElement): number;
    setPanelSize(panel: HTMLElement, percent: number): void;
    collapsePanel(which: string): void;
    saveSizes(): void;
    loadSavedSizes(): void;
    get isHorizontal(): boolean;
}
//# sourceMappingURL=resizable_controller.d.ts.map