import { Controller } from "@hotwired/stimulus";

/**
 * Sheet controller for slide-out panels
 */
export default class SheetController extends Controller {
  static targets: ["trigger", "template", "overlay", "content"];
  static values: {
    open: { type: "Boolean"; default: false };
    side: { type: "String"; default: "right" };
  };

  /** Sheet trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Template containing sheet content */
  readonly templateTarget: HTMLTemplateElement;
  readonly hasTemplateTarget: boolean;

  /** Sheet overlay target */
  readonly overlayTarget: HTMLElement;
  readonly hasOverlayTarget: boolean;

  /** Sheet content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Whether the sheet is open */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Side to display: "top", "right", "bottom", "left" */
  sideValue: "top" | "right" | "bottom" | "left";
  readonly hasSideValue: boolean;

  /** Portal element (created dynamically) */
  portal: HTMLDivElement | null;

  /** Previously focused element */
  previousActiveElement: Element | null;

  /** Open the sheet */
  open(): void;

  /** Close the sheet */
  close(): void;

  /** Toggle sheet open/closed */
  toggle(): void;

  /** Handle keydown events (Escape to close, Tab for focus trapping) */
  handleKeydown(event: KeyboardEvent): void;

  /** Focus the first focusable element in the sheet */
  focusFirstElement(): void;

  /** Trap focus within the sheet */
  trapFocus(event: KeyboardEvent): void;
}
