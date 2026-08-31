import { Controller } from "@hotwired/stimulus";
const DAY_BUTTON_CLASSES = "inline-flex shrink-0 items-center justify-center gap-2 rounded-md text-sm font-medium whitespace-nowrap transition-all outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4 hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50 flex aspect-square size-auto w-full min-w-(--cell-size) flex-col gap-1 leading-none font-normal p-0 text-center select-none group-data-[focused=true]/day:relative group-data-[focused=true]/day:z-10 group-data-[focused=true]/day:border-ring group-data-[focused=true]/day:ring-[3px] group-data-[focused=true]/day:ring-ring/50 dark:hover:text-accent-foreground [&>span]:text-xs [&>span]:opacity-70";
const DAY_WRAPPER_CLASSES = "group/day relative aspect-square h-full w-full flex-1 p-0 text-center select-none [&:last-child[data-selected=true]_button]:rounded-r-md [&:first-child[data-selected=true]_button]:rounded-l-md";
const EMPTY_DAY_CLASSES = "invisible size-(--cell-size) min-w-(--cell-size) flex-1";
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
export default class DatePickerController extends Controller {
    static { this.targets = ["trigger", "content", "grid", "monthYear", "day", "displayValue", "hiddenInput"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        month: String,
        selected: String,
        format: { type: String, default: "medium" },
        placeholder: { type: String, default: "Pick a date" },
        minDate: String,
        maxDate: String,
        disabledDates: String, // comma-separated YYYY-MM-DD
        disabledDaysOfWeek: String, // comma-separated 0-6
        showOutsideDays: { type: Boolean, default: true },
        weekStartsOn: { type: Number, default: 0 } // 0 = Sunday, 1 = Monday, etc.
    }; }
    static { this.MONTHS = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]; }
    connect() {
        this.currentMonth = this.monthValue ? this.parseLocalDate(this.monthValue) : new Date();
        this.selectedDate = this.selectedValue ? this.parseLocalDate(this.selectedValue) : null;
    }
    /**
     * Parse a date string (YYYY-MM-DD) as local date, not UTC
     * This prevents timezone issues where "2024-11-26" becomes Nov 25 in western timezones
     */
    parseLocalDate(dateStr) {
        if (!dateStr)
            return null;
        const [year, month, day] = dateStr.split('-').map(Number);
        return new Date(year, month - 1, day);
    }
    /**
     * Format a date as YYYY-MM-DD using local date components
     */
    formatDateString(date) {
        if (!date)
            return '';
        return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
    }
    /**
     * Check if a date is disabled
     */
    isDateDisabled(date) {
        const dateStr = this.formatDateString(date);
        // Check min/max date
        if (this.minDateValue) {
            const minDate = this.parseLocalDate(this.minDateValue);
            if (minDate && date < minDate)
                return true;
        }
        if (this.maxDateValue) {
            const maxDate = this.parseLocalDate(this.maxDateValue);
            if (maxDate && date > maxDate)
                return true;
        }
        // Check disabled dates list
        if (this.disabledDatesValue) {
            const disabledDates = this.disabledDatesValue.split(",").map((d) => d.trim());
            if (disabledDates.includes(dateStr))
                return true;
        }
        // Check disabled days of week
        if (this.disabledDaysOfWeekValue) {
            const disabledDays = this.disabledDaysOfWeekValue.split(",").map((d) => parseInt(d.trim(), 10));
            if (disabledDays.includes(date.getDay()))
                return true;
        }
        return false;
    }
    toggle() {
        this.openValue = !this.openValue;
    }
    open() {
        this.openValue = true;
    }
    close() {
        this.openValue = false;
    }
    openValueChanged() {
        if (this.hasContentTarget) {
            this.contentTarget.style.display = this.openValue ? "block" : "none";
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", this.openValue.toString());
        }
    }
    closeOnClickOutside(event) {
        if (!this.openValue)
            return;
        if (this.element.contains(event.target))
            return;
        this.close();
    }
    previousMonth() {
        this.currentMonth.setMonth(this.currentMonth.getMonth() - 1);
        this.render();
    }
    nextMonth() {
        this.currentMonth.setMonth(this.currentMonth.getMonth() + 1);
        this.render();
    }
    selectDay(event) {
        const dateStr = event.currentTarget.dataset.date;
        if (!dateStr)
            return;
        const date = this.parseLocalDate(dateStr);
        if (!date)
            return;
        // Check if disabled
        if (this.isDateDisabled(date))
            return;
        this.selectedDate = date;
        this.selectedValue = dateStr;
        // Update hidden input
        if (this.hasHiddenInputTarget) {
            this.hiddenInputTarget.value = dateStr;
        }
        // Update display value
        if (this.hasDisplayValueTarget) {
            this.displayValueTarget.textContent = this.formatDate(this.selectedDate);
            this.displayValueTarget.classList.remove("text-muted-foreground");
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.dataset.empty = "false";
        }
        // Re-render calendar to update selection styling
        this.render();
        // Close the popover
        this.close();
        // Dispatch custom event
        this.dispatch("select", {
            detail: {
                date: this.selectedDate,
                dateString: dateStr
            }
        });
    }
    formatDate(date) {
        switch (this.formatValue) {
            case "short":
                return `${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getDate().toString().padStart(2, '0')}/${date.getFullYear()}`;
            case "long":
                return date.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric', year: 'numeric' });
            case "iso":
                // Use local date components to avoid timezone issues
                return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
            case "medium":
            default:
                return date.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' });
        }
    }
    render() {
        // Update month/year label
        if (this.hasMonthYearTarget) {
            const monthName = DatePickerController.MONTHS[this.currentMonth.getMonth()];
            const year = this.currentMonth.getFullYear();
            this.monthYearTarget.textContent = `${monthName} ${year}`;
        }
        // Render days grid
        if (this.hasGridTarget) {
            this.gridTarget.innerHTML = this.renderDays();
        }
    }
    renderDays() {
        const year = this.currentMonth.getFullYear();
        const month = this.currentMonth.getMonth();
        // Get first and last day of month
        const firstDay = new Date(year, month, 1);
        const lastDay = new Date(year, month + 1, 0);
        // Get start date based on weekStartsOn
        const startDate = new Date(firstDay);
        const dayOffset = (firstDay.getDay() - this.weekStartsOnValue + 7) % 7;
        startDate.setDate(firstDay.getDate() - dayOffset);
        // Get end date (complete the last week)
        const endDate = new Date(lastDay);
        const endDayOffset = (6 - lastDay.getDay() + this.weekStartsOnValue) % 7;
        endDate.setDate(lastDay.getDate() + endDayOffset);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        let html = "";
        let weekCells = [];
        const currentDate = new Date(startDate);
        const appendCell = (cellHtml) => {
            weekCells.push(cellHtml);
            if (weekCells.length === 7) {
                html += `<div class="mt-2 flex w-full">${weekCells.join("")}</div>`;
                weekCells = [];
            }
        };
        while (currentDate <= endDate) {
            const isOutside = currentDate.getMonth() !== month;
            const isToday = currentDate.getTime() === today.getTime();
            const isSelected = this.selectedDate &&
                currentDate.toDateString() === this.selectedDate.toDateString();
            const isDisabled = this.isDateDisabled(currentDate);
            // Use local date components to avoid timezone issues with toISOString()
            const dateStr = this.formatDateString(currentDate);
            // Skip outside days if showOutsideDays is false
            if (isOutside && !this.showOutsideDaysValue) {
                appendCell(`<div class="${EMPTY_DAY_CLASSES}"></div>`);
                currentDate.setDate(currentDate.getDate() + 1);
                continue;
            }
            let classes = DAY_BUTTON_CLASSES;
            if (isDisabled) {
                classes += " text-muted-foreground opacity-50 cursor-not-allowed";
            }
            else if (isSelected) {
                classes += " bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground cursor-pointer";
            }
            else if (isToday) {
                classes += " bg-accent text-accent-foreground cursor-pointer hover:bg-accent hover:text-accent-foreground";
            }
            else {
                classes += " cursor-pointer hover:bg-accent hover:text-accent-foreground";
            }
            if (isOutside && !isDisabled) {
                classes += " text-muted-foreground opacity-50";
            }
            const ariaAttrs = [];
            if (isSelected)
                ariaAttrs.push('aria-selected="true"');
            if (isDisabled) {
                ariaAttrs.push('aria-disabled="true"');
                ariaAttrs.push('disabled');
            }
            ariaAttrs.push('data-slot="button"');
            ariaAttrs.push(`data-day="${dateStr}"`);
            if (isSelected)
                ariaAttrs.push('data-selected-single="true"');
            const wrapperAttrs = [];
            if (isSelected)
                wrapperAttrs.push('data-selected="true"');
            // Only add click action for non-disabled days
            const dataAction = isDisabled
                ? ''
                : 'data-action="click->shadcn--date-picker#selectDay"';
            appendCell(`<div class="${DAY_WRAPPER_CLASSES}" ${wrapperAttrs.join(" ")}><button type="button" class="${classes}" data-date="${dateStr}" data-shadcn--date-picker-target="day" ${dataAction} ${ariaAttrs.join(" ")}>${currentDate.getDate()}</button></div>`);
            currentDate.setDate(currentDate.getDate() + 1);
        }
        if (weekCells.length > 0) {
            html += `<div class="mt-2 flex w-full">${weekCells.join("")}</div>`;
        }
        return html;
    }
    monthValueChanged() {
        if (this.monthValue) {
            this.currentMonth = this.parseLocalDate(this.monthValue);
        }
    }
    selectedValueChanged() {
        if (this.selectedValue) {
            this.selectedDate = this.parseLocalDate(this.selectedValue);
        }
    }
}
//# sourceMappingURL=date_picker_controller.js.map