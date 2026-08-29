import BaseMenuController from "./base_menu_controller";
/**
 * Dropdown controller for dropdown menus
 * Extends BaseMenuController with Floating UI positioning
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
        align: {
            type: StringConstructor;
            default: string;
        };
        side: {
            type: StringConstructor;
            default: string;
        };
    };
    connect(): void;
    disconnect(): void;
    cleanupPositioning(): void;
    get placement(): string;
    positionContent(): void;
    hideMenu(): void;
    toggleCheckbox(event: ShadcnEvent): void;
    selectRadio(event: ShadcnEvent): void;
}
//# sourceMappingURL=dropdown_controller.d.ts.map