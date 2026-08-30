import { Controller } from "@hotwired/stimulus"

type ToastVariant = "default" | "success" | "destructive" | "warning" | "info"
type ToastPosition = "top-left" | "top-center" | "top-right" | "bottom-left" | "bottom-center" | "bottom-right"
type ToastId = string | number

type ToastAction = {
  label: string
  onClick?: (event: MouseEvent) => void
}

type ToastOptions = {
  id?: ToastId
  title?: string
  description?: string
  variant?: ToastVariant
  duration?: number
  action?: ToastAction | string
  position?: ToastPosition
}

type ToastInput = ToastOptions | string

type ToastTimer = {
  timeoutId: number | null
  duration: number
  remaining: number
  startedAt: number
}

type ShadcnRailsSonnerGlobal = {
  toast: ToastFunction
  dismiss: (id?: ToastId) => void
}

type ToastFunction = {
  (input: ToastInput, options?: ToastOptions): string
  dismiss: (id?: ToastId) => void
}

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
  "shadow-lg",
  "transition-all",
  "data-[state=open]:animate-in",
  "data-[state=closed]:animate-out",
  "data-[state=open]:fade-in-0",
  "data-[state=closed]:fade-out-0"
].join(" ")

const TOAST_VARIANT_CLASSES: Record<ToastVariant, string> = {
  default: "border bg-background text-foreground",
  success: "border-green-500/40 bg-background text-foreground",
  destructive: "destructive border-destructive bg-destructive text-destructive-foreground",
  warning: "border-yellow-500/40 bg-background text-foreground",
  info: "border-blue-500/40 bg-background text-foreground"
}

const controllers = new Set<SonnerController>()
const pendingToasts: ToastOptions[] = []

let idSequence = 0

function nextToastId(): string {
  idSequence += 1
  return `sonner-${Date.now()}-${idSequence}`
}

function normalizeToast(input: ToastInput, options: ToastOptions = {}): ToastOptions {
  if (typeof input === "string") {
    return { ...options, title: input }
  }

  return { ...input, ...options }
}

function normalizeVariant(value: string | undefined): ToastVariant {
  switch (value) {
    case "default":
    case "success":
    case "destructive":
    case "warning":
    case "info":
      return value
    default:
      return "default"
  }
}

function normalizeDuration(value: string | number | undefined, fallback: number): number {
  if (typeof value === "number" && Number.isFinite(value)) {
    return Math.max(0, value)
  }

  if (typeof value === "string") {
    const parsed = Number.parseInt(value, 10)
    return Number.isFinite(parsed) ? Math.max(0, parsed) : fallback
  }

  return fallback
}

function findController(position?: ToastPosition): SonnerController | undefined {
  if (position) {
    const positionedController = Array.from(controllers).find((controller) => controller.positionValue === position)
    if (positionedController) return positionedController
  }

  return controllers.values().next().value
}

function createToast(input: ToastInput, options: ToastOptions = {}): string {
  const toastOptions = normalizeToast(input, options)
  const id = String(toastOptions.id ?? nextToastId())
  const controller = findController(toastOptions.position)

  if (!controller) {
    pendingToasts.push({ ...toastOptions, id })
    return id
  }

  controller.show({ ...toastOptions, id })
  return id
}

function dismissToast(id?: ToastId): void {
  controllers.forEach((controller) => controller.dismiss(id))
}

export const toast = Object.assign(createToast, { dismiss: dismissToast }) satisfies ToastFunction
export const dismiss = dismissToast

declare global {
  interface Window {
    shadcnRails?: ShadcnRailsSonnerGlobal
  }
}

window.shadcnRails = { ...(window.shadcnRails ?? {}), toast, dismiss }

export default class SonnerController extends Controller<HTMLElement> {
  static targets = ["viewport"]

  static values = {
    duration: { type: Number, default: 4000 },
    limit: { type: Number, default: 3 },
    position: { type: String, default: "bottom-right" },
    swipeThreshold: { type: Number, default: 48 }
  }

  declare readonly viewportTarget: HTMLOListElement
  declare readonly hasViewportTarget: boolean
  declare readonly durationValue: number
  declare readonly limitValue: number
  declare readonly positionValue: ToastPosition
  declare readonly swipeThresholdValue: number

  private observer: MutationObserver | null = null
  private timers = new Map<string, ToastTimer>()
  private actionHandlers = new Map<string, (event: MouseEvent) => void>()
  private activePointerId: number | null = null
  private swipeToast: HTMLElement | null = null
  private swipeStartX = 0
  private swipeDeltaX = 0

  connect(): void {
    controllers.add(this)
    this.observeTurboAppends()
    this.initializeExistingToasts()
    this.flushPendingToasts()
  }

  disconnect(): void {
    controllers.delete(this)
    this.observer?.disconnect()
    this.observer = null
    this.timers.forEach((timer) => this.clearTimer(timer))
    this.timers.clear()
    this.actionHandlers.clear()
  }

  show(options: ToastOptions): string {
    const id = String(options.id ?? nextToastId())
    const existingToast = this.findToastElement(id)

    if (existingToast) {
      this.updateToastElement(existingToast, options)
      this.startTimer(existingToast, normalizeDuration(options.duration, this.durationValue))
      return id
    }

    const element = this.buildToastElement({ ...options, id })
    this.viewportTarget.appendChild(element)
    this.initializeToastElement(element)
    this.enforceLimit()

    return id
  }

  dismiss(id?: ToastId): void {
    if (id === undefined) {
      this.toastElements().forEach((toastElement) => this.closeToast(toastElement))
      return
    }

    const toastElement = this.findToastElement(String(id))
    if (toastElement) {
      this.closeToast(toastElement)
    }
  }

  demo(event: Event): void {
    const trigger = event.currentTarget
    if (!(trigger instanceof HTMLElement)) return

    this.show({
      title: trigger.dataset.title,
      description: trigger.dataset.description,
      variant: normalizeVariant(trigger.dataset.variant),
      duration: normalizeDuration(trigger.dataset.duration, this.durationValue)
    })
  }

  pause(event: Event): void {
    const toastElement = this.eventToastElement(event)
    if (!toastElement) return

    const timer = this.timerFor(toastElement)
    if (!timer || timer.timeoutId === null) return

    window.clearTimeout(timer.timeoutId)
    timer.timeoutId = null
    timer.remaining = Math.max(0, timer.remaining - (Date.now() - timer.startedAt))
  }

  resume(event: Event): void {
    const toastElement = this.eventToastElement(event)
    if (!toastElement) return

    const timer = this.timerFor(toastElement)
    if (!timer || timer.timeoutId !== null || timer.duration === 0) return

    timer.startedAt = Date.now()
    timer.timeoutId = window.setTimeout(() => this.closeToast(toastElement), timer.remaining)
  }

  close(event: Event): void {
    const toastElement = this.eventToastElement(event)
    if (toastElement) {
      this.closeToast(toastElement)
    }
  }

  startSwipe(event: PointerEvent): void {
    const toastElement = this.eventToastElement(event)
    if (!toastElement) return

    this.activePointerId = event.pointerId
    this.swipeToast = toastElement
    this.swipeStartX = event.clientX
    this.swipeDeltaX = 0
    toastElement.dataset.swipe = "start"
    toastElement.setPointerCapture(event.pointerId)
    this.pause(event)
  }

  moveSwipe(event: PointerEvent): void {
    if (this.activePointerId !== event.pointerId || !this.swipeToast) return

    this.swipeDeltaX = event.clientX - this.swipeStartX
    this.swipeToast.dataset.swipe = "move"
    this.swipeToast.style.transform = `translateX(${this.swipeDeltaX}px)`
  }

  endSwipe(event: PointerEvent): void {
    if (this.activePointerId !== event.pointerId || !this.swipeToast) return

    const toastElement = this.swipeToast
    const shouldDismiss = Math.abs(this.swipeDeltaX) >= this.swipeThresholdValue

    toastElement.releasePointerCapture(event.pointerId)
    this.resetSwipeState()

    if (shouldDismiss) {
      toastElement.dataset.swipe = "end"
      this.closeToast(toastElement)
    } else {
      toastElement.dataset.swipe = "cancel"
      toastElement.style.transform = ""
      this.resume(event)
    }
  }

  cancelSwipe(event: PointerEvent): void {
    if (this.activePointerId !== event.pointerId || !this.swipeToast) return

    const toastElement = this.swipeToast
    toastElement.releasePointerCapture(event.pointerId)
    toastElement.dataset.swipe = "cancel"
    toastElement.style.transform = ""
    this.resetSwipeState()
    this.resume(event)
  }

  private flushPendingToasts(): void {
    const remaining: ToastOptions[] = []

    pendingToasts.forEach((toastOptions) => {
      if (toastOptions.position && toastOptions.position !== this.positionValue) {
        remaining.push(toastOptions)
        return
      }

      this.show(toastOptions)
    })

    pendingToasts.splice(0, pendingToasts.length, ...remaining)
  }

  private observeTurboAppends(): void {
    if (!this.hasViewportTarget) return

    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node instanceof HTMLElement) {
            this.initializeToastTree(node)
          }
        })
      })

      this.enforceLimit()
    })

    this.observer.observe(this.viewportTarget, { childList: true })
  }

  private initializeExistingToasts(): void {
    this.toastElements().forEach((toastElement) => this.initializeToastElement(toastElement))
    this.enforceLimit()
  }

  private initializeToastTree(node: HTMLElement): void {
    if (this.isToastElement(node)) {
      this.initializeToastElement(node)
    }

    node.querySelectorAll<HTMLElement>("[data-shadcn-sonner-toast-id], [data-sonner-toast]").forEach((toastElement) => {
      this.initializeToastElement(toastElement)
    })
  }

  private initializeToastElement(toastElement: HTMLElement): void {
    if (toastElement.dataset.shadcnSonnerBound === "true") return

    const id = this.ensureToastId(toastElement)
    const duration = normalizeDuration(toastElement.dataset.duration, this.durationValue)
    const variant = normalizeVariant(toastElement.dataset.variant)

    toastElement.dataset.shadcnSonnerBound = "true"
    toastElement.dataset.state = "open"
    toastElement.dataset.variant = variant
    toastElement.setAttribute("role", toastElement.getAttribute("role") || "status")
    toastElement.setAttribute("aria-live", toastElement.getAttribute("aria-live") || "polite")
    toastElement.className = this.toastClassName(variant, toastElement.className)

    this.ensureCloseButton(toastElement)
    this.startTimer(toastElement, duration)
    this.dispatch("show", { detail: { id } })
  }

  private buildToastElement(options: ToastOptions): HTMLElement {
    const toastElement = document.createElement("li")
    const id = String(options.id ?? nextToastId())
    const variant = normalizeVariant(options.variant)

    toastElement.dataset.shadcnSonnerToastId = id
    toastElement.dataset.sonnerToast = "true"
    toastElement.dataset.variant = variant
    toastElement.dataset.duration = String(normalizeDuration(options.duration, this.durationValue))
    toastElement.className = this.toastClassName(variant)
    toastElement.setAttribute("role", "status")
    toastElement.setAttribute("aria-live", "polite")
    toastElement.setAttribute("data-action", [
      "mouseenter->shadcn--sonner#pause",
      "mouseleave->shadcn--sonner#resume",
      "pointerdown->shadcn--sonner#startSwipe",
      "pointermove->shadcn--sonner#moveSwipe",
      "pointerup->shadcn--sonner#endSwipe",
      "pointercancel->shadcn--sonner#cancelSwipe"
    ].join(" "))

    const bodyElement = document.createElement("div")
    bodyElement.className = "grid gap-1"
    bodyElement.dataset.sonnerBody = "true"

    if (options.title) {
      const titleElement = document.createElement("div")
      titleElement.className = "text-sm font-semibold leading-none tracking-tight"
      titleElement.textContent = options.title
      bodyElement.appendChild(titleElement)
    }

    if (options.description) {
      const descriptionElement = document.createElement("div")
      descriptionElement.className = "text-sm opacity-90"
      descriptionElement.textContent = options.description
      bodyElement.appendChild(descriptionElement)
    }

    toastElement.appendChild(bodyElement)

    const action = this.normalizeAction(options.action)
    if (action) {
      const actionButton = document.createElement("button")
      actionButton.type = "button"
      actionButton.className = "inline-flex h-8 shrink-0 items-center justify-center rounded-md border border-input bg-background px-3 text-xs font-medium text-foreground hover:bg-accent hover:text-accent-foreground"
      actionButton.textContent = action.label
      actionButton.dataset.sonnerAction = "true"
      actionButton.addEventListener("click", (event) => {
        const handler = this.actionHandlers.get(id)
        handler?.(event)
        this.closeToast(toastElement)
      })

      if (action.onClick) {
        this.actionHandlers.set(id, action.onClick)
      }

      toastElement.appendChild(actionButton)
    }

    toastElement.appendChild(this.buildCloseButton())

    return toastElement
  }

  private updateToastElement(toastElement: HTMLElement, options: ToastOptions): void {
    const variant = normalizeVariant(options.variant ?? toastElement.dataset.variant)
    toastElement.dataset.variant = variant
    toastElement.className = this.toastClassName(variant)

    const bodyElement = toastElement.querySelector<HTMLElement>("[data-sonner-body]") ?? toastElement.firstElementChild
    if (bodyElement instanceof HTMLElement) {
      bodyElement.textContent = ""
      bodyElement.className = "grid gap-1"
      bodyElement.dataset.sonnerBody = "true"

      if (options.title) {
        const titleElement = document.createElement("div")
        titleElement.className = "text-sm font-semibold leading-none tracking-tight"
        titleElement.textContent = options.title
        bodyElement.appendChild(titleElement)
      }

      if (options.description) {
        const descriptionElement = document.createElement("div")
        descriptionElement.className = "text-sm opacity-90"
        descriptionElement.textContent = options.description
        bodyElement.appendChild(descriptionElement)
      }
    }
  }

  private normalizeAction(action: ToastAction | string | undefined): ToastAction | null {
    if (!action) return null
    if (typeof action === "string") return { label: action }

    return action
  }

  private toastClassName(variant: ToastVariant, currentClassName = ""): string {
    const classNames = new Set(
      [TOAST_BASE_CLASSES, TOAST_VARIANT_CLASSES[variant], currentClassName]
        .join(" ")
        .split(/\s+/)
        .filter(Boolean)
    )

    return Array.from(classNames).join(" ")
  }

  private ensureCloseButton(toastElement: HTMLElement): void {
    if (toastElement.querySelector("[data-sonner-close]")) return

    toastElement.appendChild(this.buildCloseButton())
  }

  private buildCloseButton(): HTMLButtonElement {
    const button = document.createElement("button")
    button.type = "button"
    button.className = "absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-1 focus:ring-ring group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50"
    button.setAttribute("aria-label", "Dismiss notification")
    button.setAttribute("data-sonner-close", "true")
    button.setAttribute("data-action", "click->shadcn--sonner#close")
    button.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" class="h-4 w-4"><path d="M18 6 6 18M6 6l12 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>'

    return button
  }

  private closeToast(toastElement: HTMLElement): void {
    const id = toastElement.dataset.shadcnSonnerToastId
    if (toastElement.dataset.state === "closed") return

    if (id) {
      const timer = this.timers.get(id)
      if (timer) this.clearTimer(timer)
      this.timers.delete(id)
      this.actionHandlers.delete(id)
    }

    toastElement.dataset.state = "closed"
    toastElement.style.pointerEvents = "none"
    toastElement.style.opacity = "0"
    toastElement.style.transform = this.exitTransform()

    window.setTimeout(() => {
      toastElement.remove()
      this.dispatch("dismiss", { detail: { id } })
    }, 200)
  }

  private enforceLimit(): void {
    const toasts = this.toastElements()
    const limit = Math.max(1, this.limitValue)
    const overflowCount = toasts.length - limit

    if (overflowCount <= 0) return

    toasts.slice(0, overflowCount).forEach((toastElement) => this.closeToast(toastElement))
  }

  private startTimer(toastElement: HTMLElement, duration: number): void {
    const id = this.ensureToastId(toastElement)
    const existingTimer = this.timers.get(id)
    if (existingTimer) this.clearTimer(existingTimer)

    const timer: ToastTimer = {
      timeoutId: null,
      duration,
      remaining: duration,
      startedAt: Date.now()
    }

    if (duration > 0) {
      timer.timeoutId = window.setTimeout(() => this.closeToast(toastElement), duration)
    }

    this.timers.set(id, timer)
  }

  private clearTimer(timer: ToastTimer): void {
    if (timer.timeoutId !== null) {
      window.clearTimeout(timer.timeoutId)
      timer.timeoutId = null
    }
  }

  private timerFor(toastElement: HTMLElement): ToastTimer | undefined {
    const id = toastElement.dataset.shadcnSonnerToastId
    return id ? this.timers.get(id) : undefined
  }

  private toastElements(): HTMLElement[] {
    if (!this.hasViewportTarget) return []

    return Array.from(this.viewportTarget.children).filter((child): child is HTMLElement => {
      return child instanceof HTMLElement && this.isToastElement(child)
    })
  }

  private findToastElement(id: string): HTMLElement | null {
    if (!this.hasViewportTarget) return null

    return this.toastElements().find((toastElement) => toastElement.dataset.shadcnSonnerToastId === id) ?? null
  }

  private ensureToastId(toastElement: HTMLElement): string {
    const existingId = toastElement.dataset.shadcnSonnerToastId
    if (existingId) return existingId

    const id = nextToastId()
    toastElement.dataset.shadcnSonnerToastId = id
    return id
  }

  private isToastElement(element: HTMLElement): boolean {
    return element.dataset.sonnerToast === "true" || element.dataset.shadcnSonnerToastId !== undefined
  }

  private eventToastElement(event: Event): HTMLElement | null {
    const target = event.currentTarget
    if (target instanceof HTMLElement && this.isToastElement(target)) {
      return target
    }

    if (target instanceof HTMLElement) {
      return target.closest<HTMLElement>("[data-shadcn-sonner-toast-id], [data-sonner-toast]")
    }

    return null
  }

  private exitTransform(): string {
    if (this.positionValue.includes("left")) return "translateX(-100%)"
    if (this.positionValue.includes("right")) return "translateX(100%)"
    if (this.positionValue.startsWith("top")) return "translateY(-100%)"

    return "translateY(100%)"
  }

  private resetSwipeState(): void {
    this.activePointerId = null
    this.swipeToast = null
    this.swipeStartX = 0
    this.swipeDeltaX = 0
  }
}
