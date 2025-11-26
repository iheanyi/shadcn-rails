import { Controller } from "@hotwired/stimulus";

/**
 * Tabs controller for tabbed interfaces
 * Handles tab selection, keyboard navigation, content switching, and URL sync
 */
export default class TabsController extends Controller {
  static targets: ["list", "trigger", "content"];
  static values: {
    defaultValue: "String";
    urlParam: "String";
  };

  /** Tab list container target */
  readonly listTarget: HTMLElement;
  readonly hasListTarget: boolean;

  /** Tab trigger targets */
  readonly triggerTargets: HTMLElement[];
  readonly hasTriggerTarget: boolean;

  /** Tab content panel targets */
  readonly contentTargets: HTMLElement[];
  readonly hasContentTarget: boolean;

  /** Default tab value to select */
  defaultValueValue: string;
  readonly hasDefaultValueValue: boolean;

  /** URL parameter name for syncing tab state */
  urlParamValue: string;
  readonly hasUrlParamValue: boolean;

  /** Handle browser back/forward navigation */
  handlePopState(): void;

  /** Get current value from URL */
  getValueFromUrl(): string | null;

  /** Update URL with current tab value */
  updateUrl(value: string): void;

  /** Select a tab via click event */
  selectTab(event: Event): void;

  /** Select a tab by its value */
  selectTabByValue(value: string, updateUrl?: boolean): void;

  /** Handle keyboard navigation (Arrow keys, Home, End) */
  handleKeydown(event: KeyboardEvent): void;
}
