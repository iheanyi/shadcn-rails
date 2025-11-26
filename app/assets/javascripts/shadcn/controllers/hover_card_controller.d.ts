import { Controller } from "@hotwired/stimulus";

/**
 * Hover Card Controller
 * Handles showing/hiding content on hover with delays
 */
export default class HoverCardController extends Controller {
  static targets: ["trigger", "content"];
  static values: {
    openDelay: { type: "Number"; default: 700 };
    closeDelay: { type: "Number"; default: 300 };
  };

  /** Hover card trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Hover card content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Delay before opening (ms) */
  openDelayValue: number;
  readonly hasOpenDelayValue: boolean;

  /** Delay before closing (ms) */
  closeDelayValue: number;
  readonly hasCloseDelayValue: boolean;

  /** Open timeout handle */
  openTimeout: ReturnType<typeof setTimeout> | null;

  /** Close timeout handle */
  closeTimeout: ReturnType<typeof setTimeout> | null;

  /** Whether the card is currently open */
  isOpen: boolean;

  /** Schedule opening the card */
  scheduleOpen(): void;

  /** Schedule closing the card */
  scheduleClose(): void;

  /** Cancel a pending close */
  cancelClose(): void;

  /** Clear all timeouts */
  clearTimeouts(): void;

  /** Open the hover card */
  open(): void;

  /** Close the hover card */
  close(): void;

  /** Position the card content */
  positionContent(): void;
}
