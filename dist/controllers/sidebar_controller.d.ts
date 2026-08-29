import { Controller } from "@hotwired/stimulus";
/**
 * Sidebar Controller
 * Uses stimulus-use useMatchMedia for responsive behavior
 */
export default class extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        openMobile: {
            type: BooleanConstructor;
            default: boolean;
        };
        keyboardShortcut: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    disconnect(): void;
    mobileChanged({ matches }: MediaQueryListEvent): void;
    handleKeyDown(event: ShadcnEvent): void;
    toggle(): void;
    setOpen(open: boolean): void;
    openValueChanged(): void;
    openMobileValueChanged(): void;
    syncState(): void;
    getCookie(name: string): string | null;
    setCookie(name: string, value: string, maxAge: number): void;
    open(): void;
    close(): void;
    clickOutside(event: ShadcnEvent): void;
}
//# sourceMappingURL=sidebar_controller.d.ts.map