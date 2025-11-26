import { Controller } from "@hotwired/stimulus";

/**
 * Radio Group Controller
 * Handles radio group selection with keyboard navigation
 */
export default class RadioGroupController extends Controller {
  static targets: ["item", "indicator"];
  static values: {
    name: "String";
    value: "String";
  };

  /** Radio item targets */
  readonly itemTargets: HTMLElement[];
  readonly hasItemTarget: boolean;

  /** Visual indicator targets */
  readonly indicatorTargets: HTMLElement[];
  readonly hasIndicatorTarget: boolean;

  /** Input name for form submission */
  nameValue: string;
  readonly hasNameValue: boolean;

  /** Currently selected value */
  valueValue: string;
  readonly hasValueValue: boolean;

  /** Select a radio item */
  select(event: Event): void;

  /** Handle keyboard navigation */
  handleKeydown(event: KeyboardEvent): void;

  /** Update selection state visuals */
  updateSelection(): void;

  /** Dispatch change event */
  dispatchChange(value: string): void;

  /** Get enabled (non-disabled) items */
  readonly enabledItems: HTMLElement[];

  /** Called when valueValue changes */
  valueValueChanged(): void;
}
