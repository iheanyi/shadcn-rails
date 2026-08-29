import { Controller } from "@hotwired/stimulus";
/**
 * Tabs controller for tabbed interfaces
 * Handles tab selection, keyboard navigation, content switching, and URL sync
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        defaultValue: StringConstructor;
        urlParam: StringConstructor;
    };
    connect(): void;
    disconnect(): void;
    handlePopState(): void;
    getValueFromUrl(): string | null;
    updateUrl(value: string): void;
    selectTab(event: ShadcnEvent): void;
    selectTabByValue(value: string, updateUrl?: boolean): void;
    handleKeydown(event: ShadcnEvent): void;
}
//# sourceMappingURL=tabs_controller.d.ts.map