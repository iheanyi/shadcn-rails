import { Controller } from "@hotwired/stimulus";

/**
 * Drawer Controller
 * Handles opening/closing drawer panels
 */
export default class DrawerController extends Controller {
  static targets: ["trigger", "template", "overlay", "content"];
  static values: {
    open: { type: "Boolean"; default: false };
    direction: { type: "String"; default: "bottom" };
  };

  /** Drawer trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Template containing drawer content */
  readonly templateTarget: HTMLTemplateElement;
  readonly hasTemplateTarget: boolean;

  /** Drawer overlay target */
  readonly overlayTarget: HTMLElement;
  readonly hasOverlayTarget: boolean;

  /** Drawer content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Whether the drawer is open */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Direction the drawer slides from: "top", "right", "bottom", "left" */
  directionValue: "top" | "right" | "bottom" | "left";
  readonly hasDirectionValue: boolean;

  /** Portal element (created dynamically) */
  portal: HTMLDivElement | null;

  /** Open the drawer */
  open(): void;

  /** Close the drawer */
  close(): void;

  /** Toggle drawer open/closed */
  toggle(): void;

  /** Handle keydown events (Escape to close) */
  handleKeydown(event: KeyboardEvent): void;

  /** Remove the portal from the DOM */
  removePortal(): void;

  /** Called when openValue changes */
  openValueChanged(): void;
}
