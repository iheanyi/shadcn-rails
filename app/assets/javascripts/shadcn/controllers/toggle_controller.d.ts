import { Controller } from "@hotwired/stimulus";

/**
 * Toggle Controller
 * Handles toggle button state management
 */
export default class ToggleController extends Controller {
  static values: {
    pressed: { type: "Boolean"; default: false };
  };

  /** Whether the toggle is pressed */
  pressedValue: boolean;
  readonly hasPressedValue: boolean;

  /** Toggle the pressed state */
  toggle(): void;

  /** Update visual state */
  updateState(): void;

  /** Dispatch change event */
  dispatchChange(): void;

  /** Called when pressedValue changes */
  pressedValueChanged(): void;
}
