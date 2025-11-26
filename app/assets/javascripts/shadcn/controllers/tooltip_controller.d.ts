import { Controller } from "@hotwired/stimulus";

/**
 * Tooltip controller for contextual information
 */
export default class TooltipController extends Controller {
  static targets: ["trigger", "content"];
  static values: {
    side: { type: "String"; default: "top" };
    align: { type: "String"; default: "center" };
    delay: { type: "Number"; default: 200 };
    skipDelay: { type: "Number"; default: 300 };
  };

  /** Tooltip trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Tooltip content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Side to display: "top", "bottom", "left", "right" */
  sideValue: "top" | "bottom" | "left" | "right";
  readonly hasSideValue: boolean;

  /** Alignment: "start", "center", "end" */
  alignValue: "start" | "center" | "end";
  readonly hasAlignValue: boolean;

  /** Delay before showing tooltip (ms) */
  delayValue: number;
  readonly hasDelayValue: boolean;

  /** Skip delay threshold (ms) */
  skipDelayValue: number;
  readonly hasSkipDelayValue: boolean;

  /** Show timeout handle */
  showTimeout: ReturnType<typeof setTimeout> | null;

  /** Hide timeout handle */
  hideTimeout: ReturnType<typeof setTimeout> | null;

  /** Show the tooltip */
  show(): void;

  /** Hide the tooltip */
  hide(): void;

  /** Clear all timeouts */
  clearTimeouts(): void;

  /** Position the tooltip */
  positionTooltip(): void;
}
