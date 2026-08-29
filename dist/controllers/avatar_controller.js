import { Controller } from "@hotwired/stimulus";
/**
 * Avatar controller for handling image load errors
 */
export default class default_1 extends Controller {
    static { this.targets = ["image", "fallback"]; }
    handleError() {
        if (this.hasImageTarget) {
            this.imageTarget.hidden = true;
        }
        if (this.hasFallbackTarget) {
            this.fallbackTarget.classList.remove("hidden");
        }
    }
    handleLoad() {
        if (this.hasImageTarget) {
            this.imageTarget.hidden = false;
        }
        if (this.hasFallbackTarget) {
            this.fallbackTarget.classList.add("hidden");
        }
    }
}
//# sourceMappingURL=avatar_controller.js.map