import { Controller } from "@hotwired/stimulus";

/**
 * Checkbox controller for custom checkboxes
 */
export default class CheckboxController extends Controller {
  static values: {
    checked: { type: "Boolean"; default: false };
    name: "String";
  };

  /** Whether the checkbox is checked */
  checkedValue: boolean;
  readonly hasCheckedValue: boolean;

  /** Input name for form submission */
  nameValue: string;
  readonly hasNameValue: boolean;

  /** Toggle the checkbox state */
  toggle(): void;

  /** Update the visual state */
  updateState(): void;

  /** Update hidden input value */
  updateHiddenInput(): void;

  /** Called when checkedValue changes */
  checkedValueChanged(): void;
}
