import { Controller } from "@hotwired/stimulus";

/**
 * Accordion controller for collapsible sections
 * Supports single and multiple expansion modes
 */
export default class AccordionController extends Controller {
  static targets: ["item", "trigger", "content"];
  static values: {
    type: { type: "String"; default: "single" };
    collapsible: { type: "Boolean"; default: false };
    default: { type: "String"; default: "" };
  };

  /** Accordion item targets */
  readonly itemTargets: HTMLElement[];
  readonly hasItemTarget: boolean;

  /** Accordion trigger targets */
  readonly triggerTargets: HTMLElement[];
  readonly hasTriggerTarget: boolean;

  /** Accordion content targets */
  readonly contentTargets: HTMLElement[];
  readonly hasContentTarget: boolean;

  /** Expansion type: "single" or "multiple" */
  typeValue: "single" | "multiple";
  readonly hasTypeValue: boolean;

  /** Whether single items can be collapsed */
  collapsibleValue: boolean;
  readonly hasCollapsibleValue: boolean;

  /** Default expanded items (comma-separated values for multiple) */
  defaultValue: string;
  readonly hasDefaultValue: boolean;

  /** Toggle an accordion item open/closed */
  toggle(event: Event): void;

  /** Expand a specific item */
  expandItem(item: HTMLElement): void;

  /** Collapse a specific item */
  collapseItem(item: HTMLElement): void;

  /** Find an item by its value */
  findItemByValue(value: string): HTMLElement | undefined;

  /** Handle keyboard navigation */
  handleKeydown(event: KeyboardEvent): void;
}
