import { Controller } from "@hotwired/stimulus";
/**
 * Menubar controller
 * Handles menu opening/closing, keyboard navigation, hover behavior
 * Uses stimulus-use for click outside detection
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        openIndex: {
            type: NumberConstructor;
            default: number;
        };
    };
    readonly menuTargets: HTMLElement[];
    connect(): void;
    disconnect(): void;
    toggle(event: ShadcnEvent): void;
    hoverOpen(event: ShadcnEvent): void;
    openMenu(index: number): void;
    closeAllMenus(): void;
    closeAll(): void;
    selectItem(event: ShadcnEvent): void;
    toggleCheckbox(event: ShadcnEvent): void;
    selectRadio(event: ShadcnEvent): void;
    openSub(event: ShadcnEvent): void;
    startCloseSubTimer(): void;
    cancelCloseSubTimer(): void;
    closeAllSubs(): void;
    clickOutside(event: ShadcnEvent): void;
    handleKeydown(event: ShadcnEvent): void;
    openNextMenu(): void;
    openPreviousMenu(): void;
    focusNextItem(): void;
    focusPreviousItem(): void;
    focusFirstItem(): void;
    focusLastItem(): void;
    selectFocusedItem(): void;
    get currentMenuItems(): HTMLElement[];
    positionContent(trigger: HTMLElement, content: HTMLElement): void;
    positionSubContent(trigger: HTMLElement, content: HTMLElement): void;
}
//# sourceMappingURL=menubar_controller.d.ts.map