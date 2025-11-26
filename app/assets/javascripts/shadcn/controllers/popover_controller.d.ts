import { Controller } from "@hotwired/stimulus";

/**
 * Popover controller for rich content overlays
 */
export default class PopoverController extends Controller {
  static targets: ["trigger", "content"];
  static values: {
    open: { type: "Boolean"; default: false };
    side: { type: "String"; default: "bottom" };
    align: { type: "String"; default: "center" };
    modal: { type: "Boolean"; default: false };
  };

  /** Popover trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Popover content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Whether the popover is open */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Side to display: "top", "bottom", "left", "right" */
  sideValue: "top" | "bottom" | "left" | "right";
  readonly hasSideValue: boolean;

  /** Horizontal alignment: "start", "center", "end" */
  alignValue: "start" | "center" | "end";
  readonly hasAlignValue: boolean;

  /** Whether the popover is modal */
  modalValue: boolean;
  readonly hasModalValue: boolean;

  /** Toggle popover open/closed */
  toggle(event?: Event): void;

  /** Show the popover */
  show(): void;

  /** Hide the popover */
  hide(): void;

  /** Close the popover (alias for hide) */
  close(): void;

  /** Handle clicks outside the popover */
  handleClickOutside(event: MouseEvent): void;

  /** Position the popover content */
  positionContent(): void;
}
