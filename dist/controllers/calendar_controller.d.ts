import { Controller } from "@hotwired/stimulus";
/**
 * Calendar controller for date picker
 * Handles month navigation, date selection, and rendering
 *
 * API inspired by React DayPicker (https://daypicker.dev/)
 *
 * Selection modes:
 * - single: Select one date at a time (default)
 * - multiple: Select multiple individual dates
 * - range: Select a date range (start to end)
 *
 * Disabled dates:
 * - minDate/maxDate: Disable dates outside a range
 * - disabledDates: Comma-separated list of YYYY-MM-DD dates
 * - disabledDaysOfWeek: Comma-separated list of day numbers (0=Sun, 6=Sat)
 */
export default class CalendarController extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        month: StringConstructor;
        selected: StringConstructor;
        mode: {
            type: StringConstructor;
            default: string;
        };
        minDate: StringConstructor;
        maxDate: StringConstructor;
        disabledDates: StringConstructor;
        disabledDaysOfWeek: StringConstructor;
        required: {
            type: BooleanConstructor;
            default: boolean;
        };
        weekStartsOn: {
            type: NumberConstructor;
            default: number;
        };
        showOutsideDays: {
            type: BooleanConstructor;
            default: boolean;
        };
    };
    static MONTHS: string[];
    static WEEKDAYS: string[];
    connect(): void;
    disconnect(): void;
    /**
     * Initialize selected date(s) based on mode
     */
    initializeSelection(): void;
    /**
     * Parse a date string (YYYY-MM-DD) as local date, not UTC
     * This prevents timezone issues where "2024-11-26" becomes Nov 25 in western timezones
     */
    parseLocalDate(dateStr: string): Date | null;
    /**
     * Format a date as YYYY-MM-DD using local date components
     */
    formatDateString(date: Date): string;
    /**
     * Check if a date is disabled
     */
    isDateDisabled(date: Date): boolean;
    /**
     * Check if a date is selected
     */
    isDateSelected(date: Date): any;
    /**
     * Check if a date is in range (for range mode)
     */
    isDateInRange(date: Date): boolean;
    /**
     * Check if date is the start of a range
     */
    isRangeStart(date: Date): boolean;
    /**
     * Check if date is the end of a range
     */
    isRangeEnd(date: Date): boolean;
    previousMonth(): void;
    nextMonth(): void;
    selectMonth(event: ShadcnEvent): void;
    selectYear(event: ShadcnEvent): void;
    selectDay(event: ShadcnEvent): void;
    handleSingleSelection(date: Date, dateStr: string): void;
    handleMultipleSelection(date: Date, dateStr: string): void;
    handleRangeSelection(date: Date, dateStr: string): void;
    dispatchSelectEvent(date: Date | null, dateStr: string): void;
    /**
     * Handle keyboard navigation
     */
    handleKeydown(event: ShadcnEvent): void;
    /**
     * Focus a specific day button
     */
    focusDay(date: Date): void;
    /**
     * Enable keyboard navigation when calendar gets focus
     */
    enableKeyboard(): void;
    /**
     * Get an initial focus date based on selection mode
     */
    getInitialFocusDate(): any;
    /**
     * Disable keyboard navigation
     */
    disableKeyboard(): void;
    render(): void;
    renderDays(): string;
    /**
     * Go to today's date
     */
    goToToday(): void;
    monthValueChanged(): void;
    selectedValueChanged(): void;
}
//# sourceMappingURL=calendar_controller.d.ts.map