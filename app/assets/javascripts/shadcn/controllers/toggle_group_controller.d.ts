import { Controller } from "@hotwired/stimulus";

/**
 * Toggle Group Controller
 * Handles single or multiple selection of toggle items
 */
export default class ToggleGroupController extends Controller {
  static targets: ["item", "input"];
  static values: {
    type: { type: "String"; default: "single" };
    value: { type: "String"; default: "" };
  };

  /** Toggle item targets */
  readonly itemTargets: HTMLElement[];
  readonly hasItemTarget: boolean;

  /** Hidden input target */
  readonly inputTarget: HTMLInputElement;
  readonly hasInputTarget: boolean;

  /** Selection type: "single" or "multiple" */
  typeValue: "single" | "multiple";
  readonly hasTypeValue: boolean;

  /** Current value(s) as comma-separated string */
  valueValue: string;
  readonly hasValueValue: boolean;

  /** Toggle an item's selection */
  toggle(event: Event): void;

  /** Get current values as array */
  getValues(): string[];

  /** Update visual states of all items */
  updateStates(): void;

  /** Update hidden input value */
  updateInput(): void;

  /** Called when valueValue changes */
  valueValueChanged(): void;
}
