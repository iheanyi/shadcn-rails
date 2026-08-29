import { Controller } from "@hotwired/stimulus";
/**
 * Carousel controller for sliding content
 * Handles navigation, autoplay, keyboard navigation, and touch/swipe
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        orientation: {
            type: StringConstructor;
            default: string;
        };
        loop: {
            type: BooleanConstructor;
            default: boolean;
        };
        autoplay: {
            type: BooleanConstructor;
            default: boolean;
        };
        autoplayInterval: {
            type: NumberConstructor;
            default: number;
        };
        align: {
            type: StringConstructor;
            default: string;
        };
        selectedIndex: {
            type: NumberConstructor;
            default: number;
        };
    };
    connect(): void;
    disconnect(): void;
    previous(): void;
    next(): void;
    goToSlide(event: ShadcnEvent): void;
    scrollToIndex(index: number, animate?: boolean): void;
    getAlignOffset(item: HTMLElement, dimension: "width" | "height"): number;
    updateButtonStates(): void;
    handleKeydown(event: ShadcnEvent): void;
    handleTouchStart(event: ShadcnEvent): void;
    handleTouchEnd(event: ShadcnEvent): void;
    startAutoplay(): void;
    stopAutoplay(): void;
    mouseEnter(): void;
    mouseLeave(): void;
    selectedIndexValueChanged(): void;
}
//# sourceMappingURL=carousel_controller.d.ts.map