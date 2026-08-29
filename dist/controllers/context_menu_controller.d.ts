import BaseMenuController from "./base_menu_controller";
/**
 * Context Menu controller for right-click menus
 * Extends BaseMenuController with Floating UI positioning at cursor location
 */
export default class extends BaseMenuController {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        hideDelay: {
            type: NumberConstructor;
            default: number;
        };
    };
    connect(): void;
    clickOutside(event: ShadcnEvent): void;
    show(event: ShadcnEvent): void;
    hide(): void;
    handleContextMenu(event: ShadcnEvent): void;
    shouldCloseOnClickOutside(event: ShadcnEvent): boolean;
    positionContent(): void;
}
//# sourceMappingURL=context_menu_controller.d.ts.map