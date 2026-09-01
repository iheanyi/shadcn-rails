import { computePosition, autoUpdate, flip, shift, offset, size } from "@floating-ui/dom";
import type { Placement } from "@floating-ui/dom";
/**
 * Middleware that includes size constraints for dropdowns/selects
 */
export type FloatingPosition = {
    x: number;
    y: number;
    placement: Placement;
};
export type FloatingOptions = {
    placement?: Placement | string;
    offset?: number;
    sameWidth?: boolean;
    minWidth?: boolean;
    referenceWidthVariable?: string | null;
    referenceHeightVariable?: string | null;
    maxHeight?: number | null;
    onPositioned?: ((position: FloatingPosition) => void) | null;
};
/**
 * Position a floating element relative to a reference element
 *
 * @param {HTMLElement} reference - The trigger/reference element
 * @param {HTMLElement} floating - The floating content element
 * @param {Object} options - Positioning options
 * @param {string} options.placement - Placement (top, bottom, left, right, with -start/-end variants)
 * @param {number} options.offset - Offset distance in pixels (default: 4)
 * @param {boolean} options.sameWidth - Make floating element same width as reference
 * @param {boolean} options.minWidth - Make floating element at least as wide as reference while allowing growth
 * @param {string} options.referenceWidthVariable - CSS variable to populate with the reference width
 * @param {string} options.referenceHeightVariable - CSS variable to populate with the reference height
 * @param {number} options.maxHeight - Maximum height for the floating element
 * @param {Function} options.onPositioned - Callback after positioning
 * @returns {Function} Cleanup function to stop auto-updates
 */
export declare function positionFloating(reference: HTMLElement, floating: HTMLElement, options?: FloatingOptions): () => void;
/**
 * Position a context menu at specific coordinates
 *
 * @param {HTMLElement} floating - The floating content element
 * @param {number} x - X coordinate (clientX from event)
 * @param {number} y - Y coordinate (clientY from event)
 * @param {Object} options - Positioning options
 * @returns {void}
 */
export declare function positionAtPoint(floating: HTMLElement, x: number, y: number, options?: Pick<FloatingOptions, "maxHeight">): void;
export { computePosition, autoUpdate, flip, shift, offset, size };
//# sourceMappingURL=floating.d.ts.map