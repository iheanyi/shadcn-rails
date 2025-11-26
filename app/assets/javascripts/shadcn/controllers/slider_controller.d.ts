import { Controller } from "@hotwired/stimulus";

/**
 * Slider Controller
 * Handles slider value selection with drag and keyboard support
 */
export default class SliderController extends Controller {
  static targets: ["track", "range", "thumb", "input", "output"];
  static values: {
    min: { type: "Number"; default: 0 };
    max: { type: "Number"; default: 100 };
    step: { type: "Number"; default: 1 };
    value: { type: "Number"; default: 0 };
    name: "String";
    disabled: { type: "Boolean"; default: false };
    outputFormat: { type: "String"; default: "{value}" };
  };

  /** Slider track target */
  readonly trackTarget: HTMLElement;
  readonly hasTrackTarget: boolean;

  /** Filled range target */
  readonly rangeTarget: HTMLElement;
  readonly hasRangeTarget: boolean;

  /** Draggable thumb target */
  readonly thumbTarget: HTMLElement;
  readonly hasThumbTarget: boolean;

  /** Hidden input target */
  readonly inputTarget: HTMLInputElement;
  readonly hasInputTarget: boolean;

  /** Output display target */
  readonly outputTarget: HTMLElement;
  readonly hasOutputTarget: boolean;

  /** Minimum value */
  minValue: number;
  readonly hasMinValue: boolean;

  /** Maximum value */
  maxValue: number;
  readonly hasMaxValue: boolean;

  /** Step increment */
  stepValue: number;
  readonly hasStepValue: boolean;

  /** Current value */
  valueValue: number;
  readonly hasValueValue: boolean;

  /** Input name for form submission */
  nameValue: string;
  readonly hasNameValue: boolean;

  /** Whether slider is disabled */
  disabledValue: boolean;
  readonly hasDisabledValue: boolean;

  /** Format string for output (use {value} for value, {percent} for percentage) */
  outputFormatValue: string;
  readonly hasOutputFormatValue: boolean;

  /** Whether currently dragging */
  isDragging: boolean;

  /** Start drag operation */
  startDrag(event: MouseEvent | TouchEvent): void;

  /** Handle drag movement */
  handleDrag(event: MouseEvent | TouchEvent): void;

  /** Stop drag operation */
  stopDrag(): void;

  /** Handle keyboard navigation */
  handleKeydown(event: KeyboardEvent): void;

  /** Snap value to step */
  snapToStep(value: number): number;

  /** Update visual elements */
  updateVisuals(): void;

  /** Update output element */
  updateOutput(): void;

  /** Dispatch change event */
  dispatchChange(): void;

  /** Get current percentage */
  readonly percentage: number;

  /** Called when valueValue changes */
  valueValueChanged(): void;

  /** Update style for native input range element */
  updateStyle(event: Event): void;
}
