import { Controller } from "@hotwired/stimulus";
const TOAST_BASE_CLASSES = [
    "shadcn-sonner-toast",
    "group",
    "pointer-events-auto",
    "relative",
    "flex",
    "w-full",
    "items-start",
    "justify-between",
    "gap-3",
    "overflow-hidden",
    "rounded-md",
    "border",
    "p-4",
    "pr-8",
    "shadow-lg"
].join(" ");
const TOAST_VARIANT_CLASSES = {
    default: "border bg-background text-foreground",
    success: "border-green-500/40 bg-background text-foreground",
    destructive: "destructive border-destructive bg-destructive text-destructive-foreground",
    warning: "border-yellow-500/40 bg-background text-foreground",
    info: "border-blue-500/40 bg-background text-foreground"
};
const TOAST_ACTION_BUTTON_CLASSES = "inline-flex h-8 shrink-0 items-center justify-center rounded-md border border-input bg-background px-3 text-xs font-medium text-foreground hover:bg-accent hover:text-accent-foreground";
const TOAST_ACTIONS = [
    "mouseenter->shadcn--sonner#pause",
    "mouseleave->shadcn--sonner#resume",
    "pointerdown->shadcn--sonner#startSwipe",
    "pointermove->shadcn--sonner#moveSwipe",
    "pointerup->shadcn--sonner#endSwipe",
    "pointercancel->shadcn--sonner#cancelSwipe"
].join(" ");
const TOAST_REMOVE_DELAY = 400;
const TOAST_SWIPE_REMOVE_DELAY = 200;
const controllers = new Set();
const pendingToasts = [];
let idSequence = 0;
function nextToastId() {
    idSequence += 1;
    return `sonner-${Date.now()}-${idSequence}`;
}
function normalizeToast(input, options = {}) {
    if (typeof input === "string") {
        return { ...options, title: input };
    }
    return { ...input, ...options };
}
function normalizeVariant(value) {
    switch (value) {
        case "default":
        case "success":
        case "destructive":
        case "warning":
        case "info":
            return value;
        default:
            return "default";
    }
}
function normalizeDuration(value, fallback) {
    if (typeof value === "number" && Number.isFinite(value)) {
        return Math.max(0, value);
    }
    if (typeof value === "string") {
        const parsed = Number.parseInt(value, 10);
        return Number.isFinite(parsed) ? Math.max(0, parsed) : fallback;
    }
    return fallback;
}
function findController(position) {
    const activeControllers = connectedControllers();
    if (position) {
        const positionedController = activeControllers.find((controller) => controller.positionValue === position);
        if (positionedController)
            return positionedController;
    }
    return activeControllers[0];
}
function connectedControllers() {
    return Array.from(controllers).filter((controller) => {
        const isConnected = controller.element.isConnected;
        if (!isConnected)
            controllers.delete(controller);
        return isConnected;
    });
}
function createToast(input, options = {}) {
    const toastOptions = normalizeToast(input, options);
    const id = String(toastOptions.id ?? nextToastId());
    const controller = findController(toastOptions.position);
    if (!controller) {
        pendingToasts.push({ ...toastOptions, id });
        return id;
    }
    controller.show({ ...toastOptions, id });
    return id;
}
function dismissToast(id) {
    removePendingToasts(id);
    connectedControllers().forEach((controller) => controller.dismiss(id));
}
function removePendingToasts(id) {
    if (id === undefined) {
        pendingToasts.splice(0, pendingToasts.length);
        return;
    }
    const idString = String(id);
    for (let index = pendingToasts.length - 1; index >= 0; index -= 1) {
        if (String(pendingToasts[index].id) === idString) {
            pendingToasts.splice(index, 1);
        }
    }
}
export const toast = Object.assign(createToast, { dismiss: dismissToast });
export const dismiss = dismissToast;
window.shadcnRails = { ...(window.shadcnRails ?? {}), toast, dismiss };
export default class SonnerController extends Controller {
    constructor() {
        super(...arguments);
        this.observer = null;
        this.timers = new Map();
        this.removeTimeouts = new Map();
        this.actionHandlers = new Map();
        this.activePointerId = null;
        this.swipeToast = null;
        this.swipeStartX = 0;
        this.swipeDeltaX = 0;
    }
    static { this.targets = ["viewport"]; }
    static { this.values = {
        duration: { type: Number, default: 4000 },
        limit: { type: Number, default: 3 },
        position: { type: String, default: "bottom-right" },
        swipeThreshold: { type: Number, default: 48 }
    }; }
    connect() {
        controllers.add(this);
        this.observeTurboAppends();
        this.initializeExistingToasts();
        this.flushPendingToasts();
    }
    disconnect() {
        controllers.delete(this);
        this.observer?.disconnect();
        this.observer = null;
        this.resetSwipeState();
    }
    show(options) {
        const id = String(options.id ?? nextToastId());
        const existingToast = this.findToastElement(id, { includeClosed: true });
        if (existingToast) {
            this.reopenToast(existingToast);
            this.updateToastElement(existingToast, options);
            this.placeToastAtOrigin(existingToast);
            this.startTimer(existingToast, normalizeDuration(options.duration, this.durationValue));
            return id;
        }
        const element = this.buildToastElement({ ...options, id });
        this.viewportTarget.prepend(element);
        this.initializeToastElement(element);
        this.enforceLimit();
        return id;
    }
    dismiss(id) {
        if (id === undefined) {
            removePendingToasts();
            this.toastElements().forEach((toastElement) => this.closeToast(toastElement));
            return;
        }
        removePendingToasts(id);
        const toastElement = this.findToastElement(String(id), { includeClosed: true });
        if (toastElement) {
            this.closeToast(toastElement);
        }
    }
    demo(event) {
        const trigger = event.currentTarget;
        if (!(trigger instanceof HTMLElement))
            return;
        this.show({
            title: trigger.dataset.title,
            description: trigger.dataset.description,
            variant: normalizeVariant(trigger.dataset.variant),
            duration: normalizeDuration(trigger.dataset.duration, this.durationValue),
            action: this.demoAction(trigger)
        });
    }
    pause(event) {
        const toastElement = this.eventToastElement(event);
        if (!toastElement)
            return;
        const timer = this.timerFor(toastElement);
        if (!timer || timer.timeoutId === null)
            return;
        window.clearTimeout(timer.timeoutId);
        timer.timeoutId = null;
        timer.remaining = Math.max(0, timer.remaining - (Date.now() - timer.startedAt));
    }
    resume(event) {
        const toastElement = this.eventToastElement(event);
        if (!toastElement)
            return;
        const timer = this.timerFor(toastElement);
        if (!timer || timer.timeoutId !== null || timer.duration === 0)
            return;
        timer.startedAt = Date.now();
        timer.timeoutId = window.setTimeout(() => this.closeToast(toastElement), timer.remaining);
    }
    close(event) {
        const toastElement = this.eventToastElement(event);
        if (toastElement) {
            this.closeToast(toastElement);
        }
    }
    startSwipe(event) {
        if (this.isInteractiveEventTarget(event))
            return;
        const toastElement = this.eventToastElement(event);
        if (!toastElement)
            return;
        this.activePointerId = event.pointerId;
        this.swipeToast = toastElement;
        this.swipeStartX = event.clientX;
        this.swipeDeltaX = 0;
        toastElement.dataset.swipe = "start";
        toastElement.setPointerCapture(event.pointerId);
        this.pause(event);
    }
    moveSwipe(event) {
        if (this.activePointerId !== event.pointerId || !this.swipeToast)
            return;
        this.swipeDeltaX = event.clientX - this.swipeStartX;
        this.swipeToast.dataset.swipe = "move";
        this.swipeToast.style.transform = `translateX(${this.swipeDeltaX}px)`;
    }
    endSwipe(event) {
        if (this.activePointerId !== event.pointerId || !this.swipeToast)
            return;
        const toastElement = this.swipeToast;
        const shouldDismiss = Math.abs(this.swipeDeltaX) >= this.swipeThresholdValue;
        toastElement.releasePointerCapture(event.pointerId);
        this.resetSwipeState();
        if (shouldDismiss) {
            toastElement.dataset.swipe = "end";
            this.closeToast(toastElement);
        }
        else {
            toastElement.dataset.swipe = "cancel";
            toastElement.style.transform = "";
            this.resume(event);
        }
    }
    cancelSwipe(event) {
        if (this.activePointerId !== event.pointerId || !this.swipeToast)
            return;
        const toastElement = this.swipeToast;
        toastElement.releasePointerCapture(event.pointerId);
        toastElement.dataset.swipe = "cancel";
        toastElement.style.transform = "";
        this.resetSwipeState();
        this.resume(event);
    }
    flushPendingToasts() {
        const remaining = [];
        pendingToasts.forEach((toastOptions) => {
            if (toastOptions.position && toastOptions.position !== this.positionValue) {
                remaining.push(toastOptions);
                return;
            }
            this.show(toastOptions);
        });
        pendingToasts.splice(0, pendingToasts.length, ...remaining);
    }
    observeTurboAppends() {
        if (!this.hasViewportTarget)
            return;
        this.observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                mutation.addedNodes.forEach((node) => {
                    if (node instanceof HTMLElement) {
                        this.initializeToastTree(node);
                    }
                });
            });
            this.enforceLimit();
        });
        this.observer.observe(this.viewportTarget, { childList: true });
    }
    initializeExistingToasts() {
        this.toastElements().forEach((toastElement) => this.initializeToastElement(toastElement));
        this.enforceLimit();
    }
    initializeToastTree(node) {
        if (this.isToastElement(node)) {
            this.initializeToastElement(node);
        }
        node.querySelectorAll("[data-shadcn-sonner-toast-id], [data-sonner-toast]").forEach((toastElement) => {
            this.initializeToastElement(toastElement);
        });
    }
    initializeToastElement(toastElement) {
        if (toastElement.dataset.shadcnSonnerBound === "true")
            return;
        const id = this.ensureToastId(toastElement);
        const duration = normalizeDuration(toastElement.dataset.duration, this.durationValue);
        const variant = normalizeVariant(toastElement.dataset.variant);
        toastElement.dataset.shadcnSonnerBound = "true";
        toastElement.dataset.state = "open";
        toastElement.dataset.mounted = "false";
        toastElement.dataset.position = this.positionValue;
        toastElement.dataset.variant = variant;
        toastElement.setAttribute("role", toastElement.getAttribute("role") || "status");
        toastElement.setAttribute("aria-live", toastElement.getAttribute("aria-live") || "polite");
        toastElement.setAttribute("data-action", this.toastActions(toastElement.getAttribute("data-action")));
        toastElement.className = this.toastClassName(variant, toastElement.className);
        this.placeToastAtOrigin(toastElement);
        this.ensureCloseButton(toastElement);
        this.mountToast(toastElement);
        this.startTimer(toastElement, duration);
        this.dispatch("show", { detail: { id } });
    }
    buildToastElement(options) {
        const toastElement = document.createElement("li");
        const id = String(options.id ?? nextToastId());
        const variant = normalizeVariant(options.variant);
        toastElement.dataset.shadcnSonnerToastId = id;
        toastElement.dataset.sonnerToast = "true";
        toastElement.dataset.variant = variant;
        toastElement.dataset.position = this.positionValue;
        toastElement.dataset.duration = String(normalizeDuration(options.duration, this.durationValue));
        toastElement.className = this.toastClassName(variant);
        toastElement.setAttribute("role", "status");
        toastElement.setAttribute("aria-live", "polite");
        toastElement.setAttribute("data-action", TOAST_ACTIONS);
        const bodyElement = document.createElement("div");
        bodyElement.className = "grid gap-1";
        bodyElement.dataset.sonnerBody = "true";
        if (options.title) {
            const titleElement = document.createElement("div");
            titleElement.className = "text-sm font-semibold leading-none tracking-tight";
            titleElement.textContent = options.title;
            bodyElement.appendChild(titleElement);
        }
        if (options.description) {
            const descriptionElement = document.createElement("div");
            descriptionElement.className = "text-sm opacity-90";
            descriptionElement.textContent = options.description;
            bodyElement.appendChild(descriptionElement);
        }
        toastElement.appendChild(bodyElement);
        const action = this.normalizeAction(options.action);
        if (action) {
            toastElement.appendChild(this.buildActionButton(toastElement, id, action));
        }
        toastElement.appendChild(this.buildCloseButton());
        return toastElement;
    }
    updateToastElement(toastElement, options) {
        const variant = normalizeVariant(options.variant ?? toastElement.dataset.variant);
        toastElement.dataset.variant = variant;
        toastElement.dataset.position = this.positionValue;
        toastElement.className = this.toastClassName(variant);
        const id = this.ensureToastId(toastElement);
        const bodyElement = this.ensureBodyElement(toastElement);
        bodyElement.textContent = "";
        bodyElement.className = "grid gap-1";
        bodyElement.dataset.sonnerBody = "true";
        if (options.title) {
            const titleElement = document.createElement("div");
            titleElement.className = "text-sm font-semibold leading-none tracking-tight";
            titleElement.textContent = options.title;
            bodyElement.appendChild(titleElement);
        }
        if (options.description) {
            const descriptionElement = document.createElement("div");
            descriptionElement.className = "text-sm opacity-90";
            descriptionElement.textContent = options.description;
            bodyElement.appendChild(descriptionElement);
        }
        this.syncActionButton(toastElement, id, options.action);
        this.ensureCloseButton(toastElement);
    }
    normalizeAction(action) {
        if (!action)
            return null;
        if (typeof action === "string")
            return { label: action };
        return action;
    }
    demoAction(trigger) {
        const label = trigger.dataset.actionLabel;
        if (!label)
            return undefined;
        return {
            label,
            onClick: () => {
                const title = trigger.dataset.actionTitle;
                if (!title)
                    return;
                this.show({
                    title,
                    description: trigger.dataset.actionDescription,
                    variant: normalizeVariant(trigger.dataset.actionVariant),
                    duration: normalizeDuration(trigger.dataset.actionDuration, this.durationValue)
                });
            }
        };
    }
    toastClassName(variant, currentClassName = "") {
        const classNames = new Set([TOAST_BASE_CLASSES, TOAST_VARIANT_CLASSES[variant], currentClassName]
            .join(" ")
            .split(/\s+/)
            .filter(Boolean));
        return Array.from(classNames).join(" ");
    }
    ensureCloseButton(toastElement) {
        if (toastElement.querySelector("[data-sonner-close]"))
            return;
        toastElement.appendChild(this.buildCloseButton());
    }
    ensureBodyElement(toastElement) {
        const existingBody = toastElement.querySelector("[data-sonner-body]");
        if (existingBody)
            return existingBody;
        const bodyElement = document.createElement("div");
        bodyElement.className = "grid gap-1";
        bodyElement.dataset.sonnerBody = "true";
        const firstControl = toastElement.querySelector("[data-sonner-action], [data-sonner-close]");
        if (firstControl) {
            toastElement.insertBefore(bodyElement, firstControl);
        }
        else {
            toastElement.prepend(bodyElement);
        }
        return bodyElement;
    }
    syncActionButton(toastElement, id, actionOption) {
        const existingAction = toastElement.querySelector("[data-sonner-action]");
        const action = this.normalizeAction(actionOption);
        existingAction?.remove();
        if (!action) {
            this.actionHandlers.delete(id);
            return;
        }
        const actionButton = this.buildActionButton(toastElement, id, action);
        const closeButton = toastElement.querySelector("[data-sonner-close]");
        if (closeButton) {
            toastElement.insertBefore(actionButton, closeButton);
        }
        else {
            toastElement.appendChild(actionButton);
        }
    }
    buildActionButton(toastElement, id, action) {
        const button = document.createElement("button");
        button.type = "button";
        button.className = TOAST_ACTION_BUTTON_CLASSES;
        button.textContent = action.label;
        button.dataset.sonnerAction = "true";
        button.addEventListener("click", (event) => {
            const handler = this.actionHandlers.get(id);
            handler?.(event);
            this.closeToast(toastElement);
        });
        if (action.onClick) {
            this.actionHandlers.set(id, action.onClick);
        }
        else {
            this.actionHandlers.delete(id);
        }
        return button;
    }
    buildCloseButton() {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-1 focus:ring-ring group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50";
        button.setAttribute("aria-label", "Dismiss notification");
        button.setAttribute("data-sonner-close", "true");
        button.setAttribute("data-action", "click->shadcn--sonner#close");
        button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" class="h-4 w-4"><path d="M18 6 6 18M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>';
        return button;
    }
    closeToast(toastElement) {
        const id = this.ensureToastId(toastElement);
        if (toastElement.dataset.state === "closed")
            return;
        const timer = this.timers.get(id);
        if (timer)
            this.clearTimer(timer);
        this.timers.delete(id);
        toastElement.dataset.state = "closed";
        toastElement.dataset.mounted = "false";
        toastElement.style.pointerEvents = "none";
        toastElement.style.removeProperty("opacity");
        toastElement.style.removeProperty("transform");
        toastElement.style.setProperty("--shadcn-toast-exit-transform", this.exitTransform());
        const removeTimeout = window.setTimeout(() => {
            toastElement.remove();
            this.removeTimeouts.delete(id);
            this.actionHandlers.delete(id);
            this.dispatch("dismiss", { detail: { id } });
        }, this.motionDuration(toastElement.dataset.swipe === "end" ? TOAST_SWIPE_REMOVE_DELAY : TOAST_REMOVE_DELAY));
        this.removeTimeouts.set(id, removeTimeout);
    }
    enforceLimit() {
        const toasts = this.toastElements();
        const limit = Math.max(1, this.limitValue);
        const overflowCount = toasts.length - limit;
        if (overflowCount <= 0)
            return;
        toasts.slice(limit).forEach((toastElement) => this.closeToast(toastElement));
    }
    startTimer(toastElement, duration) {
        const id = this.ensureToastId(toastElement);
        const existingTimer = this.timers.get(id);
        if (existingTimer)
            this.clearTimer(existingTimer);
        const timer = {
            timeoutId: null,
            duration,
            remaining: duration,
            startedAt: Date.now()
        };
        if (duration > 0) {
            timer.timeoutId = window.setTimeout(() => this.closeToast(toastElement), duration);
        }
        this.timers.set(id, timer);
    }
    clearTimer(timer) {
        if (timer.timeoutId !== null) {
            window.clearTimeout(timer.timeoutId);
            timer.timeoutId = null;
        }
    }
    timerFor(toastElement) {
        const id = toastElement.dataset.shadcnSonnerToastId;
        return id ? this.timers.get(id) : undefined;
    }
    toastElements() {
        return this.allToastElements().filter((toastElement) => toastElement.dataset.state !== "closed");
    }
    allToastElements() {
        if (!this.hasViewportTarget)
            return [];
        return Array.from(this.viewportTarget.children).filter((child) => {
            return child instanceof HTMLElement && this.isToastElement(child);
        });
    }
    findToastElement(id, options = {}) {
        const toasts = options.includeClosed ? this.allToastElements() : this.toastElements();
        return toasts.find((toastElement) => toastElement.dataset.shadcnSonnerToastId === id) ?? null;
    }
    ensureToastId(toastElement) {
        const existingId = toastElement.dataset.shadcnSonnerToastId;
        if (existingId)
            return existingId;
        const id = nextToastId();
        toastElement.dataset.shadcnSonnerToastId = id;
        return id;
    }
    isToastElement(element) {
        return element.dataset.sonnerToast === "true" || element.dataset.shadcnSonnerToastId !== undefined;
    }
    eventToastElement(event) {
        const target = event.currentTarget;
        if (target instanceof HTMLElement && this.isToastElement(target)) {
            return target;
        }
        if (target instanceof HTMLElement) {
            return target.closest("[data-shadcn-sonner-toast-id], [data-sonner-toast]");
        }
        return null;
    }
    isInteractiveEventTarget(event) {
        const target = event.target;
        if (!(target instanceof Element))
            return false;
        return target.closest("button, a, input, select, textarea, [role='button']") !== null;
    }
    toastActions(existingActions) {
        const actions = new Set(`${TOAST_ACTIONS} ${existingActions ?? ""}`.split(/\s+/).filter(Boolean));
        return Array.from(actions).join(" ");
    }
    placeToastAtOrigin(toastElement) {
        if (toastElement.parentElement !== this.viewportTarget || this.viewportTarget.firstElementChild === toastElement) {
            return;
        }
        this.viewportTarget.prepend(toastElement);
    }
    reopenToast(toastElement) {
        const id = this.ensureToastId(toastElement);
        const removeTimeout = this.removeTimeouts.get(id);
        if (removeTimeout !== undefined) {
            window.clearTimeout(removeTimeout);
            this.removeTimeouts.delete(id);
        }
        toastElement.dataset.state = "open";
        toastElement.dataset.mounted = "true";
        toastElement.style.pointerEvents = "";
        toastElement.style.removeProperty("opacity");
        toastElement.style.removeProperty("transform");
        toastElement.style.removeProperty("--shadcn-toast-exit-transform");
    }
    mountToast(toastElement) {
        if (this.prefersReducedMotion()) {
            toastElement.dataset.mounted = "true";
            return;
        }
        window.requestAnimationFrame(() => {
            if (toastElement.dataset.state === "open") {
                toastElement.dataset.mounted = "true";
            }
        });
    }
    exitTransform() {
        if (this.positionValue.includes("left"))
            return "translateX(-100%)";
        if (this.positionValue.includes("right"))
            return "translateX(100%)";
        if (this.positionValue.startsWith("top"))
            return "translateY(-100%)";
        return "translateY(100%)";
    }
    resetSwipeState() {
        this.activePointerId = null;
        this.swipeToast = null;
        this.swipeStartX = 0;
        this.swipeDeltaX = 0;
    }
    motionDuration(duration) {
        return this.prefersReducedMotion() ? 0 : duration;
    }
    prefersReducedMotion() {
        return window.matchMedia?.("(prefers-reduced-motion: reduce)").matches ?? false;
    }
}
//# sourceMappingURL=sonner_controller.js.map