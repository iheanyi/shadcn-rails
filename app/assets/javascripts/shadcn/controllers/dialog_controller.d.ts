import { Controller } from "@hotwired/stimulus";

/**
 * Dialog controller for modal dialogs
 * Handles opening, closing, focus trapping, and keyboard navigation
 */
export default class DialogController extends Controller {
  static targets: ["trigger", "template", "overlay", "content"];
  static values: {
    open: { type: "Boolean"; default: false };
    modal: { type: "Boolean"; default: true };
  };

  /** Dialog trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Template containing dialog content */
  readonly templateTarget: HTMLTemplateElement;
  readonly hasTemplateTarget: boolean;

  /** Dialog overlay target */
  readonly overlayTarget: HTMLElement;
  readonly hasOverlayTarget: boolean;

  /** Dialog content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Whether the dialog is open */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Whether the dialog is modal (traps focus, prevents body scroll) */
  modalValue: boolean;
  readonly hasModalValue: boolean;

  /** Portal element (created dynamically) */
  portal: HTMLDivElement | null;

  /** Previously focused element */
  previousActiveElement: Element | null;

  /** Open the dialog */
  open(): void;

  /** Close the dialog */
  close(): void;

  /** Toggle dialog open/closed */
  toggle(): void;

  /** Handle keydown events (Escape to close, Tab for focus trapping) */
  handleKeydown(event: KeyboardEvent): void;

  /** Handle clicks outside the dialog content */
  handleClickOutside(event: MouseEvent): void;

  /** Focus the first focusable element in the dialog */
  focusFirstElement(): void;

  /** Trap focus within the dialog */
  trapFocus(event: KeyboardEvent): void;

  /** Called when openValue changes */
  openValueChanged(): void;
}
