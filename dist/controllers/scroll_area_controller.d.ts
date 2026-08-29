import { Controller } from "@hotwired/stimulus";
/**
 * Scroll Area controller for custom scrollbars
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        orientation: {
            type: StringConstructor;
            default: string;
        };
        type: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    disconnect(): void;
    handleScroll(): void;
    updateScrollbar(): void;
    showScrollbar(): void;
    hideScrollbar(): void;
}
//# sourceMappingURL=scroll_area_controller.d.ts.map