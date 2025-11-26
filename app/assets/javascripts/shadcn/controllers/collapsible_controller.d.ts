import { Controller } from "@hotwired/stimulus";

/**
 * Collapsible controller for expandable content
 */
export default class CollapsibleController extends Controller {
  static targets: ["trigger", "content"];
  static values: {
    open: { type: "Boolean"; default: false };
    disabled: { type: "Boolean"; default: false };
  };

  /** Trigger element target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Content element target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Whether the collapsible is open */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Whether the collapsible is disabled */
  disabledValue: boolean;
  readonly hasDisabledValue: boolean;

  /** Toggle open/closed state */
  toggle(): void;

  /** Open the collapsible */
  open(): void;

  /** Close the collapsible */
  close(): void;

  /** Update the visual state */
  updateState(): void;

  /** Called when openValue changes */
  openValueChanged(): void;
}
