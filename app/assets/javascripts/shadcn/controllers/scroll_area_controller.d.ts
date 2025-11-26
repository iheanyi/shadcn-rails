import { Controller } from "@hotwired/stimulus";

/**
 * Scroll Area controller for custom scrollbars
 */
export default class ScrollAreaController extends Controller {
  static targets: ["viewport", "scrollbar", "thumb"];
  static values: {
    orientation: { type: "String"; default: "vertical" };
    type: { type: "String"; default: "hover" };
  };

  /** Scrollable viewport target */
  readonly viewportTarget: HTMLElement;
  readonly hasViewportTarget: boolean;

  /** Scrollbar container targets */
  readonly scrollbarTargets: HTMLElement[];
  readonly hasScrollbarTarget: boolean;

  /** Scrollbar thumb target */
  readonly thumbTarget: HTMLElement;
  readonly hasThumbTarget: boolean;

  /** Scroll orientation: "vertical", "horizontal", "both" */
  orientationValue: "vertical" | "horizontal" | "both";
  readonly hasOrientationValue: boolean;

  /** Scrollbar visibility type: "hover", "scroll", "always" */
  typeValue: "hover" | "scroll" | "always";
  readonly hasTypeValue: boolean;

  /** Handle scroll events */
  handleScroll(): void;

  /** Update scrollbar thumb position and size */
  updateScrollbar(): void;

  /** Show the scrollbar */
  showScrollbar(): void;

  /** Hide the scrollbar */
  hideScrollbar(): void;
}
