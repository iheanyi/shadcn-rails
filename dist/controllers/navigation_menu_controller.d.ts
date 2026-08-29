import { Controller } from "@hotwired/stimulus";
/**
 * Navigation Menu Controller
 * Handles navigation menu interactions with dropdown content areas
 * Uses stimulus-use for click outside detection
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        openIndex: {
            type: NumberConstructor;
            default: number;
        };
        delayDuration: {
            type: NumberConstructor;
            default: number;
        };
        skipDelayDuration: {
            type: NumberConstructor;
            default: number;
        };
    };
    connect(): void;
    disconnect(): void;
    toggle(event: ShadcnEvent): void;
    hoverOpen(event: ShadcnEvent): void;
    hoverClose(event: ShadcnEvent): void;
    contentHover(): void;
    openItem(index: number): void;
    closeItem(index: number): void;
    closeAll(): void;
    clickOutside(event: ShadcnEvent): void;
    handleKeydown(event: ShadcnEvent): void;
    navigateToNextItem(): void;
    navigateToPreviousItem(): void;
    clearTimers(): void;
    positionViewport(item: HTMLElement): void;
}
//# sourceMappingURL=navigation_menu_controller.d.ts.map