import { Controller } from "@hotwired/stimulus";

/**
 * Select controller for custom select dropdowns
 */
export default class SelectController extends Controller {
  static targets: ["trigger", "content", "input", "item", "display", "checkIcon"];
  static values: {
    value: "String";
  };

  /** Select trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Select content/dropdown target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Hidden input target */
  readonly inputTarget: HTMLInputElement;
  readonly hasInputTarget: boolean;

  /** Select option item targets */
  readonly itemTargets: HTMLElement[];
  readonly hasItemTarget: boolean;

  /** Display element for selected value */
  readonly displayTarget: HTMLElement;
  readonly hasDisplayTarget: boolean;

  /** Check icon targets */
  readonly checkIconTargets: HTMLElement[];
  readonly hasCheckIconTarget: boolean;

  /** Currently selected value */
  valueValue: string;
  readonly hasValueValue: boolean;

  /** Whether the select is currently open */
  isOpen: boolean;

  /** Currently focused item index */
  focusedIndex: number;

  /** Toggle select open/closed */
  toggle(event?: Event): void;

  /** Open the select dropdown */
  open(): void;

  /** Close the select dropdown */
  close(): void;

  /** Select an item */
  select(event: Event): void;

  /** Select by value programmatically */
  selectByValue(value: string, dispatch?: boolean): void;

  /** Handle clicks outside the select */
  handleClickOutside(event: MouseEvent): void;

  /** Handle keyboard navigation */
  handleKeydown(event: KeyboardEvent): void;

  /** Focus next item */
  focusNextItem(): void;

  /** Focus previous item */
  focusPreviousItem(): void;

  /** Focus first item */
  focusFirstItem(): void;

  /** Focus last item */
  focusLastItem(): void;

  /** Select the currently focused item */
  selectFocusedItem(): void;

  /** Get enabled (non-disabled) items */
  readonly enabledItems: HTMLElement[];
}
