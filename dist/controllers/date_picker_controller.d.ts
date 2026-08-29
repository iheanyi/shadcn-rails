import { Controller } from "@hotwired/stimulus";
/**
 * Date Picker controller
 * Handles opening/closing the calendar popover and date selection
 *
 * API inspired by React DayPicker (https://daypicker.dev/)
 *
 * Disabled dates:
 * - minDate/maxDate: Disable dates outside a range
 * - disabledDates: Comma-separated list of YYYY-MM-DD dates
 * - disabledDaysOfWeek: Comma-separated list of day numbers (0=Sun, 6=Sat)
 */
export default class DatePickerController extends Controller<HTMLElement> {
    static targets: string[];
    static values: {
        open: {
            type: BooleanConstructor;
            default: boolean;
        };
        month: StringConstructor;
        selected: StringConstructor;
        format: {
            type: StringConstructor;
            default: string;
        };
        placeholder: {
            type: StringConstructor;
            default: string;
        };
        minDate: StringConstructor;
        maxDate: StringConstructor;
        disabledDates: StringConstructor;
        disabledDaysOfWeek: StringConstructor;
        showOutsideDays: {
            type: BooleanConstructor;
            default: boolean;
        };
        weekStartsOn: {
            type: NumberConstructor;
            default: number;
        };
    };
    static MONTHS: string[];
    connect(): void;
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
    toggle(): void;
    open(): void;
    close(): void;
    openValueChanged(): void;
    closeOnClickOutside(event: ShadcnEvent): void;
    previousMonth(): void;
    nextMonth(): void;
    selectDay(event: ShadcnEvent): void;
    formatDate(date: Date): string;
    render(): void;
    renderDays(): string;
    monthValueChanged(): void;
    selectedValueChanged(): void;
}
//# sourceMappingURL=date_picker_controller.d.ts.map