import { Controller } from "@hotwired/stimulus";

/**
 * Avatar controller for handling image load errors
 */
export default class AvatarController extends Controller {
  static targets: ["image", "fallback"];

  /** Avatar image target */
  readonly imageTarget: HTMLImageElement;
  readonly hasImageTarget: boolean;

  /** Fallback content target */
  readonly fallbackTarget: HTMLElement;
  readonly hasFallbackTarget: boolean;

  /** Handle image load error - shows fallback */
  handleError(): void;

  /** Handle successful image load - shows image */
  handleLoad(): void;
}
