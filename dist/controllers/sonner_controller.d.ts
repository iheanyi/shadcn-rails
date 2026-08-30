import { Controller } from "@hotwired/stimulus";
type ToastVariant = "default" | "success" | "destructive" | "warning" | "info";
type ToastPosition = "top-left" | "top-center" | "top-right" | "bottom-left" | "bottom-center" | "bottom-right";
type ToastId = string | number;
type ToastAction = {
    label: string;
    onClick?: (event: MouseEvent) => void;
};
type ToastOptions = {
    id?: ToastId;
    title?: string;
    description?: string;
    variant?: ToastVariant;
    duration?: number;
    action?: ToastAction | string;
    position?: ToastPosition;
};
type ToastInput = ToastOptions | string;
type ShadcnRailsSonnerGlobal = {
    toast: ToastFunction;
    dismiss: (id?: ToastId) => void;
};
type ToastFunction = {
    (input: ToastInput, options?: ToastOptions): string;
    dismiss: (id?: ToastId) => void;
};
declare function createToast(input: ToastInput, options?: ToastOptions): string;
declare function dismissToast(id?: ToastId): void;
export declare const toast: typeof createToast & {
    dismiss: typeof dismissToast;
};
export declare const dismiss: typeof dismissToast;
declare global {
    interface Window {
        shadcnRails?: ShadcnRailsSonnerGlobal;
    }
}
export default class SonnerController extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        duration: {
            type: NumberConstructor;
            default: number;
        };
        limit: {
            type: NumberConstructor;
            default: number;
        };
        position: {
            type: StringConstructor;
            default: string;
        };
        swipeThreshold: {
            type: NumberConstructor;
            default: number;
        };
    };
    readonly viewportTarget: HTMLOListElement;
    readonly hasViewportTarget: boolean;
    readonly durationValue: number;
    readonly limitValue: number;
    readonly positionValue: ToastPosition;
    readonly swipeThresholdValue: number;
    private observer;
    private timers;
    private actionHandlers;
    private activePointerId;
    private swipeToast;
    private swipeStartX;
    private swipeDeltaX;
    connect(): void;
    disconnect(): void;
    show(options: ToastOptions): string;
    dismiss(id?: ToastId): void;
    demo(event: Event): void;
    pause(event: Event): void;
    resume(event: Event): void;
    close(event: Event): void;
    startSwipe(event: PointerEvent): void;
    moveSwipe(event: PointerEvent): void;
    endSwipe(event: PointerEvent): void;
    cancelSwipe(event: PointerEvent): void;
    private flushPendingToasts;
    private observeTurboAppends;
    private initializeExistingToasts;
    private initializeToastTree;
    private initializeToastElement;
    private buildToastElement;
    private updateToastElement;
    private normalizeAction;
    private toastClassName;
    private ensureCloseButton;
    private buildCloseButton;
    private bindCloseButtons;
    private closeToast;
    private enforceLimit;
    private startTimer;
    private clearTimer;
    private timerFor;
    private toastElements;
    private findToastElement;
    private ensureToastId;
    private isToastElement;
    private eventToastElement;
    private isInteractiveEventTarget;
    private exitTransform;
    private resetSwipeState;
}
export {};
//# sourceMappingURL=sonner_controller.d.ts.map