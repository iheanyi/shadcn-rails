import { Controller } from "@hotwired/stimulus";

/**
 * Toast controller for notification toasts
 */
export default class ToastController extends Controller {
  static values: {
    duration: { type: "Number"; default: 5000 };
    open: { type: "Boolean"; default: true };
  };

  /** Auto-dismiss duration in milliseconds (0 to disable) */
  durationValue: number;
  readonly hasDurationValue: boolean;

  /** Whether the toast is currently visible */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Dismiss timeout handle */
  dismissTimeout: ReturnType<typeof setTimeout> | null;

  /** Close the toast */
  close(): void;

  /** Start the auto-dismiss timer */
  startDismissTimer(): void;

  /** Clear the dismiss timer */
  clearDismissTimer(): void;

  /** Pause the dismiss timer (on hover) */
  pause(): void;

  /** Resume the dismiss timer (on hover end) */
  resume(): void;
}
