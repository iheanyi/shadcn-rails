import { Controller } from "@hotwired/stimulus";

/**
 * Dropdown controller for dropdown menus
 * Handles opening, closing, keyboard navigation, and item selection
 */
export default class DropdownController extends Controller {
  static targets: ["trigger", "content", "item"];
  static values: {
    open: { type: "Boolean"; default: false };
    align: { type: "String"; default: "end" };
    side: { type: "String"; default: "bottom" };
  };

  /** Dropdown trigger target */
  readonly triggerTarget: HTMLElement;
  readonly hasTriggerTarget: boolean;

  /** Dropdown content target */
  readonly contentTarget: HTMLElement;
  readonly hasContentTarget: boolean;

  /** Dropdown item targets */
  readonly itemTargets: HTMLElement[];
  readonly hasItemTarget: boolean;

  /** Whether the dropdown is open */
  openValue: boolean;
  readonly hasOpenValue: boolean;

  /** Horizontal alignment: "start", "center", "end" */
  alignValue: "start" | "center" | "end";
  readonly hasAlignValue: boolean;

  /** Side to display: "top", "bottom" */
  sideValue: "top" | "bottom";
  readonly hasSideValue: boolean;

  /** Currently focused item index */
  focusedIndex: number;

  /** Toggle dropdown open/closed */
  toggle(event?: Event): void;

  /** Show the dropdown */
  show(): void;

  /** Hide the dropdown */
  hide(): void;

  /** Close the dropdown (alias for hide) */
  close(): void;

  /** Select a menu item */
  selectItem(event: Event): void;

  /** Handle clicks outside the dropdown */
  handleClickOutside(event: MouseEvent): void;

  /** Handle keyboard navigation */
  handleKeydown(event: KeyboardEvent): void;

  /** Focus next menu item */
  focusNextItem(): void;

  /** Focus previous menu item */
  focusPreviousItem(): void;

  /** Focus first menu item */
  focusFirstItem(): void;

  /** Focus last menu item */
  focusLastItem(): void;

  /** Select the currently focused item */
  selectFocusedItem(): void;

  /** Get enabled (non-disabled) items */
  readonly enabledItems: HTMLElement[];

  /** Position the dropdown content */
  positionContent(): void;
}
