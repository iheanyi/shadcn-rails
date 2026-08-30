import { Controller } from '@hotwired/stimulus';

/*
 * stimulus-use 0.52.2
 */

const composeEventName = (name, controller, eventPrefix) => {
  let composedName = name;
  if (eventPrefix === true) {
    composedName = `${controller.identifier}:${name}`;
  } else if (typeof eventPrefix === "string") {
    composedName = `${eventPrefix}:${name}`;
  }
  return composedName;
};

const extendedEvent = (type, event, detail) => {
  const {bubbles: bubbles, cancelable: cancelable, composed: composed} = event || {
    bubbles: true,
    cancelable: true,
    composed: true
  };
  if (event) {
    Object.assign(detail, {
      originalEvent: event
    });
  }
  const customEvent = new CustomEvent(type, {
    bubbles: bubbles,
    cancelable: cancelable,
    composed: composed,
    detail: detail
  });
  return customEvent;
};

function isElementInViewport(el) {
  const rect = el.getBoundingClientRect();
  const windowHeight = window.innerHeight || document.documentElement.clientHeight;
  const windowWidth = window.innerWidth || document.documentElement.clientWidth;
  const vertInView = rect.top <= windowHeight && rect.top + rect.height > 0;
  const horInView = rect.left <= windowWidth && rect.left + rect.width > 0;
  return vertInView && horInView;
}

function camelize(value) {
  return value.replace(/(?:[_-])([a-z0-9])/g, ((_, char) => char.toUpperCase()));
}

/******************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
/* global Reflect, Promise */ function __rest(s, e) {
  var t = {};
  for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0) t[p] = s[p];
  if (s != null && typeof Object.getOwnPropertySymbols === "function") for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
    if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i])) t[p[i]] = s[p[i]];
  }
  return t;
}

const defaultOptions$8 = {
  debug: false,
  logger: console,
  dispatchEvent: true,
  eventPrefix: true
};

class StimulusUse {
  constructor(controller, options = {}) {
    var _a, _b, _c;
    this.log = (functionName, args) => {
      if (!this.debug) return;
      this.logger.groupCollapsed(`%c${this.controller.identifier} %c#${functionName}`, "color: #3B82F6", "color: unset");
      this.logger.log(Object.assign({
        controllerId: this.controllerId
      }, args));
      this.logger.groupEnd();
    };
    this.warn = message => {
      this.logger.warn(`%c${this.controller.identifier} %c${message}`, "color: #3B82F6; font-weight: bold", "color: unset");
    };
    this.dispatch = (eventName, details = {}) => {
      if (this.dispatchEvent) {
        const {event: event} = details, eventDetails = __rest(details, [ "event" ]);
        const customEvent = this.extendedEvent(eventName, event || null, eventDetails);
        this.targetElement.dispatchEvent(customEvent);
        this.log("dispatchEvent", Object.assign({
          eventName: customEvent.type
        }, eventDetails));
      }
    };
    this.call = (methodName, args = {}) => {
      const method = this.controller[methodName];
      if (typeof method == "function") {
        return method.call(this.controller, args);
      }
    };
    this.extendedEvent = (name, event, detail) => {
      const {bubbles: bubbles, cancelable: cancelable, composed: composed} = event || {
        bubbles: true,
        cancelable: true,
        composed: true
      };
      if (event) {
        Object.assign(detail, {
          originalEvent: event
        });
      }
      const customEvent = new CustomEvent(this.composeEventName(name), {
        bubbles: bubbles,
        cancelable: cancelable,
        composed: composed,
        detail: detail
      });
      return customEvent;
    };
    this.composeEventName = name => {
      let composedName = name;
      if (this.eventPrefix === true) {
        composedName = `${this.controller.identifier}:${name}`;
      } else if (typeof this.eventPrefix === "string") {
        composedName = `${this.eventPrefix}:${name}`;
      }
      return composedName;
    };
    this.debug = (_b = (_a = options === null || options === void 0 ? void 0 : options.debug) !== null && _a !== void 0 ? _a : controller.application.stimulusUseDebug) !== null && _b !== void 0 ? _b : defaultOptions$8.debug;
    this.logger = (_c = options === null || options === void 0 ? void 0 : options.logger) !== null && _c !== void 0 ? _c : defaultOptions$8.logger;
    this.controller = controller;
    this.controllerId = controller.element.id || controller.element.dataset.id;
    this.targetElement = (options === null || options === void 0 ? void 0 : options.element) || controller.element;
    const {dispatchEvent: dispatchEvent, eventPrefix: eventPrefix} = Object.assign({}, defaultOptions$8, options);
    Object.assign(this, {
      dispatchEvent: dispatchEvent,
      eventPrefix: eventPrefix
    });
    this.controllerInitialize = controller.initialize.bind(controller);
    this.controllerConnect = controller.connect.bind(controller);
    this.controllerDisconnect = controller.disconnect.bind(controller);
  }
}

const defaultOptions$5 = {
  events: [ "click", "touchend" ],
  onlyVisible: true,
  dispatchEvent: true,
  eventPrefix: true
};

const useClickOutside = (composableController, options = {}) => {
  const controller = composableController;
  const {onlyVisible: onlyVisible, dispatchEvent: dispatchEvent, events: events, eventPrefix: eventPrefix} = Object.assign({}, defaultOptions$5, options);
  const onEvent = event => {
    const targetElement = (options === null || options === void 0 ? void 0 : options.element) || controller.element;
    if (targetElement.contains(event.target) || !isElementInViewport(targetElement) && onlyVisible) {
      return;
    }
    if (controller.clickOutside) {
      controller.clickOutside(event);
    }
    if (dispatchEvent) {
      const eventName = composeEventName("click:outside", controller, eventPrefix);
      const clickOutsideEvent = extendedEvent(eventName, event, {
        controller: controller
      });
      targetElement.dispatchEvent(clickOutsideEvent);
    }
  };
  const observe = () => {
    events === null || events === void 0 ? void 0 : events.forEach((event => {
      window.addEventListener(event, onEvent, true);
    }));
  };
  const unobserve = () => {
    events === null || events === void 0 ? void 0 : events.forEach((event => {
      window.removeEventListener(event, onEvent, true);
    }));
  };
  const controllerDisconnect = controller.disconnect.bind(controller);
  Object.assign(controller, {
    disconnect() {
      unobserve();
      controllerDisconnect();
    }
  });
  observe();
  return [ observe, unobserve ];
};

class DebounceController extends Controller {}

DebounceController.debounces = [];

const defaultWait$1 = 200;

const debounce = (fn, wait = defaultWait$1) => {
  let timeoutId = null;
  return function() {
    const args = Array.from(arguments);
    const context = this;
    const params = args.map((arg => arg.params));
    const callback = () => {
      args.forEach(((arg, index) => arg.params = params[index]));
      return fn.apply(context, args);
    };
    if (timeoutId) {
      clearTimeout(timeoutId);
    }
    timeoutId = setTimeout(callback, wait);
  };
};

const useDebounce = (composableController, options) => {
  const controller = composableController;
  const constructor = controller.constructor;
  constructor.debounces.forEach((func => {
    if (typeof func === "string") {
      controller[func] = debounce(controller[func], options === null || options === void 0 ? void 0 : options.wait);
    }
    if (typeof func === "object") {
      const {name: name, wait: wait} = func;
      if (!name) return;
      controller[name] = debounce(controller[name], wait || (options === null || options === void 0 ? void 0 : options.wait));
    }
  }));
};

const defaultOptions$2 = {
  mediaQueries: {},
  dispatchEvent: true,
  eventPrefix: true,
  debug: false
};

class UseMatchMedia extends StimulusUse {
  constructor(controller, options = {}) {
    var _a, _b, _c, _d;
    super(controller, options);
    this.matches = [];
    this.callback = event => {
      const name = Object.keys(this.mediaQueries).find((name => this.mediaQueries[name] === event.media));
      if (!name) return;
      const {media: media, matches: matches} = event;
      this.changed({
        name: name,
        media: media,
        matches: matches,
        event: event
      });
    };
    this.changed = payload => {
      const {name: name} = payload;
      if (payload.event) {
        this.call(camelize(`${name}_changed`), payload);
        this.dispatch(`${name}:changed`, payload);
        this.log(`media query "${name}" changed`, payload);
      }
      if (payload.matches) {
        this.call(camelize(`is_${name}`), payload);
        this.dispatch(`is:${name}`, payload);
      } else {
        this.call(camelize(`not_${name}`), payload);
        this.dispatch(`not:${name}`, payload);
      }
    };
    this.observe = () => {
      Object.keys(this.mediaQueries).forEach((name => {
        const media = this.mediaQueries[name];
        const match = window.matchMedia(media);
        match.addListener(this.callback);
        this.matches.push(match);
        this.changed({
          name: name,
          media: media,
          matches: match.matches
        });
      }));
    };
    this.unobserve = () => {
      this.matches.forEach((match => match.removeListener(this.callback)));
    };
    this.controller = controller;
    this.mediaQueries = (_a = options.mediaQueries) !== null && _a !== void 0 ? _a : defaultOptions$2.mediaQueries;
    this.dispatchEvent = (_b = options.dispatchEvent) !== null && _b !== void 0 ? _b : defaultOptions$2.dispatchEvent;
    this.eventPrefix = (_c = options.eventPrefix) !== null && _c !== void 0 ? _c : defaultOptions$2.eventPrefix;
    this.debug = (_d = options.debug) !== null && _d !== void 0 ? _d : defaultOptions$2.debug;
    if (!window.matchMedia) {
      console.error("window.matchMedia() is not available");
      return;
    }
    this.enhanceController();
    this.observe();
  }
  enhanceController() {
    const controllerDisconnect = this.controller.disconnect.bind(this.controller);
    const disconnect = () => {
      this.unobserve();
      controllerDisconnect();
    };
    Object.assign(this.controller, {
      disconnect: disconnect
    });
  }
}

const useMatchMedia = (controller, options = {}) => {
  const observer = new UseMatchMedia(controller, options);
  return [ observer.observe, observer.unobserve ];
};

class ThrottleController extends Controller {}

ThrottleController.throttles = [];

/**
 * Base Menu Controller
 *
 * A base controller for menu-like components (dropdown, context menu, select, etc.)
 * that provides common functionality for:
 * - Opening/closing menus
 * - Keyboard navigation (arrow keys, home, end, enter, space, escape)
 * - Focus management
 * - Click outside to close (using stimulus-use)
 * - Item selection
 *
 * Subclasses can override specific methods to customize behavior:
 * - positionContent() - Custom positioning logic
 * - showMenu() - Additional show behavior
 * - hideMenu() - Additional hide behavior
 * - shouldCloseOnClickOutside(event) - Custom click outside logic
 */
let default_1$v = class default_1 extends Controller {
    static { this.targets = ["trigger", "content", "item"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        hideDelay: { type: Number, default: 150 }
    }; }
    // Lifecycle hooks
    connect() {
        this.focusedIndex = -1;
        this.hideTimeoutId = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        // Use stimulus-use for click outside detection
        useClickOutside(this);
        if (this.openValue) {
            this.show();
        }
    }
    disconnect() {
        this.hide();
    }
    // Public API
    toggle(event) {
        event?.preventDefault();
        if (this.openValue) {
            this.hide();
        }
        else {
            this.show();
        }
    }
    show(event) {
        if (this.openValue)
            return;
        // Cancel any pending hide timeout
        this.cancelHideTimeout();
        this.openValue = true;
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            this.positionContent(event);
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "true");
        }
        // Add event listeners
        this.addEventListeners();
        // Allow subclasses to add custom show behavior
        this.showMenu(event);
        // Focus first item
        this.focusedIndex = -1;
        this.focusNextItem();
        this.dispatch("opened");
    }
    hide() {
        if (!this.openValue)
            return;
        this.openValue = false;
        // Remove event listeners immediately to prevent double-triggering
        this.removeEventListeners();
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            // Hide after animation completes
            this.hideTimeoutId = setTimeout(() => {
                if (!this.openValue && this.hasContentTarget) {
                    this.contentTarget.hidden = true;
                }
                this.hideTimeoutId = null;
                // Allow subclasses to add custom hide behavior
                this.hideMenu();
            }, this.hideDelayValue);
        }
        else {
            this.hideMenu();
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "false");
        }
        // Reset focus index
        this.focusedIndex = -1;
        this.dispatch("closed");
    }
    close() {
        this.hide();
    }
    selectItem(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        this.dispatch("select", { detail: { item } });
        this.hide();
    }
    // Event handling - clickOutside is called by stimulus-use
    clickOutside(event) {
        // Only close if menu is open and shouldCloseOnClickOutside returns true
        if (this.openValue && this.shouldCloseOnClickOutside(event)) {
            this.hide();
        }
    }
    handleKeydown(event) {
        switch (event.key) {
            case "Escape":
                this.hide();
                this.triggerTarget?.focus();
                break;
            case "ArrowDown":
                event.preventDefault();
                this.focusNextItem();
                break;
            case "ArrowUp":
                event.preventDefault();
                this.focusPreviousItem();
                break;
            case "Home":
                event.preventDefault();
                this.focusFirstItem();
                break;
            case "End":
                event.preventDefault();
                this.focusLastItem();
                break;
            case "Enter":
            case " ":
                event.preventDefault();
                this.selectFocusedItem();
                break;
        }
    }
    // Focus management
    focusNextItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = (this.focusedIndex + 1) % items.length;
        items[this.focusedIndex].focus();
    }
    focusPreviousItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = this.focusedIndex <= 0 ? items.length - 1 : this.focusedIndex - 1;
        items[this.focusedIndex].focus();
    }
    focusFirstItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = 0;
        items[0].focus();
    }
    focusLastItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = items.length - 1;
        items[this.focusedIndex].focus();
    }
    selectFocusedItem() {
        const items = this.enabledItems;
        if (this.focusedIndex >= 0 && this.focusedIndex < items.length) {
            items[this.focusedIndex].click();
        }
    }
    get enabledItems() {
        return this.itemTargets.filter((item) => item.dataset.disabled === undefined);
    }
    // Protected methods that subclasses can override
    /**
     * Position the content element. Override in subclasses for custom positioning.
     * @param {Event} event - The event that triggered the show (optional)
     */
    positionContent(event) {
        // Default: no positioning (subclasses should override)
    }
    /**
     * Called after showing the menu. Override in subclasses for additional behavior.
     * @param {Event} event - The event that triggered the show (optional)
     */
    showMenu(event) {
        // Default: no-op (subclasses can override)
    }
    /**
     * Called after hiding the menu. Override in subclasses for additional behavior.
     */
    hideMenu() {
        // Default: no-op (subclasses can override)
    }
    /**
     * Determine if the menu should close on click outside.
     * Override in subclasses for custom behavior (e.g., context menu).
     * @param {Event} event - The click event
     * @returns {boolean} - True if the menu should close
     */
    shouldCloseOnClickOutside(event) {
        // Default: close if clicking outside the entire element
        return !this.element.contains(event.target);
    }
    // Private helpers
    // Note: click outside is handled by stimulus-use's useClickOutside
    addEventListeners() {
        document.addEventListener("keydown", this.boundHandleKeydown);
    }
    removeEventListeners() {
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    cancelHideTimeout() {
        if (this.hideTimeoutId) {
            clearTimeout(this.hideTimeoutId);
            this.hideTimeoutId = null;
        }
    }
};

/**
 * Accordion controller for collapsible sections
 * Supports single and multiple expansion modes
 */
let default_1$u = class default_1 extends Controller {
    static { this.targets = ["item", "trigger", "content"]; }
    static { this.values = {
        type: { type: String, default: "single" }, // "single" or "multiple"
        collapsible: { type: Boolean, default: false },
        default: { type: String, default: "" } // comma-separated values for multiple
    }; }
    connect() {
        // Expand default items
        if (this.defaultValue) {
            const defaultValues = this.defaultValue.split(",").map((v) => v.trim());
            defaultValues.forEach((value) => {
                const item = this.findItemByValue(value);
                if (item) {
                    this.expandItem(item);
                }
            });
        }
    }
    toggle(event) {
        const trigger = event.currentTarget;
        const item = trigger.closest('[data-shadcn--accordion-target="item"]');
        if (!item)
            return;
        const isOpen = item.dataset.state === "open";
        if (isOpen) {
            if (this.collapsibleValue || this.typeValue === "multiple") {
                this.collapseItem(item);
            }
        }
        else {
            if (this.typeValue === "single") {
                // Collapse all other items first
                this.itemTargets.forEach((otherItem) => {
                    if (otherItem !== item && otherItem.dataset.state === "open") {
                        this.collapseItem(otherItem);
                    }
                });
            }
            this.expandItem(item);
        }
    }
    expandItem(item) {
        const trigger = item.querySelector('[data-shadcn--accordion-target="trigger"]');
        const content = item.querySelector('[data-shadcn--accordion-target="content"]');
        if (!trigger || !content)
            return;
        item.dataset.state = "open";
        trigger.dataset.state = "open";
        trigger.setAttribute("aria-expanded", "true");
        content.dataset.state = "open";
        content.hidden = false;
        // Animate height
        const height = content.scrollHeight;
        content.style.height = "0px";
        requestAnimationFrame(() => {
            content.style.height = `${height}px`;
            // Remove fixed height after animation
            setTimeout(() => {
                content.style.height = "";
            }, 200);
        });
        this.dispatch("expand", { detail: { value: item.dataset.value } });
    }
    collapseItem(item) {
        const trigger = item.querySelector('[data-shadcn--accordion-target="trigger"]');
        const content = item.querySelector('[data-shadcn--accordion-target="content"]');
        if (!trigger || !content)
            return;
        // Set current height for animation
        content.style.height = `${content.scrollHeight}px`;
        requestAnimationFrame(() => {
            item.dataset.state = "closed";
            trigger.dataset.state = "closed";
            trigger.setAttribute("aria-expanded", "false");
            content.dataset.state = "closed";
            content.style.height = "0px";
            setTimeout(() => {
                content.hidden = true;
                content.style.height = "";
            }, 200);
        });
        this.dispatch("collapse", { detail: { value: item.dataset.value } });
    }
    findItemByValue(value) {
        return this.itemTargets.find((item) => item.dataset.value === value);
    }
    // Keyboard navigation
    handleKeydown(event) {
        const triggers = this.triggerTargets;
        const currentIndex = triggers.findIndex((t) => t === document.activeElement);
        if (currentIndex === -1)
            return;
        let newIndex = currentIndex;
        switch (event.key) {
            case "ArrowUp":
                event.preventDefault();
                newIndex = currentIndex === 0 ? triggers.length - 1 : currentIndex - 1;
                break;
            case "ArrowDown":
                event.preventDefault();
                newIndex = currentIndex === triggers.length - 1 ? 0 : currentIndex + 1;
                break;
            case "Home":
                event.preventDefault();
                newIndex = 0;
                break;
            case "End":
                event.preventDefault();
                newIndex = triggers.length - 1;
                break;
            default:
                return;
        }
        triggers[newIndex].focus();
    }
};

/**
 * Avatar controller for handling image load errors
 */
let default_1$t = class default_1 extends Controller {
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
};

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
class CalendarController extends Controller {
    static { this.targets = ["grid", "monthYear", "monthSelect", "yearSelect", "day", "hiddenInput"]; }
    static { this.values = {
        month: String,
        selected: String,
        mode: { type: String, default: "single" }, // single, multiple, range
        minDate: String,
        maxDate: String,
        disabledDates: String, // comma-separated YYYY-MM-DD
        disabledDaysOfWeek: String, // comma-separated 0-6
        required: { type: Boolean, default: false },
        weekStartsOn: { type: Number, default: 0 }, // 0 = Sunday, 1 = Monday, etc.
        showOutsideDays: { type: Boolean, default: true } // Show days from prev/next month
    }; }
    static { this.MONTHS = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]; }
    static { this.WEEKDAYS = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]; }
    connect() {
        this.currentMonth = this.monthValue ? this.parseLocalDate(this.monthValue) : new Date();
        this.initializeSelection();
        this.focusedDate = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
    }
    disconnect() {
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    /**
     * Initialize selected date(s) based on mode
     */
    initializeSelection() {
        if (!this.selectedValue) {
            this.selectedDate = this.modeValue === "multiple" ? [] : null;
            this.rangeStart = null;
            this.rangeEnd = null;
            return;
        }
        switch (this.modeValue) {
            case "multiple":
                this.selectedDate = this.selectedValue.split(",").map((d) => this.parseLocalDate(d.trim())).filter(Boolean);
                break;
            case "range":
                const [start, end] = this.selectedValue.split(",").map((d) => this.parseLocalDate(d.trim()));
                this.rangeStart = start || null;
                this.rangeEnd = end || null;
                this.selectedDate = null;
                break;
            default:
                this.selectedDate = this.parseLocalDate(this.selectedValue);
        }
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
    /**
     * Check if a date is selected
     */
    isDateSelected(date) {
        if (this.modeValue === "multiple" && Array.isArray(this.selectedDate)) {
            return this.selectedDate.some(d => d.toDateString() === date.toDateString());
        }
        if (this.modeValue === "range") {
            if (this.rangeStart && date.toDateString() === this.rangeStart.toDateString())
                return true;
            if (this.rangeEnd && date.toDateString() === this.rangeEnd.toDateString())
                return true;
            return false;
        }
        return this.selectedDate && date.toDateString() === this.selectedDate.toDateString();
    }
    /**
     * Check if a date is in range (for range mode)
     */
    isDateInRange(date) {
        if (this.modeValue !== "range" || !this.rangeStart || !this.rangeEnd)
            return false;
        return date > this.rangeStart && date < this.rangeEnd;
    }
    /**
     * Check if date is the start of a range
     */
    isRangeStart(date) {
        if (this.modeValue !== "range" || !this.rangeStart)
            return false;
        return date.toDateString() === this.rangeStart.toDateString();
    }
    /**
     * Check if date is the end of a range
     */
    isRangeEnd(date) {
        if (this.modeValue !== "range" || !this.rangeEnd)
            return false;
        return date.toDateString() === this.rangeEnd.toDateString();
    }
    previousMonth() {
        this.currentMonth.setMonth(this.currentMonth.getMonth() - 1);
        this.render();
    }
    nextMonth() {
        this.currentMonth.setMonth(this.currentMonth.getMonth() + 1);
        this.render();
    }
    selectMonth(event) {
        const month = parseInt(event.target.value, 10);
        this.currentMonth.setMonth(month);
        this.render();
    }
    selectYear(event) {
        const year = parseInt(event.target.value, 10);
        this.currentMonth.setFullYear(year);
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
        switch (this.modeValue) {
            case "multiple":
                this.handleMultipleSelection(date, dateStr);
                break;
            case "range":
                this.handleRangeSelection(date, dateStr);
                break;
            default:
                this.handleSingleSelection(date, dateStr);
        }
        // Re-render to update selection styling
        this.render();
    }
    handleSingleSelection(date, dateStr) {
        // If required is true, don't allow deselection
        if (this.requiredValue && this.selectedDate && date.toDateString() === this.selectedDate.toDateString()) {
            return;
        }
        // Toggle selection if already selected
        if (this.selectedDate && date.toDateString() === this.selectedDate.toDateString()) {
            this.selectedDate = null;
            this.selectedValue = "";
            if (this.hasHiddenInputTarget) {
                this.hiddenInputTarget.value = "";
            }
            this.dispatchSelectEvent(null, "");
            return;
        }
        this.selectedDate = date;
        this.selectedValue = dateStr;
        if (this.hasHiddenInputTarget) {
            this.hiddenInputTarget.value = dateStr;
        }
        this.dispatchSelectEvent(date, dateStr);
    }
    handleMultipleSelection(date, dateStr) {
        const index = this.selectedDate.findIndex((d) => d.toDateString() === date.toDateString());
        if (index >= 0) {
            // Deselect if required allows it
            if (!this.requiredValue || this.selectedDate.length > 1) {
                this.selectedDate.splice(index, 1);
            }
        }
        else {
            this.selectedDate.push(date);
        }
        const dateStrings = this.selectedDate.map((d) => this.formatDateString(d));
        this.selectedValue = dateStrings.join(",");
        if (this.hasHiddenInputTarget) {
            this.hiddenInputTarget.value = this.selectedValue;
        }
        this.dispatch("select", {
            detail: {
                dates: this.selectedDate,
                dateStrings: dateStrings
            }
        });
    }
    handleRangeSelection(date, dateStr) {
        // If no start, set start
        if (!this.rangeStart) {
            this.rangeStart = date;
            this.rangeEnd = null;
            this.selectedValue = dateStr;
        }
        // If start exists but no end, set end (ensure start < end)
        else if (!this.rangeEnd) {
            if (date < this.rangeStart) {
                this.rangeEnd = this.rangeStart;
                this.rangeStart = date;
            }
            else if (date.toDateString() === this.rangeStart.toDateString()) {
                // Clicking same date resets
                this.rangeStart = null;
                this.selectedValue = "";
            }
            else {
                this.rangeEnd = date;
            }
            this.selectedValue = this.rangeStart
                ? `${this.formatDateString(this.rangeStart)}${this.rangeEnd ? `,${this.formatDateString(this.rangeEnd)}` : ""}`
                : "";
        }
        // If both exist, start new selection
        else {
            this.rangeStart = date;
            this.rangeEnd = null;
            this.selectedValue = dateStr;
        }
        if (this.hasHiddenInputTarget) {
            this.hiddenInputTarget.value = this.selectedValue;
        }
        this.dispatch("select", {
            detail: {
                rangeStart: this.rangeStart,
                rangeEnd: this.rangeEnd,
                dateString: this.selectedValue
            }
        });
    }
    dispatchSelectEvent(date, dateStr) {
        this.dispatch("select", {
            detail: {
                date: date,
                dateString: dateStr
            }
        });
    }
    /**
     * Handle keyboard navigation
     */
    handleKeydown(event) {
        if (!this.focusedDate) {
            this.focusedDate = this.getInitialFocusDate();
        }
        let newDate = new Date(this.focusedDate);
        let handled = false;
        switch (event.key) {
            case "ArrowLeft":
                newDate.setDate(newDate.getDate() - 1);
                handled = true;
                break;
            case "ArrowRight":
                newDate.setDate(newDate.getDate() + 1);
                handled = true;
                break;
            case "ArrowUp":
                newDate.setDate(newDate.getDate() - 7);
                handled = true;
                break;
            case "ArrowDown":
                newDate.setDate(newDate.getDate() + 7);
                handled = true;
                break;
            case "PageUp":
                if (event.shiftKey) {
                    newDate.setFullYear(newDate.getFullYear() - 1);
                }
                else {
                    newDate.setMonth(newDate.getMonth() - 1);
                }
                handled = true;
                break;
            case "PageDown":
                if (event.shiftKey) {
                    newDate.setFullYear(newDate.getFullYear() + 1);
                }
                else {
                    newDate.setMonth(newDate.getMonth() + 1);
                }
                handled = true;
                break;
            case "Home":
                newDate.setDate(1);
                handled = true;
                break;
            case "End":
                newDate = new Date(newDate.getFullYear(), newDate.getMonth() + 1, 0);
                handled = true;
                break;
            case "Enter":
            case " ":
                if (!this.isDateDisabled(this.focusedDate)) {
                    const dateStr = this.formatDateString(this.focusedDate);
                    switch (this.modeValue) {
                        case "multiple":
                            this.handleMultipleSelection(this.focusedDate, dateStr);
                            break;
                        case "range":
                            this.handleRangeSelection(this.focusedDate, dateStr);
                            break;
                        default:
                            this.handleSingleSelection(this.focusedDate, dateStr);
                    }
                    this.render();
                }
                handled = true;
                break;
        }
        if (handled) {
            event.preventDefault();
            // Skip disabled dates when navigating
            while (this.isDateDisabled(newDate)) {
                const direction = event.key.includes("Left") || event.key.includes("Up") ? -1 : 1;
                newDate.setDate(newDate.getDate() + direction);
            }
            this.focusedDate = newDate;
            // Update current month if focused date is in different month
            if (newDate.getMonth() !== this.currentMonth.getMonth() ||
                newDate.getFullYear() !== this.currentMonth.getFullYear()) {
                this.currentMonth = new Date(newDate.getFullYear(), newDate.getMonth(), 1);
            }
            this.render();
            this.focusDay(newDate);
        }
    }
    /**
     * Focus a specific day button
     */
    focusDay(date) {
        const dateStr = this.formatDateString(date);
        const dayButton = this.element.querySelector(`[data-date="${dateStr}"]`);
        if (dayButton) {
            dayButton.focus();
        }
    }
    /**
     * Enable keyboard navigation when calendar gets focus
     */
    enableKeyboard() {
        document.addEventListener("keydown", this.boundHandleKeydown);
        if (!this.focusedDate) {
            this.focusedDate = this.getInitialFocusDate();
        }
    }
    /**
     * Get an initial focus date based on selection mode
     */
    getInitialFocusDate() {
        switch (this.modeValue) {
            case "multiple":
                // For multiple mode, use first selected date or today
                return (Array.isArray(this.selectedDate) && this.selectedDate.length > 0)
                    ? this.selectedDate[0]
                    : new Date();
            case "range":
                // For range mode, use range start or today
                return this.rangeStart || new Date();
            default:
                // For single mode, use selected date or today
                return this.selectedDate || new Date();
        }
    }
    /**
     * Disable keyboard navigation
     */
    disableKeyboard() {
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    render() {
        // Update month/year label (for backwards compatibility)
        if (this.hasMonthYearTarget) {
            const monthName = CalendarController.MONTHS[this.currentMonth.getMonth()];
            const year = this.currentMonth.getFullYear();
            this.monthYearTarget.textContent = `${monthName} ${year}`;
        }
        // Update month select
        if (this.hasMonthSelectTarget) {
            this.monthSelectTarget.value = this.currentMonth.getMonth();
        }
        // Update year select
        if (this.hasYearSelectTarget) {
            this.yearSelectTarget.value = this.currentMonth.getFullYear();
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
        const currentDate = new Date(startDate);
        while (currentDate <= endDate) {
            const isOutside = currentDate.getMonth() !== month;
            const isToday = currentDate.getTime() === today.getTime();
            const isSelected = this.isDateSelected(currentDate);
            const isInRange = this.isDateInRange(currentDate);
            const isRangeStart = this.isRangeStart(currentDate);
            const isRangeEnd = this.isRangeEnd(currentDate);
            const isDisabled = this.isDateDisabled(currentDate);
            const isFocused = this.focusedDate && currentDate.toDateString() === this.focusedDate.toDateString();
            const dateStr = this.formatDateString(currentDate);
            // Skip outside days if showOutsideDays is false
            if (isOutside && !this.showOutsideDaysValue) {
                html += '<div class="h-8 w-8"></div>';
                currentDate.setDate(currentDate.getDate() + 1);
                continue;
            }
            let classes = "h-8 w-8 text-center text-sm p-0 relative flex items-center justify-center focus:outline-none focus:ring-1 focus:ring-ring";
            // Range styling
            if (isInRange) {
                classes += " bg-accent/50";
            }
            if (isRangeStart) {
                classes += " rounded-l-md";
            }
            if (isRangeEnd) {
                classes += " rounded-r-md";
            }
            if (!isRangeStart && !isRangeEnd && !isInRange) {
                classes += " rounded-md";
            }
            // Selection and state styling
            if (isDisabled) {
                classes += " text-muted-foreground opacity-50 cursor-not-allowed";
            }
            else if (isSelected) {
                classes += " bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground cursor-pointer";
            }
            else if (isToday && !isInRange) {
                classes += " bg-accent text-accent-foreground cursor-pointer hover:bg-accent hover:text-accent-foreground";
            }
            else if (!isInRange) {
                classes += " cursor-pointer hover:bg-accent hover:text-accent-foreground";
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
            if (isFocused)
                ariaAttrs.push('tabindex="0"');
            else
                ariaAttrs.push('tabindex="-1"');
            // Only add click action for non-disabled days
            const dataAction = isDisabled
                ? 'data-action="focus->shadcn--calendar#enableKeyboard blur->shadcn--calendar#disableKeyboard"'
                : 'data-action="click->shadcn--calendar#selectDay focus->shadcn--calendar#enableKeyboard blur->shadcn--calendar#disableKeyboard"';
            html += `<button type="button" class="${classes}" data-date="${dateStr}" data-shadcn--calendar-target="day" ${dataAction} ${ariaAttrs.join(" ")}>${currentDate.getDate()}</button>`;
            currentDate.setDate(currentDate.getDate() + 1);
        }
        return html;
    }
    /**
     * Go to today's date
     */
    goToToday() {
        const today = new Date();
        this.currentMonth = new Date(today.getFullYear(), today.getMonth(), 1);
        this.focusedDate = today;
        this.render();
    }
    monthValueChanged() {
        if (this.monthValue) {
            this.currentMonth = this.parseLocalDate(this.monthValue);
        }
    }
    selectedValueChanged() {
        this.initializeSelection();
    }
}

/**
 * Carousel controller for sliding content
 * Handles navigation, autoplay, keyboard navigation, and touch/swipe
 */
let default_1$s = class default_1 extends Controller {
    static { this.targets = ["viewport", "content", "item", "prevButton", "nextButton"]; }
    static { this.values = {
        orientation: { type: String, default: "horizontal" },
        loop: { type: Boolean, default: false },
        autoplay: { type: Boolean, default: false },
        autoplayInterval: { type: Number, default: 4000 },
        align: { type: String, default: "start" },
        selectedIndex: { type: Number, default: 0 }
    }; }
    connect() {
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        this.element.addEventListener("keydown", this.boundHandleKeydown);
        // Touch/swipe support
        this.touchStartX = 0;
        this.touchStartY = 0;
        this.boundHandleTouchStart = this.handleTouchStart.bind(this);
        this.boundHandleTouchEnd = this.handleTouchEnd.bind(this);
        if (this.hasViewportTarget) {
            this.viewportTarget.addEventListener("touchstart", this.boundHandleTouchStart, { passive: true });
            this.viewportTarget.addEventListener("touchend", this.boundHandleTouchEnd, { passive: true });
        }
        // Set initial state
        this.updateButtonStates();
        this.scrollToIndex(this.selectedIndexValue, false);
        // Start autoplay if enabled
        if (this.autoplayValue) {
            this.startAutoplay();
        }
    }
    disconnect() {
        this.element.removeEventListener("keydown", this.boundHandleKeydown);
        if (this.hasViewportTarget) {
            this.viewportTarget.removeEventListener("touchstart", this.boundHandleTouchStart);
            this.viewportTarget.removeEventListener("touchend", this.boundHandleTouchEnd);
        }
        this.stopAutoplay();
    }
    previous() {
        const newIndex = this.selectedIndexValue - 1;
        if (newIndex < 0) {
            if (this.loopValue) {
                this.selectedIndexValue = this.itemTargets.length - 1;
            }
        }
        else {
            this.selectedIndexValue = newIndex;
        }
        this.scrollToIndex(this.selectedIndexValue);
        this.dispatch("select", { detail: { index: this.selectedIndexValue } });
    }
    next() {
        const newIndex = this.selectedIndexValue + 1;
        const maxIndex = this.itemTargets.length - 1;
        if (newIndex > maxIndex) {
            if (this.loopValue) {
                this.selectedIndexValue = 0;
            }
        }
        else {
            this.selectedIndexValue = newIndex;
        }
        this.scrollToIndex(this.selectedIndexValue);
        this.dispatch("select", { detail: { index: this.selectedIndexValue } });
    }
    goToSlide(event) {
        const index = parseInt(event.currentTarget.dataset.index, 10);
        if (!isNaN(index) && index >= 0 && index < this.itemTargets.length) {
            this.selectedIndexValue = index;
            this.scrollToIndex(index);
            this.dispatch("select", { detail: { index } });
        }
    }
    scrollToIndex(index, animate = true) {
        if (!this.hasContentTarget || !this.itemTargets.length)
            return;
        const item = this.itemTargets[index];
        if (!item)
            return;
        const isHorizontal = this.orientationValue === "horizontal";
        // Calculate scroll position
        let scrollPosition;
        if (isHorizontal) {
            scrollPosition = item.offsetLeft - this.getAlignOffset(item, "width");
        }
        else {
            scrollPosition = item.offsetTop - this.getAlignOffset(item, "height");
        }
        // Apply scroll
        if (animate) {
            this.contentTarget.style.transition = "transform 0.3s ease-out";
        }
        else {
            this.contentTarget.style.transition = "none";
        }
        if (isHorizontal) {
            this.contentTarget.style.transform = `translateX(-${scrollPosition}px)`;
        }
        else {
            this.contentTarget.style.transform = `translateY(-${scrollPosition}px)`;
        }
        // Update ARIA attributes
        this.itemTargets.forEach((target, i) => {
            target.setAttribute("aria-hidden", String(i !== index));
            target.inert = i !== index;
        });
        this.updateButtonStates();
    }
    getAlignOffset(item, dimension) {
        if (this.alignValue === "center") {
            const viewportSize = dimension === "width"
                ? this.viewportTarget.offsetWidth
                : this.viewportTarget.offsetHeight;
            const itemSize = dimension === "width"
                ? item.offsetWidth
                : item.offsetHeight;
            return (viewportSize - itemSize) / 2;
        }
        else if (this.alignValue === "end") {
            const viewportSize = dimension === "width"
                ? this.viewportTarget.offsetWidth
                : this.viewportTarget.offsetHeight;
            const itemSize = dimension === "width"
                ? item.offsetWidth
                : item.offsetHeight;
            return viewportSize - itemSize;
        }
        return 0; // start alignment
    }
    updateButtonStates() {
        const atStart = this.selectedIndexValue === 0;
        const atEnd = this.selectedIndexValue === this.itemTargets.length - 1;
        if (this.hasPrevButtonTarget) {
            this.prevButtonTarget.disabled = !this.loopValue && atStart;
        }
        if (this.hasNextButtonTarget) {
            this.nextButtonTarget.disabled = !this.loopValue && atEnd;
        }
    }
    handleKeydown(event) {
        const isHorizontal = this.orientationValue === "horizontal";
        if (isHorizontal) {
            if (event.key === "ArrowLeft") {
                event.preventDefault();
                this.previous();
            }
            else if (event.key === "ArrowRight") {
                event.preventDefault();
                this.next();
            }
        }
        else {
            if (event.key === "ArrowUp") {
                event.preventDefault();
                this.previous();
            }
            else if (event.key === "ArrowDown") {
                event.preventDefault();
                this.next();
            }
        }
    }
    handleTouchStart(event) {
        this.touchStartX = event.touches[0].clientX;
        this.touchStartY = event.touches[0].clientY;
        // Pause autoplay on interaction
        if (this.autoplayValue) {
            this.stopAutoplay();
        }
    }
    handleTouchEnd(event) {
        const touchEndX = event.changedTouches[0].clientX;
        const touchEndY = event.changedTouches[0].clientY;
        const deltaX = touchEndX - this.touchStartX;
        const deltaY = touchEndY - this.touchStartY;
        const isHorizontal = this.orientationValue === "horizontal";
        const threshold = 50;
        if (isHorizontal) {
            if (Math.abs(deltaX) > threshold && Math.abs(deltaX) > Math.abs(deltaY)) {
                if (deltaX > 0) {
                    this.previous();
                }
                else {
                    this.next();
                }
            }
        }
        else {
            if (Math.abs(deltaY) > threshold && Math.abs(deltaY) > Math.abs(deltaX)) {
                if (deltaY > 0) {
                    this.previous();
                }
                else {
                    this.next();
                }
            }
        }
        // Resume autoplay after interaction
        if (this.autoplayValue) {
            this.startAutoplay();
        }
    }
    startAutoplay() {
        this.stopAutoplay();
        this.autoplayTimer = setInterval(() => {
            this.next();
        }, this.autoplayIntervalValue);
    }
    stopAutoplay() {
        if (this.autoplayTimer) {
            clearInterval(this.autoplayTimer);
            this.autoplayTimer = null;
        }
    }
    // Pause autoplay when mouse enters
    mouseEnter() {
        if (this.autoplayValue) {
            this.stopAutoplay();
        }
    }
    // Resume autoplay when mouse leaves
    mouseLeave() {
        if (this.autoplayValue) {
            this.startAutoplay();
        }
    }
    selectedIndexValueChanged() {
        this.scrollToIndex(this.selectedIndexValue);
    }
};

const DEFAULT_SERIES_COUNT = 5;
function normalizeChartType(type) {
    switch (type) {
        case "bar":
            return "bar";
        case "line":
        case "area":
            return "line";
        case "pie":
            return "pie";
        case "donut":
            return "doughnut";
        default:
            return "bar";
    }
}
function cssVariableName(key) {
    const normalized = key
        .trim()
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
    return normalized || "series";
}
function defaultChartColor(index) {
    return `hsl(var(--chart-${(index % DEFAULT_SERIES_COUNT) + 1}))`;
}
function resolveCssColor(element, value) {
    const trimmed = value.trim();
    const variableMatch = trimmed.match(/^var\((--[^)]+)\)$/);
    if (!variableMatch)
        return trimmed;
    const resolved = getComputedStyle(element).getPropertyValue(variableMatch[1]).trim();
    return resolved || trimmed;
}
function seriesKey(dataset, index) {
    if (typeof dataset.key === "string" && dataset.key.length > 0)
        return dataset.key;
    if (typeof dataset.label === "string" && dataset.label.length > 0)
        return dataset.label;
    return `series-${index + 1}`;
}
function seriesLabel(dataset, config, index) {
    const key = seriesKey(dataset, index);
    return config[key]?.label || dataset.label || key;
}
function seriesColor(element, dataset, config, index) {
    const key = seriesKey(dataset, index);
    const cssVariable = `var(--color-${cssVariableName(key)})`;
    const configured = config[key]?.color || cssVariable;
    const resolved = resolveCssColor(element, configured);
    return resolved === cssVariable ? defaultChartColor(index) : resolved;
}
function buildLegendItems(element, type, data, config) {
    if (type === "pie" || type === "donut") {
        return (data.labels || []).map((label, index) => ({
            label: config[label]?.label || label,
            color: resolveLegendColor(element, config[label]?.color || `var(--color-${cssVariableName(label)})`, index),
            datasetIndex: 0,
            dataIndex: index
        }));
    }
    return (data.datasets || []).map((dataset, index) => ({
        label: seriesLabel(dataset, config, index),
        color: seriesColor(element, dataset, config, index),
        datasetIndex: index
    }));
}
function resolveLegendColor(element, color, index) {
    const resolved = resolveCssColor(element, color);
    return resolved === color && color.startsWith("var(") ? defaultChartColor(index) : resolved;
}
function buildChartData(element, type, data, config) {
    const isCircular = type === "pie" || type === "donut";
    return {
        ...data,
        datasets: (data.datasets || []).map((dataset, index) => {
            const color = seriesColor(element, dataset, config, index);
            const label = seriesLabel(dataset, config, index);
            if (isCircular) {
                const labels = data.labels || [];
                const colors = labels.map((labelKey, labelIndex) => {
                    const labelConfig = config[labelKey];
                    const configured = labelConfig?.color || `var(--color-${cssVariableName(labelKey)})`;
                    const resolved = resolveCssColor(element, configured);
                    return resolved === configured && configured.startsWith("var(")
                        ? defaultChartColor(labelIndex)
                        : resolved;
                });
                return {
                    ...dataset,
                    label,
                    backgroundColor: colors.length > 0 ? colors : color,
                    borderColor: "hsl(var(--background))"
                };
            }
            return {
                ...dataset,
                label,
                borderColor: color,
                backgroundColor: type === "area" ? color : dataset.backgroundColor || color,
                pointBackgroundColor: color,
                pointBorderColor: color,
                fill: type === "area" ? true : dataset.fill,
                tension: typeof dataset.tension === "number" ? dataset.tension : 0.4
            };
        })
    };
}
function buildChartOptions({ renderTooltip }) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
            intersect: false,
            mode: "index"
        },
        plugins: {
            legend: {
                display: false
            },
            tooltip: {
                enabled: false,
                external: renderTooltip
            }
        },
        scales: {
            x: {
                border: {
                    display: false
                },
                grid: {
                    display: false
                },
                ticks: {
                    color: "hsl(var(--muted-foreground))"
                }
            },
            y: {
                border: {
                    display: false
                },
                grid: {
                    color: "hsl(var(--border))"
                },
                ticks: {
                    color: "hsl(var(--muted-foreground))"
                }
            }
        },
        animation: {}
    };
}

const loadChartJs = () => import('chart.js/auto');
const INSTALL_MESSAGE = "Chart.js is required for Shadcn::ChartComponent. Install and pin it with: npm install chart.js@^4.5.1";
let default_1$r = class default_1 extends Controller {
    constructor() {
        super(...arguments);
        this.chart = null;
        this.renderToken = 0;
        this.themeObserver = null;
        this.boundBeforeCache = () => this.destroyChart();
    }
    static { this.targets = ["canvas", "tooltip", "legend"]; }
    static { this.values = {
        type: String,
        data: Object,
        config: Object
    }; }
    connect() {
        document.addEventListener("turbo:before-cache", this.boundBeforeCache);
        this.themeObserver = new MutationObserver(() => this.renderChart());
        this.themeObserver.observe(document.documentElement, {
            attributes: true,
            attributeFilter: ["class"]
        });
        this.renderChart();
    }
    disconnect() {
        document.removeEventListener("turbo:before-cache", this.boundBeforeCache);
        this.themeObserver?.disconnect();
        this.themeObserver = null;
        this.destroyChart();
    }
    async renderChart() {
        const token = this.renderToken + 1;
        this.renderToken = token;
        this.destroyChart();
        this.clearMessage();
        try {
            const chartJs = await loadChartJs();
            if (token !== this.renderToken)
                return;
            const context = this.canvasTarget.getContext("2d");
            if (!context) {
                this.showMessage("Chart canvas is not available in this browser.");
                return;
            }
            const chartData = buildChartData(this.element, this.typeValue, this.dataValue, this.configValue);
            const options = buildChartOptions({
                renderTooltip: this.renderTooltip.bind(this)
            });
            this.chart = new chartJs.default(context, {
                type: normalizeChartType(this.typeValue),
                data: chartData,
                options
            });
            this.renderLegend(buildLegendItems(this.element, this.typeValue, chartData, this.configValue));
        }
        catch (error) {
            this.showMessage(missingChartJsError(error) ? INSTALL_MESSAGE : "Unable to render chart.");
        }
    }
    destroyChart() {
        if (!this.chart)
            return;
        this.chart.destroy();
        this.chart = null;
    }
    renderTooltip(context) {
        const { tooltip } = context;
        if (tooltip.opacity === 0) {
            this.tooltipTarget.classList.add("hidden");
            return;
        }
        const title = tooltip.title || [];
        const rows = (tooltip.body || []).flatMap((body, index) => {
            const color = tooltip.labelColors?.[index]?.backgroundColor || tooltip.labelColors?.[index]?.borderColor || "hsl(var(--border))";
            return body.lines.map((line) => ({ line, color }));
        });
        this.tooltipTarget.innerHTML = [
            ...title.map((line) => `<div class="mb-1 font-medium text-foreground">${escapeHtml(line)}</div>`),
            ...rows.map((row) => `
        <div class="flex items-center gap-2">
          <span class="h-2.5 w-2.5 shrink-0 rounded-[2px]" style="background-color: ${escapeHtml(row.color)}"></span>
          <span class="text-muted-foreground">${escapeHtml(row.line)}</span>
        </div>
      `)
        ].join("");
        this.tooltipTarget.style.left = `${tooltip.caretX}px`;
        this.tooltipTarget.style.top = `${tooltip.caretY}px`;
        this.tooltipTarget.classList.remove("hidden");
    }
    renderLegend(items) {
        if (items.length === 0) {
            this.legendTarget.innerHTML = "";
            return;
        }
        this.legendTarget.innerHTML = items.map((item) => `
      <div class="flex items-center gap-2">
        <span class="h-2.5 w-2.5 shrink-0 rounded-[2px]" style="background-color: ${escapeHtml(item.color)}"></span>
        <span>${escapeHtml(item.label)}</span>
      </div>
    `).join("");
    }
    showMessage(message) {
        this.legendTarget.innerHTML = `<p class="text-sm text-muted-foreground">${escapeHtml(message)}</p>`;
    }
    clearMessage() {
        this.tooltipTarget.classList.add("hidden");
        this.tooltipTarget.innerHTML = "";
        this.legendTarget.innerHTML = "";
    }
};
function missingChartJsError(error) {
    if (!(error instanceof Error))
        return true;
    return error.message.includes("chart.js") || error.message.includes("Failed to resolve module");
}
function escapeHtml(value) {
    const div = document.createElement("div");
    div.textContent = value;
    return div.innerHTML;
}

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
class DatePickerController extends Controller {
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
        const currentDate = new Date(startDate);
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
                html += '<div class="h-8 w-8"></div>';
                currentDate.setDate(currentDate.getDate() + 1);
                continue;
            }
            let classes = "h-8 w-8 text-center text-sm p-0 relative flex items-center justify-center rounded-md focus:outline-none focus:ring-1 focus:ring-ring";
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
            // Only add click action for non-disabled days
            const dataAction = isDisabled
                ? ''
                : 'data-action="click->shadcn--date-picker#selectDay"';
            html += `<button type="button" class="${classes}" data-date="${dateStr}" data-shadcn--date-picker-target="day" ${dataAction} ${ariaAttrs.join(" ")}>${currentDate.getDate()}</button>`;
            currentDate.setDate(currentDate.getDate() + 1);
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

/**
 * Checkbox controller for custom checkboxes
 */
let default_1$q = class default_1 extends Controller {
    static { this.values = {
        checked: { type: Boolean, default: false },
        name: String
    }; }
    connect() {
        this.updateState();
    }
    toggle() {
        this.checkedValue = !this.checkedValue;
        this.updateState();
        this.updateHiddenInput();
        this.dispatch("change", { detail: { checked: this.checkedValue } });
    }
    updateState() {
        const state = this.checkedValue ? "checked" : "unchecked";
        this.element.dataset.state = state;
        this.element.setAttribute("aria-checked", this.checkedValue.toString());
        // Update checkmark visibility
        const checkIcon = this.element.querySelector("svg");
        if (checkIcon) {
            checkIcon.style.opacity = this.checkedValue ? "1" : "0";
        }
    }
    updateHiddenInput() {
        if (!this.nameValue)
            return;
        // Find or create hidden input
        let input = this.element.parentElement?.querySelector(`input[name="${this.nameValue}"]`);
        if (input) {
            input.value = this.checkedValue ? "1" : "0";
        }
    }
    checkedValueChanged() {
        this.updateState();
    }
};

/**
 * Collapsible controller for expandable content
 */
let default_1$p = class default_1 extends Controller {
    static { this.targets = ["trigger", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        disabled: { type: Boolean, default: false }
    }; }
    connect() {
        this.updateState();
    }
    toggle() {
        if (this.disabledValue)
            return;
        this.openValue = !this.openValue;
        this.updateState();
    }
    open() {
        if (this.disabledValue)
            return;
        this.openValue = true;
        this.updateState();
    }
    close() {
        this.openValue = false;
        this.updateState();
    }
    updateState() {
        const state = this.openValue ? "open" : "closed";
        this.element.dataset.state = state;
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = state;
            if (this.openValue) {
                this.contentTarget.hidden = false;
                // Animate open
                const height = this.contentTarget.scrollHeight;
                this.contentTarget.style.height = "0px";
                requestAnimationFrame(() => {
                    this.contentTarget.style.height = `${height}px`;
                    setTimeout(() => {
                        this.contentTarget.style.height = "";
                    }, 200);
                });
            }
            else {
                // Animate close
                this.contentTarget.style.height = `${this.contentTarget.scrollHeight}px`;
                requestAnimationFrame(() => {
                    this.contentTarget.style.height = "0px";
                    setTimeout(() => {
                        this.contentTarget.hidden = true;
                        this.contentTarget.style.height = "";
                    }, 200);
                });
            }
        }
        this.dispatch(this.openValue ? "opened" : "closed");
    }
    openValueChanged() {
        this.updateState();
    }
};

/**
 * Custom positioning reference element.
 * @see https://floating-ui.com/docs/virtual-elements
 */

const min = Math.min;
const max = Math.max;
const round = Math.round;
const floor = Math.floor;
const createCoords = v => ({
  x: v,
  y: v
});
const oppositeSideMap = {
  left: 'right',
  right: 'left',
  bottom: 'top',
  top: 'bottom'
};
function clamp(start, value, end) {
  return max(start, min(value, end));
}
function evaluate(value, param) {
  return typeof value === 'function' ? value(param) : value;
}
function getSide(placement) {
  return placement.split('-')[0];
}
function getAlignment(placement) {
  return placement.split('-')[1];
}
function getOppositeAxis(axis) {
  return axis === 'x' ? 'y' : 'x';
}
function getAxisLength(axis) {
  return axis === 'y' ? 'height' : 'width';
}
function getSideAxis(placement) {
  const firstChar = placement[0];
  return firstChar === 't' || firstChar === 'b' ? 'y' : 'x';
}
function getAlignmentAxis(placement) {
  return getOppositeAxis(getSideAxis(placement));
}
function getAlignmentSides(placement, rects, rtl) {
  if (rtl === void 0) {
    rtl = false;
  }
  const alignment = getAlignment(placement);
  const alignmentAxis = getAlignmentAxis(placement);
  const length = getAxisLength(alignmentAxis);
  let mainAlignmentSide = alignmentAxis === 'x' ? alignment === (rtl ? 'end' : 'start') ? 'right' : 'left' : alignment === 'start' ? 'bottom' : 'top';
  if (rects.reference[length] > rects.floating[length]) {
    mainAlignmentSide = getOppositePlacement(mainAlignmentSide);
  }
  return [mainAlignmentSide, getOppositePlacement(mainAlignmentSide)];
}
function getExpandedPlacements(placement) {
  const oppositePlacement = getOppositePlacement(placement);
  return [getOppositeAlignmentPlacement(placement), oppositePlacement, getOppositeAlignmentPlacement(oppositePlacement)];
}
function getOppositeAlignmentPlacement(placement) {
  return placement.includes('start') ? placement.replace('start', 'end') : placement.replace('end', 'start');
}
const lrPlacement = ['left', 'right'];
const rlPlacement = ['right', 'left'];
const tbPlacement = ['top', 'bottom'];
const btPlacement = ['bottom', 'top'];
function getSideList(side, isStart, rtl) {
  switch (side) {
    case 'top':
    case 'bottom':
      if (rtl) return isStart ? rlPlacement : lrPlacement;
      return isStart ? lrPlacement : rlPlacement;
    case 'left':
    case 'right':
      return isStart ? tbPlacement : btPlacement;
    default:
      return [];
  }
}
function getOppositeAxisPlacements(placement, flipAlignment, direction, rtl) {
  const alignment = getAlignment(placement);
  let list = getSideList(getSide(placement), direction === 'start', rtl);
  if (alignment) {
    list = list.map(side => side + "-" + alignment);
    if (flipAlignment) {
      list = list.concat(list.map(getOppositeAlignmentPlacement));
    }
  }
  return list;
}
function getOppositePlacement(placement) {
  const side = getSide(placement);
  return oppositeSideMap[side] + placement.slice(side.length);
}
function expandPaddingObject(padding) {
  var _padding$top, _padding$right, _padding$bottom, _padding$left;
  return {
    top: (_padding$top = padding.top) != null ? _padding$top : 0,
    right: (_padding$right = padding.right) != null ? _padding$right : 0,
    bottom: (_padding$bottom = padding.bottom) != null ? _padding$bottom : 0,
    left: (_padding$left = padding.left) != null ? _padding$left : 0
  };
}
function getPaddingObject(padding) {
  return typeof padding !== 'number' ? expandPaddingObject(padding) : {
    top: padding,
    right: padding,
    bottom: padding,
    left: padding
  };
}
function rectToClientRect(rect) {
  const {
    x,
    y,
    width,
    height
  } = rect;
  return {
    width,
    height,
    top: y,
    left: x,
    right: x + width,
    bottom: y + height,
    x,
    y
  };
}

function computeCoordsFromPlacement(_ref, placement, rtl) {
  let {
    reference,
    floating
  } = _ref;
  const sideAxis = getSideAxis(placement);
  const alignmentAxis = getAlignmentAxis(placement);
  const alignLength = getAxisLength(alignmentAxis);
  const side = getSide(placement);
  const isVertical = sideAxis === 'y';
  const commonX = reference.x + reference.width / 2 - floating.width / 2;
  const commonY = reference.y + reference.height / 2 - floating.height / 2;
  const commonAlign = reference[alignLength] / 2 - floating[alignLength] / 2;
  let coords;
  switch (side) {
    case 'top':
      coords = {
        x: commonX,
        y: reference.y - floating.height
      };
      break;
    case 'bottom':
      coords = {
        x: commonX,
        y: reference.y + reference.height
      };
      break;
    case 'right':
      coords = {
        x: reference.x + reference.width,
        y: commonY
      };
      break;
    case 'left':
      coords = {
        x: reference.x - floating.width,
        y: commonY
      };
      break;
    default:
      coords = {
        x: reference.x,
        y: reference.y
      };
  }
  const alignment = getAlignment(placement);
  if (alignment) {
    coords[alignmentAxis] += commonAlign * (alignment === 'end' ? 1 : -1) * (rtl && isVertical ? -1 : 1);
  }
  return coords;
}

/**
 * Resolves with an object of overflow side offsets that determine how much the
 * element is overflowing a given clipping boundary on each side.
 * - positive = overflowing the boundary by that number of pixels
 * - negative = how many pixels left before it will overflow
 * - 0 = lies flush with the boundary
 * @see https://floating-ui.com/docs/detectOverflow
 */
async function detectOverflow(state, options) {
  var _await$platform$isEle;
  if (options === void 0) {
    options = {};
  }
  const {
    x,
    y,
    platform,
    rects,
    elements,
    strategy
  } = state;
  const {
    boundary = 'clippingAncestors',
    rootBoundary = 'viewport',
    elementContext = 'floating',
    altBoundary = false,
    padding = 0
  } = evaluate(options, state);
  const paddingObject = getPaddingObject(padding);
  const altContext = elementContext === 'floating' ? 'reference' : 'floating';
  const element = elements[altBoundary ? altContext : elementContext];
  const clippingClientRect = rectToClientRect(await platform.getClippingRect({
    element: ((_await$platform$isEle = await (platform.isElement == null ? void 0 : platform.isElement(element))) != null ? _await$platform$isEle : true) ? element : element.contextElement || (await (platform.getDocumentElement == null ? void 0 : platform.getDocumentElement(elements.floating))),
    boundary,
    rootBoundary,
    strategy
  }));
  const rect = elementContext === 'floating' ? {
    x,
    y,
    width: rects.floating.width,
    height: rects.floating.height
  } : rects.reference;
  const offsetParent = await (platform.getOffsetParent == null ? void 0 : platform.getOffsetParent(elements.floating));
  const offsetScale = (await (platform.isElement == null ? void 0 : platform.isElement(offsetParent))) && (await (platform.getScale == null ? void 0 : platform.getScale(offsetParent))) || {
    x: 1,
    y: 1
  };
  const elementClientRect = rectToClientRect(platform.convertOffsetParentRelativeRectToViewportRelativeRect ? await platform.convertOffsetParentRelativeRectToViewportRelativeRect({
    elements,
    rect,
    offsetParent,
    strategy
  }) : rect);
  return {
    top: (clippingClientRect.top - elementClientRect.top + paddingObject.top) / offsetScale.y,
    bottom: (elementClientRect.bottom - clippingClientRect.bottom + paddingObject.bottom) / offsetScale.y,
    left: (clippingClientRect.left - elementClientRect.left + paddingObject.left) / offsetScale.x,
    right: (elementClientRect.right - clippingClientRect.right + paddingObject.right) / offsetScale.x
  };
}

// Maximum number of resets that can occur before bailing to avoid infinite reset loops.
const MAX_RESET_COUNT = 50;

/**
 * Computes the `x` and `y` coordinates that will place the floating element
 * next to a given reference element.
 *
 * This export does not have any `platform` interface logic. You will need to
 * write one for the platform you are using Floating UI with.
 */
const computePosition$1 = async (reference, floating, config) => {
  const {
    placement = 'bottom',
    strategy = 'absolute',
    middleware = [],
    platform
  } = config;
  const platformWithDetectOverflow = platform.detectOverflow ? platform : {
    ...platform,
    detectOverflow
  };
  const rtl = await (platform.isRTL == null ? void 0 : platform.isRTL(floating));
  let rects = await platform.getElementRects({
    reference,
    floating,
    strategy
  });
  let {
    x,
    y
  } = computeCoordsFromPlacement(rects, placement, rtl);
  let statefulPlacement = placement;
  let resetCount = 0;
  const middlewareData = {};
  for (let i = 0; i < middleware.length; i++) {
    const currentMiddleware = middleware[i];
    if (!currentMiddleware) {
      continue;
    }
    const {
      name,
      fn
    } = currentMiddleware;
    const {
      x: nextX,
      y: nextY,
      data,
      reset
    } = await fn({
      x,
      y,
      initialPlacement: placement,
      placement: statefulPlacement,
      strategy,
      middlewareData,
      rects,
      platform: platformWithDetectOverflow,
      elements: {
        reference,
        floating
      }
    });
    x = nextX != null ? nextX : x;
    y = nextY != null ? nextY : y;
    middlewareData[name] = {
      ...middlewareData[name],
      ...data
    };
    if (reset && resetCount < MAX_RESET_COUNT) {
      resetCount++;
      if (typeof reset === 'object') {
        if (reset.placement) {
          statefulPlacement = reset.placement;
        }
        if (reset.rects) {
          rects = reset.rects === true ? await platform.getElementRects({
            reference,
            floating,
            strategy
          }) : reset.rects;
        }
        ({
          x,
          y
        } = computeCoordsFromPlacement(rects, statefulPlacement, rtl));
      }
      i = -1;
    }
  }
  return {
    x,
    y,
    placement: statefulPlacement,
    strategy,
    middlewareData
  };
};

/**
 * Optimizes the visibility of the floating element by flipping the `placement`
 * in order to keep it in view when the preferred placement(s) will overflow the
 * clipping boundary. Alternative to `autoPlacement`.
 * @see https://floating-ui.com/docs/flip
 */
const flip$1 = function (options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: 'flip',
    options,
    async fn(state) {
      var _middlewareData$arrow, _middlewareData$flip;
      const {
        placement,
        middlewareData,
        rects,
        initialPlacement,
        platform,
        elements
      } = state;
      const {
        mainAxis: checkMainAxis = true,
        crossAxis: checkCrossAxis = true,
        fallbackPlacements: specifiedFallbackPlacements,
        fallbackStrategy = 'bestFit',
        fallbackAxisSideDirection = 'none',
        flipAlignment = true,
        ...detectOverflowOptions
      } = evaluate(options, state);

      // If a reset by the arrow was caused due to an alignment offset being
      // added, we should skip any logic now since `flip()` has already done its
      // work.
      // https://github.com/floating-ui/floating-ui/issues/2549#issuecomment-1719601643
      if ((_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
        return {};
      }
      const side = getSide(placement);
      const initialSideAxis = getSideAxis(initialPlacement);
      const isBasePlacement = getSide(initialPlacement) === initialPlacement;
      const rtl = await (platform.isRTL == null ? void 0 : platform.isRTL(elements.floating));
      const fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipAlignment ? [getOppositePlacement(initialPlacement)] : getExpandedPlacements(initialPlacement));
      const hasFallbackAxisSideDirection = fallbackAxisSideDirection !== 'none';
      if (!specifiedFallbackPlacements && hasFallbackAxisSideDirection) {
        fallbackPlacements.push(...getOppositeAxisPlacements(initialPlacement, flipAlignment, fallbackAxisSideDirection, rtl));
      }
      const placements = [initialPlacement, ...fallbackPlacements];
      const overflow = await platform.detectOverflow(state, detectOverflowOptions);
      const overflows = [];
      let overflowsData = ((_middlewareData$flip = middlewareData.flip) == null ? void 0 : _middlewareData$flip.overflows) || [];
      if (checkMainAxis) {
        overflows.push(overflow[side]);
      }
      if (checkCrossAxis) {
        const sides = getAlignmentSides(placement, rects, rtl);
        overflows.push(overflow[sides[0]], overflow[sides[1]]);
      }
      overflowsData = [...overflowsData, {
        placement,
        overflows
      }];

      // One or more sides is overflowing.
      if (!overflows.every(side => side <= 0)) {
        var _middlewareData$flip2, _overflowsData$filter;
        const nextIndex = (((_middlewareData$flip2 = middlewareData.flip) == null ? void 0 : _middlewareData$flip2.index) || 0) + 1;
        const nextPlacement = placements[nextIndex];
        if (nextPlacement) {
          const ignoreCrossAxisOverflow = checkCrossAxis === 'alignment' ? initialSideAxis !== getSideAxis(nextPlacement) : false;
          if (!ignoreCrossAxisOverflow ||
          // We leave the current main axis only if every placement on that axis
          // overflows the main axis.
          overflowsData.every(d => getSideAxis(d.placement) === initialSideAxis ? d.overflows[0] > 0 : true)) {
            // Try next placement and re-run the lifecycle.
            return {
              data: {
                index: nextIndex,
                overflows: overflowsData
              },
              reset: {
                placement: nextPlacement
              }
            };
          }
        }

        // First, find the candidates that fit on the mainAxis side of overflow,
        // then find the placement that fits the best on the main crossAxis side.
        let resetPlacement = (_overflowsData$filter = overflowsData.filter(d => d.overflows[0] <= 0).sort((a, b) => a.overflows[1] - b.overflows[1])[0]) == null ? void 0 : _overflowsData$filter.placement;

        // Otherwise fallback.
        if (!resetPlacement) {
          switch (fallbackStrategy) {
            case 'bestFit':
              {
                var _overflowsData$filter2;
                const placement = (_overflowsData$filter2 = overflowsData.filter(d => {
                  if (hasFallbackAxisSideDirection) {
                    const currentSideAxis = getSideAxis(d.placement);
                    return currentSideAxis === initialSideAxis ||
                    // Create a bias to the `y` side axis due to horizontal
                    // reading directions favoring greater width.
                    currentSideAxis === 'y';
                  }
                  return true;
                }).map(d => [d.placement, d.overflows.filter(overflow => overflow > 0).reduce((acc, overflow) => acc + overflow, 0)]).sort((a, b) => a[1] - b[1])[0]) == null ? void 0 : _overflowsData$filter2[0];
                if (placement) {
                  resetPlacement = placement;
                }
                break;
              }
            case 'initialPlacement':
              resetPlacement = initialPlacement;
              break;
          }
        }
        if (placement !== resetPlacement) {
          return {
            reset: {
              placement: resetPlacement
            }
          };
        }
      }
      return {};
    }
  };
};

const originSides = /*#__PURE__*/new Set(['left', 'top']);

// For type backwards-compatibility, the `OffsetOptions` type was also
// Derivable.

async function convertValueToCoords(state, options) {
  const {
    placement,
    platform,
    elements
  } = state;
  const rtl = await (platform.isRTL == null ? void 0 : platform.isRTL(elements.floating));
  const side = getSide(placement);
  const alignment = getAlignment(placement);
  const isVertical = getSideAxis(placement) === 'y';
  const mainAxisMulti = originSides.has(side) ? -1 : 1;
  const crossAxisMulti = rtl && isVertical ? -1 : 1;
  const rawValue = evaluate(options, state);

  // eslint-disable-next-line prefer-const
  let {
    mainAxis,
    crossAxis,
    alignmentAxis
  } = typeof rawValue === 'number' ? {
    mainAxis: rawValue,
    crossAxis: 0,
    alignmentAxis: null
  } : {
    mainAxis: rawValue.mainAxis || 0,
    crossAxis: rawValue.crossAxis || 0,
    alignmentAxis: rawValue.alignmentAxis
  };
  if (alignment && typeof alignmentAxis === 'number') {
    crossAxis = alignment === 'end' ? alignmentAxis * -1 : alignmentAxis;
  }
  return isVertical ? {
    x: crossAxis * crossAxisMulti,
    y: mainAxis * mainAxisMulti
  } : {
    x: mainAxis * mainAxisMulti,
    y: crossAxis * crossAxisMulti
  };
}

/**
 * Modifies the placement by translating the floating element along the
 * specified axes.
 * A number (shorthand for `mainAxis` or distance), or an axes configuration
 * object may be passed.
 * @see https://floating-ui.com/docs/offset
 */
const offset$1 = function (options) {
  if (options === void 0) {
    options = 0;
  }
  return {
    name: 'offset',
    options,
    async fn(state) {
      var _middlewareData$offse, _middlewareData$arrow;
      const {
        x,
        y,
        placement,
        middlewareData
      } = state;
      const diffCoords = await convertValueToCoords(state, options);

      // If the placement is the same and the arrow caused an alignment offset
      // then we don't need to change the positioning coordinates.
      if (placement === ((_middlewareData$offse = middlewareData.offset) == null ? void 0 : _middlewareData$offse.placement) && (_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
        return {};
      }
      return {
        x: x + diffCoords.x,
        y: y + diffCoords.y,
        data: {
          ...diffCoords,
          placement
        }
      };
    }
  };
};

/**
 * Optimizes the visibility of the floating element by shifting it in order to
 * keep it in view when it will overflow the clipping boundary.
 * @see https://floating-ui.com/docs/shift
 */
const shift$1 = function (options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: 'shift',
    options,
    async fn(state) {
      const {
        x,
        y,
        placement,
        platform
      } = state;
      const {
        mainAxis: checkMainAxis = true,
        crossAxis: checkCrossAxis = false,
        limiter = {
          fn: _ref => {
            let {
              x,
              y
            } = _ref;
            return {
              x,
              y
            };
          }
        },
        ...detectOverflowOptions
      } = evaluate(options, state);
      const coords = {
        x,
        y
      };
      const overflow = await platform.detectOverflow(state, detectOverflowOptions);
      const crossAxis = getSideAxis(placement);
      const mainAxis = getOppositeAxis(crossAxis);
      let mainAxisCoord = coords[mainAxis];
      let crossAxisCoord = coords[crossAxis];
      const clampCoord = (axis, coord) => clamp(coord + overflow[axis === 'y' ? 'top' : 'left'], coord, coord - overflow[axis === 'y' ? 'bottom' : 'right']);
      if (checkMainAxis) {
        mainAxisCoord = clampCoord(mainAxis, mainAxisCoord);
      }
      if (checkCrossAxis) {
        crossAxisCoord = clampCoord(crossAxis, crossAxisCoord);
      }
      const limitedCoords = limiter.fn({
        ...state,
        [mainAxis]: mainAxisCoord,
        [crossAxis]: crossAxisCoord
      });
      return {
        ...limitedCoords,
        data: {
          x: limitedCoords.x - x,
          y: limitedCoords.y - y,
          enabled: {
            [mainAxis]: checkMainAxis,
            [crossAxis]: checkCrossAxis
          }
        }
      };
    }
  };
};

// Method syntax keeps callback parameters bivariant, but expressing the
// explicit `| undefined` required by `exactOptionalPropertyTypes` needs
// property syntax, which is contravariant under `strictFunctionTypes`.
// Extracting the function from a method position restores that bivariance so
// consumers can still assign callbacks with narrower parameter types.

/**
 * Provides data that allows you to change the size of the floating element —
 * for instance, prevent it from overflowing the clipping boundary or match the
 * width of the reference element.
 * @see https://floating-ui.com/docs/size
 */
const size$1 = function (options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: 'size',
    options,
    async fn(state) {
      const {
        placement,
        rects,
        platform,
        elements
      } = state;
      const {
        apply = () => {},
        ...detectOverflowOptions
      } = evaluate(options, state);
      const overflow = await platform.detectOverflow(state, detectOverflowOptions);
      const side = getSide(placement);
      const alignment = getAlignment(placement);
      const isYAxis = getSideAxis(placement) === 'y';
      const {
        width,
        height
      } = rects.floating;
      let heightSide;
      let widthSide;
      if (side === 'top' || side === 'bottom') {
        heightSide = side;
        widthSide = alignment === ((await (platform.isRTL == null ? void 0 : platform.isRTL(elements.floating))) ? 'start' : 'end') ? 'left' : 'right';
      } else {
        widthSide = side;
        heightSide = alignment === 'end' ? 'top' : 'bottom';
      }
      const maximumClippingHeight = height - overflow.top - overflow.bottom;
      const maximumClippingWidth = width - overflow.left - overflow.right;
      const overflowAvailableHeight = min(height - overflow[heightSide], maximumClippingHeight);
      const overflowAvailableWidth = min(width - overflow[widthSide], maximumClippingWidth);
      const shiftData = state.middlewareData.shift;
      const noShift = !shiftData;
      let availableHeight = overflowAvailableHeight;
      let availableWidth = overflowAvailableWidth;
      if (shiftData != null && shiftData.enabled.x) {
        availableWidth = maximumClippingWidth;
      }
      if (shiftData != null && shiftData.enabled.y) {
        availableHeight = maximumClippingHeight;
      }
      if (noShift && !alignment) {
        if (isYAxis) {
          availableWidth = width - 2 * max(overflow.left, overflow.right);
        } else {
          availableHeight = height - 2 * max(overflow.top, overflow.bottom);
        }
      }
      await apply({
        ...state,
        availableWidth,
        availableHeight
      });
      const nextDimensions = await platform.getDimensions(elements.floating);
      if (width !== nextDimensions.width || height !== nextDimensions.height) {
        return {
          reset: {
            rects: true
          }
        };
      }
      return {};
    }
  };
};

function hasWindow() {
  return typeof window !== 'undefined';
}
function getNodeName(node) {
  if (isNode(node)) {
    return (node.nodeName || '').toLowerCase();
  }
  // Mocked nodes in testing environments may not be instances of Node. By
  // returning `#document` an infinite loop won't occur.
  // https://github.com/floating-ui/floating-ui/issues/2317
  return '#document';
}
function getWindow(node) {
  var _node$ownerDocument;
  return (node == null || (_node$ownerDocument = node.ownerDocument) == null ? void 0 : _node$ownerDocument.defaultView) || window;
}
function getDocumentElement(node) {
  var _ref;
  return (_ref = (isNode(node) ? node.ownerDocument : node.document) || window.document) == null ? void 0 : _ref.documentElement;
}
function isNode(value) {
  if (!hasWindow()) {
    return false;
  }
  return value instanceof Node || value instanceof getWindow(value).Node;
}
function isElement(value) {
  if (!hasWindow()) {
    return false;
  }
  return value instanceof Element || value instanceof getWindow(value).Element;
}
function isHTMLElement(value) {
  if (!hasWindow()) {
    return false;
  }
  return value instanceof HTMLElement || value instanceof getWindow(value).HTMLElement;
}
function isShadowRoot(value) {
  if (!hasWindow() || typeof ShadowRoot === 'undefined') {
    return false;
  }
  return value instanceof ShadowRoot || value instanceof getWindow(value).ShadowRoot;
}
function isOverflowElement(element) {
  const {
    overflow,
    overflowX,
    overflowY,
    display
  } = getComputedStyle$1(element);
  return /auto|scroll|overlay|hidden|clip/.test(overflow + overflowY + overflowX) && display !== 'inline' && display !== 'contents';
}
function isTableElement(element) {
  return /^(table|td|th)$/.test(getNodeName(element));
}
function isTopLayer(element) {
  try {
    if (element.matches(':popover-open')) {
      return true;
    }
  } catch (_e) {
    // no-op
  }
  try {
    return element.matches(':modal');
  } catch (_e) {
    return false;
  }
}
const willChangeRe = /transform|translate|scale|rotate|perspective|filter/;
const containRe = /paint|layout|strict|content/;
const isNotNone = value => !!value && value !== 'none';
let isWebKitValue;
function isContainingBlock(elementOrCss) {
  const css = isElement(elementOrCss) ? getComputedStyle$1(elementOrCss) : elementOrCss;

  // https://developer.mozilla.org/en-US/docs/Web/CSS/Containing_block#identifying_the_containing_block
  // https://drafts.csswg.org/css-transforms-2/#individual-transforms
  return isNotNone(css.transform) || isNotNone(css.translate) || isNotNone(css.scale) || isNotNone(css.rotate) || isNotNone(css.perspective) || !isWebKit() && (isNotNone(css.backdropFilter) || isNotNone(css.filter)) || willChangeRe.test(css.willChange || '') || containRe.test(css.contain || '');
}
function getContainingBlock(element) {
  let currentNode = getParentNode(element);
  while (isHTMLElement(currentNode) && !isLastTraversableNode(currentNode)) {
    if (isContainingBlock(currentNode)) {
      return currentNode;
    } else if (isTopLayer(currentNode)) {
      return null;
    }
    currentNode = getParentNode(currentNode);
  }
  return null;
}
function isWebKit() {
  if (isWebKitValue == null) {
    isWebKitValue = typeof CSS !== 'undefined' && CSS.supports && CSS.supports('-webkit-backdrop-filter', 'none');
  }
  return isWebKitValue;
}
function isLastTraversableNode(node) {
  return /^(html|body|#document)$/.test(getNodeName(node));
}
function getComputedStyle$1(element) {
  return getWindow(element).getComputedStyle(element);
}
function getNodeScroll(element) {
  if (isElement(element)) {
    return {
      scrollLeft: element.scrollLeft,
      scrollTop: element.scrollTop
    };
  }
  return {
    scrollLeft: element.scrollX,
    scrollTop: element.scrollY
  };
}
function getParentNode(node) {
  if (getNodeName(node) === 'html') {
    return node;
  }
  const result =
  // Step into the shadow DOM of the parent of a slotted node.
  node.assignedSlot ||
  // DOM Element detected.
  node.parentNode ||
  // ShadowRoot detected.
  isShadowRoot(node) && node.host ||
  // Fallback.
  getDocumentElement(node);
  return isShadowRoot(result) ? result.host : result;
}
function getNearestOverflowAncestor(node) {
  const parentNode = getParentNode(node);
  if (isLastTraversableNode(parentNode)) {
    return (node.ownerDocument || node).body;
  }
  if (isHTMLElement(parentNode) && isOverflowElement(parentNode)) {
    return parentNode;
  }
  return getNearestOverflowAncestor(parentNode);
}
function getOverflowAncestors(node, list, traverseIframes) {
  var _node$ownerDocument2;
  if (list === void 0) {
    list = [];
  }
  if (traverseIframes === void 0) {
    traverseIframes = true;
  }
  const scrollableAncestor = getNearestOverflowAncestor(node);
  const isBody = scrollableAncestor === ((_node$ownerDocument2 = node.ownerDocument) == null ? void 0 : _node$ownerDocument2.body);
  const win = getWindow(scrollableAncestor);
  if (isBody) {
    const frameElement = getFrameElement(win);
    return list.concat(win, win.visualViewport || [], isOverflowElement(scrollableAncestor) ? scrollableAncestor : [], frameElement && traverseIframes ? getOverflowAncestors(frameElement) : []);
  } else {
    return list.concat(scrollableAncestor, getOverflowAncestors(scrollableAncestor, [], traverseIframes));
  }
}
function getFrameElement(win) {
  return win.parent && Object.getPrototypeOf(win.parent) ? win.frameElement : null;
}

function getCssDimensions(element) {
  const css = getComputedStyle$1(element);
  // In testing environments, the `width` and `height` properties are empty
  // strings for SVG elements, returning NaN. Fallback to `0` in this case.
  let width = parseFloat(css.width) || 0;
  let height = parseFloat(css.height) || 0;
  const hasOffset = isHTMLElement(element);
  const offsetWidth = hasOffset ? element.offsetWidth : width;
  const offsetHeight = hasOffset ? element.offsetHeight : height;
  const shouldFallback = round(width) !== offsetWidth || round(height) !== offsetHeight;
  if (shouldFallback) {
    width = offsetWidth;
    height = offsetHeight;
  }
  return {
    width,
    height,
    $: shouldFallback
  };
}

function unwrapElement(element) {
  return !isElement(element) ? element.contextElement : element;
}

function getScale(element) {
  const domElement = unwrapElement(element);
  if (!isHTMLElement(domElement)) {
    return createCoords(1);
  }
  const rect = domElement.getBoundingClientRect();
  const {
    width,
    height,
    $
  } = getCssDimensions(domElement);
  let x = ($ ? round(rect.width) : rect.width) / width;
  let y = ($ ? round(rect.height) : rect.height) / height;

  // 0, NaN, or Infinity should always fallback to 1.

  if (!x || !Number.isFinite(x)) {
    x = 1;
  }
  if (!y || !Number.isFinite(y)) {
    y = 1;
  }
  return {
    x,
    y
  };
}

const noOffsets = /*#__PURE__*/createCoords(0);
function getVisualOffsets(element) {
  const win = getWindow(element);
  if (!isWebKit() || !win.visualViewport) {
    return noOffsets;
  }
  return {
    x: win.visualViewport.offsetLeft,
    y: win.visualViewport.offsetTop
  };
}
function shouldAddVisualOffsets(element, isFixed, floatingOffsetParent) {
  if (isFixed === void 0) {
    isFixed = false;
  }
  return !!floatingOffsetParent && isFixed && floatingOffsetParent === getWindow(element);
}

function getBoundingClientRect(element, includeScale, isFixedStrategy, offsetParent) {
  if (includeScale === void 0) {
    includeScale = false;
  }
  if (isFixedStrategy === void 0) {
    isFixedStrategy = false;
  }
  const clientRect = element.getBoundingClientRect();
  const domElement = unwrapElement(element);
  let scale = createCoords(1);
  if (includeScale) {
    if (offsetParent) {
      if (isElement(offsetParent)) {
        scale = getScale(offsetParent);
      }
    } else {
      scale = getScale(element);
    }
  }
  const visualOffsets = shouldAddVisualOffsets(domElement, isFixedStrategy, offsetParent) ? getVisualOffsets(domElement) : createCoords(0);
  let x = (clientRect.left + visualOffsets.x) / scale.x;
  let y = (clientRect.top + visualOffsets.y) / scale.y;
  let width = clientRect.width / scale.x;
  let height = clientRect.height / scale.y;
  if (domElement && offsetParent) {
    const win = getWindow(domElement);
    const offsetWin = isElement(offsetParent) ? getWindow(offsetParent) : offsetParent;
    let currentWin = win;
    let currentIFrame = getFrameElement(currentWin);
    while (currentIFrame && offsetWin !== currentWin) {
      const iframeScale = getScale(currentIFrame);
      const iframeRect = currentIFrame.getBoundingClientRect();
      const css = getComputedStyle$1(currentIFrame);
      const left = iframeRect.left + (currentIFrame.clientLeft + parseFloat(css.paddingLeft)) * iframeScale.x;
      const top = iframeRect.top + (currentIFrame.clientTop + parseFloat(css.paddingTop)) * iframeScale.y;
      x *= iframeScale.x;
      y *= iframeScale.y;
      width *= iframeScale.x;
      height *= iframeScale.y;
      x += left;
      y += top;
      currentWin = getWindow(currentIFrame);
      currentIFrame = getFrameElement(currentWin);
    }
  }
  return rectToClientRect({
    width,
    height,
    x,
    y
  });
}

// If <html> has a CSS width greater than the viewport, then this will be
// incorrect for RTL.
function getWindowScrollBarX(element, rect) {
  const leftScroll = getNodeScroll(element).scrollLeft;
  if (!rect) {
    return getBoundingClientRect(getDocumentElement(element)).left + leftScroll;
  }
  return rect.left + leftScroll;
}

function getHTMLOffset(documentElement, scroll) {
  const htmlRect = documentElement.getBoundingClientRect();
  const x = htmlRect.left + scroll.scrollLeft - getWindowScrollBarX(documentElement, htmlRect);
  const y = htmlRect.top + scroll.scrollTop;
  return {
    x,
    y
  };
}

function convertOffsetParentRelativeRectToViewportRelativeRect(_ref) {
  let {
    elements,
    rect,
    offsetParent,
    strategy
  } = _ref;
  const isFixed = strategy === 'fixed';
  const documentElement = getDocumentElement(offsetParent);
  const topLayer = elements ? isTopLayer(elements.floating) : false;
  if (offsetParent === documentElement || topLayer && isFixed) {
    return rect;
  }
  let scroll = {
    scrollLeft: 0,
    scrollTop: 0
  };
  let scale = createCoords(1);
  const offsets = createCoords(0);
  const isOffsetParentAnElement = isHTMLElement(offsetParent);
  if (isOffsetParentAnElement || !isFixed) {
    if (getNodeName(offsetParent) !== 'body' || isOverflowElement(documentElement)) {
      scroll = getNodeScroll(offsetParent);
    }
    if (isOffsetParentAnElement) {
      const offsetRect = getBoundingClientRect(offsetParent);
      scale = getScale(offsetParent);
      offsets.x = offsetRect.x + offsetParent.clientLeft;
      offsets.y = offsetRect.y + offsetParent.clientTop;
    }
  }
  const htmlOffset = documentElement && !isOffsetParentAnElement && !isFixed ? getHTMLOffset(documentElement, scroll) : createCoords(0);
  return {
    width: rect.width * scale.x,
    height: rect.height * scale.y,
    x: rect.x * scale.x - scroll.scrollLeft * scale.x + offsets.x + htmlOffset.x,
    y: rect.y * scale.y - scroll.scrollTop * scale.y + offsets.y + htmlOffset.y
  };
}

function getClientRects(element) {
  return element.getClientRects ? Array.from(element.getClientRects()) : [];
}

// Gets the entire size of the scrollable document area, even extending outside
// of the `<html>` and `<body>` rect bounds if horizontally scrollable.
function getDocumentRect(html) {
  const scroll = getNodeScroll(html);
  const body = html.ownerDocument.body;
  const width = max(html.scrollWidth, html.clientWidth, body.scrollWidth, body.clientWidth);
  const height = max(html.scrollHeight, html.clientHeight, body.scrollHeight, body.clientHeight);
  let x = -scroll.scrollLeft + getWindowScrollBarX(html);
  const y = -scroll.scrollTop;
  if (getComputedStyle$1(body).direction === 'rtl') {
    x += max(html.clientWidth, body.clientWidth) - width;
  }
  return {
    width,
    height,
    x,
    y
  };
}

// Safety check: ensure the scrollbar space is reasonable in case this
// calculation is affected by unusual styles.
// Most scrollbars leave 15-18px of space.
const SCROLLBAR_MAX = 25;
function getViewportRect(element, strategy, rootBoundary) {
  if (rootBoundary === void 0) {
    rootBoundary = 'viewport';
  }
  const isLayoutViewport = rootBoundary === 'layoutViewport';
  const win = getWindow(element);
  const html = getDocumentElement(element);
  const visualViewport = win.visualViewport;
  let width = html.clientWidth;
  let height = html.clientHeight;
  let x = 0;
  let y = 0;
  if (visualViewport) {
    // Client coordinates are relative to the layout viewport, except in
    // WebKit with an `absolute` strategy, where they are relative to the
    // visual viewport.
    const layoutRelativeClientCoords = !isWebKit() || strategy === 'fixed';
    if (isLayoutViewport) {
      if (!layoutRelativeClientCoords) {
        x = -visualViewport.offsetLeft;
        y = -visualViewport.offsetTop;
      }
    } else {
      width = visualViewport.width;
      height = visualViewport.height;
      if (layoutRelativeClientCoords) {
        x = visualViewport.offsetLeft;
        y = visualViewport.offsetTop;
      }
    }
  }
  const windowScrollbarX = getWindowScrollBarX(html);
  // `scrollbar-gutter: stable` on the <html> reserves gutter space that shrinks
  // the visual width but isn't reflected in `html.clientWidth`, so subtract it.
  // Only the inline-end (right) gutter can hold the scrollbar; `both-edges` also
  // reserves an empty inline-start gutter that clips nothing, so exclude just
  // the one scrollbar-side gutter — halve the measured (two-gutter) total. A
  // left-side scrollbar (`windowScrollbarX > 0`) is already handled by
  // `getHTMLOffset`/`visualViewport.width`; skip it here.
  if (windowScrollbarX <= 0) {
    const doc = html.ownerDocument;
    const body = doc.body;
    const bodyStyles = getComputedStyle(body);
    const bodyMarginInline = doc.compatMode === 'CSS1Compat' ? parseFloat(bodyStyles.marginLeft) + parseFloat(bodyStyles.marginRight) || 0 : 0;
    const reservedWidth = Math.abs(html.clientWidth - body.clientWidth - bodyMarginInline);
    const gutter = getComputedStyle(html).scrollbarGutter === 'stable both-edges' ? reservedWidth / 2 : reservedWidth;
    if (gutter <= SCROLLBAR_MAX) {
      width -= gutter;
    }
  }
  return {
    width,
    height,
    x,
    y
  };
}

// Returns the inner client rect, subtracting scrollbars if present.
function getInnerBoundingClientRect(element, strategy) {
  const clientRect = getBoundingClientRect(element, true, strategy === 'fixed');
  const top = clientRect.top + element.clientTop;
  const left = clientRect.left + element.clientLeft;
  const scale = getScale(element);
  const width = element.clientWidth * scale.x;
  const height = element.clientHeight * scale.y;
  const x = left * scale.x;
  const y = top * scale.y;
  return {
    width,
    height,
    x,
    y
  };
}
function getClientRectFromClippingAncestor(element, clippingAncestor, strategy) {
  let rect;
  if (clippingAncestor === 'viewport' || clippingAncestor === 'layoutViewport') {
    rect = getViewportRect(element, strategy, clippingAncestor);
  } else if (clippingAncestor === 'document') {
    rect = getDocumentRect(getDocumentElement(element));
  } else if (isElement(clippingAncestor)) {
    rect = getInnerBoundingClientRect(clippingAncestor, strategy);
  } else {
    const visualOffsets = getVisualOffsets(element);
    rect = {
      x: clippingAncestor.x - visualOffsets.x,
      y: clippingAncestor.y - visualOffsets.y,
      width: clippingAncestor.width,
      height: clippingAncestor.height
    };
  }
  return rectToClientRect(rect);
}

// A "clipping ancestor" is an `overflow` element with the characteristic of
// clipping (or hiding) child elements. This returns all clipping ancestors
// of the given element up the tree.
function getClippingElementAncestors(element, cache) {
  const cachedResult = cache.get(element);
  if (cachedResult) {
    return cachedResult;
  }
  let result = getOverflowAncestors(element, [], false).filter(el => isElement(el) && getNodeName(el) !== 'body');
  let lastKeptComputedStyle = null;
  const elementIsFixed = getComputedStyle$1(element).position === 'fixed';
  let currentNode = elementIsFixed ? getParentNode(element) : element;

  // https://developer.mozilla.org/en-US/docs/Web/CSS/Containing_block#identifying_the_containing_block
  while (isElement(currentNode) && !isLastTraversableNode(currentNode)) {
    const computedStyle = getComputedStyle$1(currentNode);
    const currentNodeIsContaining = isContainingBlock(currentNode);
    // Position of the containing block chain below the current node. A fixed
    // element whose containing block hasn't been found yet is a fixed chain.
    const lastPosition = lastKeptComputedStyle ? lastKeptComputedStyle.position : elementIsFixed ? 'fixed' : '';

    // A non-containing ancestor does not clip the element when the chain
    // below it escapes it: a fixed chain escapes all ancestors up to the
    // next containing block, an absolute chain escapes static ancestors.
    const shouldDropCurrentNode = !currentNodeIsContaining && (lastPosition === 'fixed' || lastPosition === 'absolute' && computedStyle.position === 'static');
    if (shouldDropCurrentNode) {
      // Drop non-containing blocks.
      result = result.filter(ancestor => ancestor !== currentNode);
    } else {
      // The kept node carries the chain position for the next iteration.
      lastKeptComputedStyle = computedStyle;
    }
    currentNode = getParentNode(currentNode);
  }
  cache.set(element, result);
  return result;
}

// Gets the maximum area that the element is visible in due to any number of
// clipping ancestors.
function getClippingRect(_ref) {
  let {
    element,
    boundary,
    rootBoundary,
    strategy
  } = _ref;
  const elementClippingAncestors = boundary === 'clippingAncestors' ? isTopLayer(element) ? [] : getClippingElementAncestors(element, this._c) : [].concat(boundary);
  const clippingAncestors = [...elementClippingAncestors, rootBoundary];
  const firstRect = getClientRectFromClippingAncestor(element, clippingAncestors[0], strategy);
  let top = firstRect.top;
  let right = firstRect.right;
  let bottom = firstRect.bottom;
  let left = firstRect.left;
  for (let i = 1; i < clippingAncestors.length; i++) {
    const rect = getClientRectFromClippingAncestor(element, clippingAncestors[i], strategy);
    top = max(rect.top, top);
    right = min(rect.right, right);
    bottom = min(rect.bottom, bottom);
    left = max(rect.left, left);
  }
  return {
    width: right - left,
    height: bottom - top,
    x: left,
    y: top
  };
}

function getDimensions(element) {
  const {
    width,
    height
  } = getCssDimensions(element);
  return {
    width,
    height
  };
}

function getRectRelativeToOffsetParent(element, offsetParent, strategy) {
  const isOffsetParentAnElement = isHTMLElement(offsetParent);
  const documentElement = getDocumentElement(offsetParent);
  const isFixed = strategy === 'fixed';
  const rect = getBoundingClientRect(element, true, isFixed, offsetParent);
  let scroll = {
    scrollLeft: 0,
    scrollTop: 0
  };
  const offsets = createCoords(0);
  if (isOffsetParentAnElement || !isFixed) {
    if (getNodeName(offsetParent) !== 'body' || isOverflowElement(documentElement)) {
      scroll = getNodeScroll(offsetParent);
    }
    if (isOffsetParentAnElement) {
      const offsetRect = getBoundingClientRect(offsetParent, true, isFixed, offsetParent);
      offsets.x = offsetRect.x + offsetParent.clientLeft;
      offsets.y = offsetRect.y + offsetParent.clientTop;
    }
  }

  // If the <body> scrollbar appears on the left (e.g. RTL systems). Use
  // Firefox with layout.scrollbar.side = 3 in about:config to test this.
  if (!isOffsetParentAnElement && documentElement) {
    offsets.x = getWindowScrollBarX(documentElement);
  }
  const htmlOffset = documentElement && !isOffsetParentAnElement && !isFixed ? getHTMLOffset(documentElement, scroll) : createCoords(0);
  const x = rect.left + scroll.scrollLeft - offsets.x - htmlOffset.x;
  const y = rect.top + scroll.scrollTop - offsets.y - htmlOffset.y;
  return {
    x,
    y,
    width: rect.width,
    height: rect.height
  };
}

function isStaticPositioned(element) {
  return getComputedStyle$1(element).position === 'static';
}

function getTrueOffsetParent(element, polyfill) {
  if (!isHTMLElement(element) || getComputedStyle$1(element).position === 'fixed') {
    return null;
  }
  if (polyfill) {
    return polyfill(element);
  }
  let rawOffsetParent = element.offsetParent;

  // Firefox returns the <html> element as the offsetParent if it's non-static,
  // while Chrome and Safari return the <body> element. The <body> element must
  // be used to perform the correct calculations even if the <html> element is
  // non-static.
  if (getDocumentElement(element) === rawOffsetParent) {
    rawOffsetParent = rawOffsetParent.ownerDocument.body;
  }
  return rawOffsetParent;
}

// Gets the closest ancestor positioned element. Handles some edge cases,
// such as table ancestors and cross browser bugs.
function getOffsetParent(element, polyfill) {
  const win = getWindow(element);
  if (isTopLayer(element)) {
    return win;
  }
  if (!isHTMLElement(element)) {
    let svgOffsetParent = getParentNode(element);
    while (svgOffsetParent && !isLastTraversableNode(svgOffsetParent)) {
      if (isElement(svgOffsetParent) && !isStaticPositioned(svgOffsetParent)) {
        return svgOffsetParent;
      }
      svgOffsetParent = getParentNode(svgOffsetParent);
    }
    return win;
  }
  let offsetParent = getTrueOffsetParent(element, polyfill);
  while (offsetParent && isTableElement(offsetParent) && isStaticPositioned(offsetParent)) {
    offsetParent = getTrueOffsetParent(offsetParent, polyfill);
  }
  if (offsetParent && isLastTraversableNode(offsetParent) && isStaticPositioned(offsetParent) && !isContainingBlock(offsetParent)) {
    return win;
  }
  return offsetParent || getContainingBlock(element) || win;
}

const getElementRects = async function (data) {
  const getOffsetParentFn = this.getOffsetParent || getOffsetParent;
  const getDimensionsFn = this.getDimensions;
  const floatingDimensions = await getDimensionsFn(data.floating);
  return {
    reference: getRectRelativeToOffsetParent(data.reference, await getOffsetParentFn(data.floating), data.strategy),
    floating: {
      x: 0,
      y: 0,
      width: floatingDimensions.width,
      height: floatingDimensions.height
    }
  };
};

function isRTL(element) {
  return getComputedStyle$1(element).direction === 'rtl';
}

const platform = {
  convertOffsetParentRelativeRectToViewportRelativeRect,
  getDocumentElement,
  getClippingRect,
  getOffsetParent,
  getElementRects,
  getClientRects,
  getDimensions,
  getScale,
  isElement,
  isRTL
};

function rectsAreEqual(a, b) {
  return a.x === b.x && a.y === b.y && a.width === b.width && a.height === b.height;
}

// https://samthor.au/2021/observing-dom/
function observeMove(element, onMove, ancestorResize) {
  let io = null;
  let timeoutId;
  const root = getDocumentElement(element);
  function cleanup() {
    var _io;
    clearTimeout(timeoutId);
    (_io = io) == null || _io.disconnect();
    io = null;
  }
  function refresh(skip, threshold) {
    if (skip === void 0) {
      skip = false;
    }
    if (threshold === void 0) {
      threshold = 1;
    }
    cleanup();
    const elementRectForRootMargin = element.getBoundingClientRect();
    const {
      left,
      top,
      width,
      height
    } = elementRectForRootMargin;
    if (!skip) {
      onMove();
    }
    if (!width || !height) {
      return;
    }
    const insetTop = floor(top);
    const insetRight = floor(root.clientWidth - (left + width));
    const insetBottom = floor(root.clientHeight - (top + height));
    const insetLeft = floor(left);
    const rootMargin = -insetTop + "px " + -insetRight + "px " + -insetBottom + "px " + -insetLeft + "px";
    const options = {
      rootMargin,
      threshold: max(0, min(1, threshold)) || 1
    };
    let isFirstUpdate = true;
    function handleObserve(entries) {
      const ratio = entries[0].intersectionRatio;

      // The entry is a snapshot, so the reference may have moved since the
      // intersection was computed (under performance constraints, or between
      // consecutive frames of a multi-frame layout shift). The reported ratio
      // and the observed area are stale in that case and cannot be trusted to
      // detect subsequent movement, so refresh regardless of the ratio.
      if (!rectsAreEqual(elementRectForRootMargin, element.getBoundingClientRect())) {
        return refresh();
      }
      if (ratio !== threshold) {
        if (!isFirstUpdate) {
          return refresh();
        }
        if (!ratio) {
          // If the reference is clipped in place, the ratio is 0. Throttle
          // the refresh to prevent an infinite loop of updates.
          timeoutId = setTimeout(() => {
            refresh(false, 1e-7);
          }, 1000);
        } else {
          refresh(false, ratio);
        }
      }
      isFirstUpdate = false;
    }

    // Older browsers don't support a `document` as the root and will throw an
    // error.
    try {
      io = new IntersectionObserver(handleObserve, {
        ...options,
        // Handle <iframe>s
        root: root.ownerDocument
      });
    } catch (_e) {
      io = new IntersectionObserver(handleObserve, options);
    }
    io.observe(element);
  }
  const win = getWindow(element);
  // The window is a resize ancestor, so when `ancestorResize` is enabled its
  // listener already runs the update on resize. Here we only need to rebuild
  // the `IntersectionObserver` for the new root size, skipping a redundant
  // update. When `ancestorResize` is disabled, this becomes the sole update.
  const handleResize = () => refresh(ancestorResize);
  win.addEventListener('resize', handleResize);
  refresh(true);
  return () => {
    win.removeEventListener('resize', handleResize);
    cleanup();
  };
}

/**
 * Automatically updates the position of the floating element when necessary.
 * Should only be called when the floating element is mounted on the DOM or
 * visible on the screen.
 * @returns cleanup function that should be invoked when the floating element is
 * removed from the DOM or hidden from the screen.
 * @see https://floating-ui.com/docs/autoUpdate
 */
function autoUpdate(reference, floating, update, options) {
  if (options === void 0) {
    options = {};
  }
  const {
    ancestorScroll = true,
    ancestorResize = true,
    elementResize = typeof ResizeObserver === 'function',
    layoutShift = typeof IntersectionObserver === 'function',
    animationFrame = false
  } = options;
  const referenceEl = unwrapElement(reference);
  const ancestors = ancestorScroll || ancestorResize ? [...(referenceEl ? getOverflowAncestors(referenceEl) : []), ...(floating ? getOverflowAncestors(floating) : [])] : [];
  ancestors.forEach(ancestor => {
    ancestorScroll && ancestor.addEventListener('scroll', update);
    ancestorResize && ancestor.addEventListener('resize', update);
  });
  const cleanupIo = referenceEl && layoutShift ? observeMove(referenceEl, update, ancestorResize) : null;
  let reobserveFrame = -1;
  let resizeObserver = null;
  if (elementResize) {
    resizeObserver = new ResizeObserver(_ref => {
      let [firstEntry] = _ref;
      if (firstEntry && firstEntry.target === referenceEl && resizeObserver && floating) {
        // Prevent update loops when using the `size` middleware.
        // https://github.com/floating-ui/floating-ui/issues/1740
        resizeObserver.unobserve(floating);
        cancelAnimationFrame(reobserveFrame);
        reobserveFrame = requestAnimationFrame(() => {
          var _resizeObserver;
          (_resizeObserver = resizeObserver) == null || _resizeObserver.observe(floating);
        });
      }
      update();
    });
    if (referenceEl && !animationFrame) {
      resizeObserver.observe(referenceEl);
    }
    if (floating) {
      resizeObserver.observe(floating);
    }
  }
  let frameId;
  let prevRefRect = animationFrame ? getBoundingClientRect(reference) : null;
  if (animationFrame) {
    frameLoop();
  }
  function frameLoop() {
    const nextRefRect = getBoundingClientRect(reference);
    if (prevRefRect && !rectsAreEqual(prevRefRect, nextRefRect)) {
      update();
    }
    prevRefRect = nextRefRect;
    frameId = requestAnimationFrame(frameLoop);
  }
  update();
  return () => {
    var _resizeObserver2;
    ancestors.forEach(ancestor => {
      ancestorScroll && ancestor.removeEventListener('scroll', update);
      ancestorResize && ancestor.removeEventListener('resize', update);
    });
    cleanupIo == null || cleanupIo();
    (_resizeObserver2 = resizeObserver) == null || _resizeObserver2.disconnect();
    resizeObserver = null;
    if (animationFrame) {
      cancelAnimationFrame(frameId);
    }
  };
}

/**
 * Modifies the placement by translating the floating element along the
 * specified axes.
 * A number (shorthand for `mainAxis` or distance), or an axes configuration
 * object may be passed.
 * @see https://floating-ui.com/docs/offset
 */
const offset = offset$1;

/**
 * Optimizes the visibility of the floating element by shifting it in order to
 * keep it in view when it will overflow the clipping boundary.
 * @see https://floating-ui.com/docs/shift
 */
const shift = shift$1;

/**
 * Optimizes the visibility of the floating element by flipping the `placement`
 * in order to keep it in view when the preferred placement(s) will overflow the
 * clipping boundary. Alternative to `autoPlacement`.
 * @see https://floating-ui.com/docs/flip
 */
const flip = flip$1;

/**
 * Provides data that allows you to change the size of the floating element —
 * for instance, prevent it from overflowing the clipping boundary or match the
 * width of the reference element.
 * @see https://floating-ui.com/docs/size
 */
const size = size$1;

/**
 * Computes the `x` and `y` coordinates that will place the floating element
 * next to a given reference element.
 */
const computePosition = (reference, floating, options) => {
  // This caches the expensive `getClippingElementAncestors` function so that
  // multiple lifecycle resets re-use the same result. It only lives for a
  // single call. If other functions become expensive, we can add them as well.
  const cache = new Map();
  const mergedOptions = options != null ? options : {};
  const platformWithCache = {
    ...platform,
    ...mergedOptions.platform,
    _c: cache
  };
  return computePosition$1(reference, floating, {
    ...mergedOptions,
    platform: platformWithCache
  });
};

/**
 * Floating UI positioning utility for shadcn-rails components
 *
 * Provides smart positioning for dropdowns, popovers, tooltips, etc.
 * that automatically handles:
 * - Viewport edge detection (flip to opposite side)
 * - Sliding along axis to stay in view (shift)
 * - Consistent spacing (offset)
 * - Dynamic content sizing
 */
/**
 * Default middleware configuration
 */
[
    offset(4),
    flip({
        fallbackAxisSideDirection: "start",
        crossAxis: false
    }),
    shift({ padding: 8 })
];
const placements = [
    "top",
    "top-start",
    "top-end",
    "right",
    "right-start",
    "right-end",
    "bottom",
    "bottom-start",
    "bottom-end",
    "left",
    "left-start",
    "left-end"
];
function normalizePlacement(placement) {
    return placements.includes(placement) ? placement : "bottom-start";
}
/**
 * Position a floating element relative to a reference element
 *
 * @param {HTMLElement} reference - The trigger/reference element
 * @param {HTMLElement} floating - The floating content element
 * @param {Object} options - Positioning options
 * @param {string} options.placement - Placement (top, bottom, left, right, with -start/-end variants)
 * @param {number} options.offset - Offset distance in pixels (default: 4)
 * @param {boolean} options.sameWidth - Make floating element same width as reference
 * @param {number} options.maxHeight - Maximum height for the floating element
 * @param {Function} options.onPositioned - Callback after positioning
 * @returns {Function} Cleanup function to stop auto-updates
 */
function positionFloating(reference, floating, options = {}) {
    const { placement = "bottom-start", offset: offsetValue = 4, sameWidth = false, maxHeight = null, onPositioned = null } = options;
    // Build middleware array
    const middleware = [
        offset(offsetValue),
        flip({
            fallbackAxisSideDirection: "start",
            crossAxis: false
        }),
        shift({ padding: 8 })
    ];
    // Add size middleware if needed
    if (maxHeight || sameWidth) {
        middleware.push(size({
            apply({ availableWidth, availableHeight, elements, rects }) {
                const styles = {};
                if (sameWidth) {
                    styles.width = `${rects.reference.width}px`;
                    styles.minWidth = `${rects.reference.width}px`;
                }
                if (maxHeight) {
                    styles.maxHeight = `${Math.min(maxHeight, availableHeight - 10)}px`;
                }
                else {
                    styles.maxHeight = `${Math.max(0, availableHeight - 10)}px`;
                }
                Object.assign(elements.floating.style, styles);
            },
            padding: 10
        }));
    }
    // Set up auto-updating position
    const cleanup = autoUpdate(reference, floating, () => {
        computePosition(reference, floating, {
            placement: normalizePlacement(placement),
            middleware
        }).then(({ x, y, placement: finalPlacement }) => {
            // Apply position
            Object.assign(floating.style, {
                position: "absolute",
                left: `${x}px`,
                top: `${y}px`
            });
            // Update data-side attribute for animations
            const side = finalPlacement.split("-")[0];
            floating.dataset.side = side;
            // Call callback if provided
            if (onPositioned) {
                onPositioned({ x, y, placement: finalPlacement });
            }
        });
    });
    return cleanup;
}
/**
 * Position a context menu at specific coordinates
 *
 * @param {HTMLElement} floating - The floating content element
 * @param {number} x - X coordinate (clientX from event)
 * @param {number} y - Y coordinate (clientY from event)
 * @param {Object} options - Positioning options
 * @returns {void}
 */
function positionAtPoint(floating, x, y, options = {}) {
    const { maxHeight = null } = options;
    // Create a virtual reference element at the click point
    const virtualRef = {
        getBoundingClientRect() {
            return {
                width: 0,
                height: 0,
                x,
                y,
                top: y,
                left: x,
                right: x,
                bottom: y
            };
        }
    };
    const middleware = [
        offset(4),
        flip(),
        shift({ padding: 8 })
    ];
    if (maxHeight) {
        middleware.push(size({
            apply({ availableHeight, elements }) {
                elements.floating.style.maxHeight = `${Math.min(maxHeight, availableHeight - 10)}px`;
            },
            padding: 10
        }));
    }
    computePosition(virtualRef, floating, {
        placement: "bottom-start",
        middleware
    }).then(({ x: posX, y: posY, placement }) => {
        Object.assign(floating.style, {
            position: "fixed",
            left: `${posX}px`,
            top: `${posY}px`
        });
        const side = placement.split("-")[0];
        floating.dataset.side = side;
    });
}

/**
 * Combobox controller for searchable select dropdown
 * Handles open/close, filtering, keyboard navigation, and item selection
 * Uses Floating UI for smart positioning and stimulus-use for utilities
 */
let default_1$o = class default_1 extends Controller {
    static { this.targets = ["trigger", "content", "input", "list", "item", "empty", "displayValue", "hiddenInput"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        value: { type: String, default: "" },
        selectedIndex: { type: Number, default: -1 },
        debounceWait: { type: Number, default: 150 },
        placement: { type: String, default: "bottom-start" }
    }; }
    static { this.debounces = ["filter"]; }
    connect() {
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        this.cleanupFloating = null;
        // Use stimulus-use for click outside detection
        useClickOutside(this);
        // Use stimulus-use for debounced filtering
        useDebounce(this, { wait: this.debounceWaitValue });
    }
    disconnect() {
        document.removeEventListener("keydown", this.boundHandleKeydown);
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    toggle() {
        if (this.openValue) {
            this.close();
        }
        else {
            this.open();
        }
    }
    open() {
        if (this.openValue)
            return;
        this.openValue = true;
        this.contentTarget.hidden = false;
        this.contentTarget.dataset.state = "open";
        this.triggerTarget.setAttribute("aria-expanded", "true");
        // Use Floating UI for smart positioning
        this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
            placement: this.placementValue,
            sameWidth: true,
            maxHeight: 384 // max-h-96
        });
        // Focus the input
        requestAnimationFrame(() => {
            if (this.hasInputTarget) {
                this.inputTarget.focus();
            }
        });
        // Add keyboard listener
        document.addEventListener("keydown", this.boundHandleKeydown);
        // Reset selection index
        this.selectedIndexValue = -1;
        this.updateSelection();
    }
    close() {
        if (!this.openValue)
            return;
        this.openValue = false;
        this.contentTarget.dataset.state = "closed";
        this.triggerTarget.setAttribute("aria-expanded", "false");
        // Cleanup Floating UI
        this.cleanupPositioning();
        // Hide after animation completes, then reset filter state
        const hideAndReset = () => {
            this.contentTarget.hidden = true;
            // Reset search and filter state after hiding to avoid flash
            if (this.hasInputTarget) {
                this.inputTarget.value = "";
            }
            // Reset all items to visible for next open
            this.itemTargets.forEach((item) => {
                item.style.display = "";
            });
            // Hide empty state
            if (this.hasEmptyTarget) {
                this.emptyTarget.hidden = true;
            }
        };
        // Listen for animation end, with fallback timeout
        const onAnimationEnd = () => {
            this.contentTarget.removeEventListener("animationend", onAnimationEnd);
            hideAndReset();
        };
        this.contentTarget.addEventListener("animationend", onAnimationEnd);
        // Fallback in case animation doesn't fire (e.g., no animation defined)
        setTimeout(() => {
            this.contentTarget.removeEventListener("animationend", onAnimationEnd);
            if (!this.contentTarget.hidden) {
                hideAndReset();
            }
        }, 200);
        // Remove keyboard listener
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    /**
     * Filter items based on input value
     */
    filter() {
        const query = this.hasInputTarget ? this.inputTarget.value.toLowerCase().trim() : "";
        let visibleCount = 0;
        this.itemTargets.forEach((item) => {
            const label = item.dataset.label?.toLowerCase() || item.textContent.toLowerCase();
            const value = item.dataset.value?.toLowerCase() || "";
            const matches = query === "" || label.includes(query) || value.includes(query);
            // Use style.display instead of hidden attribute to avoid Tailwind flex override
            item.style.display = matches ? "" : "none";
            if (matches)
                visibleCount++;
        });
        // Show/hide empty state - only show when there's a query AND no results
        if (this.hasEmptyTarget) {
            const shouldHide = query === "" || visibleCount > 0;
            this.emptyTarget.hidden = shouldHide;
        }
        // Reset selection
        this.selectedIndexValue = -1;
        this.updateSelection();
    }
    /**
     * Select an item
     */
    select(event) {
        const item = event.currentTarget;
        const value = item.dataset.value;
        const label = item.dataset.label;
        // Update value
        this.valueValue = value;
        // Update hidden input for form submission
        if (this.hasHiddenInputTarget) {
            this.hiddenInputTarget.value = value;
        }
        // Update display value
        if (this.hasDisplayValueTarget) {
            this.displayValueTarget.textContent = label;
            this.displayValueTarget.classList.remove("text-muted-foreground");
        }
        // Update selected state on items
        this.itemTargets.forEach((i) => {
            const isSelected = i.dataset.value === value;
            i.dataset.selected = String(isSelected);
            // Update check icon opacity
            const checkIcon = i.querySelector("svg");
            if (checkIcon) {
                if (isSelected) {
                    checkIcon.classList.remove("opacity-0");
                    checkIcon.classList.add("opacity-100");
                }
                else {
                    checkIcon.classList.remove("opacity-100");
                    checkIcon.classList.add("opacity-0");
                }
            }
        });
        // Dispatch change event
        this.dispatch("change", { detail: { value, label } });
        // Close the dropdown
        this.close();
    }
    /**
     * Handle keyboard navigation
     */
    handleKeydown(event) {
        const visibleItems = this.getVisibleItems();
        switch (event.key) {
            case "ArrowDown":
                event.preventDefault();
                this.selectedIndexValue = Math.min(this.selectedIndexValue + 1, visibleItems.length - 1);
                this.updateSelection();
                break;
            case "ArrowUp":
                event.preventDefault();
                this.selectedIndexValue = Math.max(this.selectedIndexValue - 1, 0);
                this.updateSelection();
                break;
            case "Enter":
                event.preventDefault();
                if (this.selectedIndexValue >= 0 && visibleItems[this.selectedIndexValue]) {
                    // Simulate click on the selected item
                    visibleItems[this.selectedIndexValue].click();
                }
                break;
            case "Escape":
                event.preventDefault();
                this.close();
                break;
        }
    }
    /**
     * Update visual selection state
     */
    updateSelection() {
        const visibleItems = this.getVisibleItems();
        visibleItems.forEach((item, index) => {
            if (index === this.selectedIndexValue) {
                item.classList.add("bg-accent", "text-accent-foreground");
                item.scrollIntoView({ block: "nearest" });
            }
            else {
                item.classList.remove("bg-accent", "text-accent-foreground");
            }
        });
    }
    /**
     * Get all visible items
     */
    getVisibleItems() {
        return this.itemTargets.filter((item) => item.style.display !== "none");
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.openValue) {
            this.close();
        }
    }
};

/**
 * Command controller for command palette functionality
 * Handles filtering, keyboard navigation, and item selection
 */
let default_1$n = class default_1 extends Controller {
    static { this.targets = ["input", "list", "empty", "group", "item"]; }
    static { this.values = {
        selectedIndex: { type: Number, default: -1 },
        debounceWait: { type: Number, default: 150 }
    }; }
    static { this.debounces = ["filter"]; }
    connect() {
        useDebounce(this, { wait: this.debounceWaitValue });
        this.updateSelection();
    }
    /**
     * Filter items based on input value
     */
    filter() {
        const query = this.hasInputTarget ? this.inputTarget.value.toLowerCase().trim() : "";
        let visibleCount = 0;
        // Filter items
        this.itemTargets.forEach((item) => {
            const value = item.dataset.value?.toLowerCase() || item.textContent.toLowerCase();
            const matches = query === "" || value.includes(query);
            item.hidden = !matches;
            if (matches)
                visibleCount++;
        });
        // Filter groups - hide if all items are hidden
        this.groupTargets.forEach((group) => {
            const visibleItems = group.querySelectorAll('[data-shadcn--command-target="item"]:not([hidden])');
            group.hidden = visibleItems.length === 0;
        });
        // Show/hide empty state
        if (this.hasEmptyTarget) {
            this.emptyTarget.hidden = visibleCount > 0;
        }
        // Reset selection
        this.selectedIndexValue = -1;
        this.updateSelection();
    }
    /**
     * Handle keyboard navigation
     */
    handleKeydown(event) {
        const visibleItems = this.getVisibleItems();
        switch (event.key) {
            case "ArrowDown":
                event.preventDefault();
                this.selectedIndexValue = Math.min(this.selectedIndexValue + 1, visibleItems.length - 1);
                this.updateSelection();
                break;
            case "ArrowUp":
                event.preventDefault();
                this.selectedIndexValue = Math.max(this.selectedIndexValue - 1, 0);
                this.updateSelection();
                break;
            case "Enter":
                event.preventDefault();
                if (this.selectedIndexValue >= 0 && visibleItems[this.selectedIndexValue]) {
                    this.selectItem(visibleItems[this.selectedIndexValue]);
                }
                break;
            case "Escape":
                if (this.hasInputTarget && this.inputTarget.value) {
                    event.preventDefault();
                    this.inputTarget.value = "";
                    this.filter();
                }
                break;
        }
    }
    /**
     * Select an item via click
     */
    select(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled === "true")
            return;
        this.selectItem(item);
    }
    /**
     * Handle item selection
     */
    selectItem(item) {
        if (!item || item.dataset.disabled === "true")
            return;
        const value = item.dataset.value || item.textContent.trim();
        // Dispatch custom event
        this.dispatch("select", {
            detail: { value, item }
        });
        // Execute onSelect if provided
        if (item.dataset.onSelect) {
            new Function(item.dataset.onSelect)();
        }
    }
    /**
     * Update visual selection state
     */
    updateSelection() {
        const visibleItems = this.getVisibleItems();
        visibleItems.forEach((item, index) => {
            const isSelected = index === this.selectedIndexValue;
            item.dataset.selected = String(isSelected);
            if (isSelected) {
                item.scrollIntoView({ block: "nearest" });
            }
        });
    }
    /**
     * Get all visible (non-hidden, non-disabled) items
     */
    getVisibleItems() {
        return this.itemTargets.filter((item) => !item.hidden && item.dataset.disabled !== "true");
    }
    /**
     * Focus the input when connecting
     */
    focusInput() {
        if (this.hasInputTarget) {
            this.inputTarget.focus();
        }
    }
};

/**
 * Command Dialog controller for command palette in modal
 * Extends dialog functionality with keyboard shortcut support
 */
let default_1$m = class default_1 extends Controller {
    static { this.targets = ["trigger", "template", "overlay", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        shortcut: { type: String, default: "" }
    }; }
    connect() {
        this.portal = null;
        this.previousActiveElement = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        this.boundHandleShortcut = this.handleShortcut.bind(this);
        // Listen for keyboard shortcut
        if (this.shortcutValue) {
            document.addEventListener("keydown", this.boundHandleShortcut);
        }
        if (this.openValue) {
            this.open();
        }
    }
    disconnect() {
        this.close();
        if (this.portal) {
            this.portal.remove();
        }
        document.removeEventListener("keydown", this.boundHandleShortcut);
    }
    /**
     * Handle global keyboard shortcut (e.g., Cmd+K)
     */
    handleShortcut(event) {
        if (!this.shortcutValue)
            return;
        const key = this.shortcutValue.toLowerCase();
        if (event.key.toLowerCase() === key && (event.metaKey || event.ctrlKey)) {
            event.preventDefault();
            this.toggle();
        }
    }
    open() {
        if (this.openValue)
            return;
        this.previousActiveElement = document.activeElement;
        this.openValue = true;
        // Move template content to body
        if (this.hasTemplateTarget && !this.portal) {
            this.portal = document.createElement("div");
            this.portal.className = "shadcn-command-dialog-portal";
            this.portal.innerHTML = this.templateTarget.innerHTML;
            document.body.appendChild(this.portal);
            // Re-query targets from portal
            this.portalOverlay = this.portal.querySelector('[data-shadcn--command-dialog-target="overlay"]');
            this.portalContent = this.portal.querySelector('[data-shadcn--command-dialog-target="content"]');
            // Setup overlay click to close
            if (this.portalOverlay) {
                this.portalOverlay.addEventListener("click", () => this.close());
            }
        }
        // Show overlay and content
        requestAnimationFrame(() => {
            if (this.portalOverlay) {
                this.portalOverlay.dataset.state = "open";
                this.portalOverlay.removeAttribute("hidden");
            }
            if (this.portalContent) {
                this.portalContent.dataset.state = "open";
                this.portalContent.removeAttribute("hidden");
            }
            // Setup event listeners
            document.addEventListener("keydown", this.boundHandleKeydown);
            // Focus the command input
            this.focusInput();
            // Prevent body scroll
            document.body.style.overflow = "hidden";
        });
        this.dispatch("opened");
    }
    close() {
        if (!this.openValue)
            return;
        this.openValue = false;
        if (this.portalOverlay) {
            this.portalOverlay.dataset.state = "closed";
        }
        if (this.portalContent) {
            this.portalContent.dataset.state = "closed";
        }
        // Remove event listeners
        document.removeEventListener("keydown", this.boundHandleKeydown);
        // Restore body scroll
        document.body.style.overflow = "";
        // Return focus
        if (this.previousActiveElement) {
            this.previousActiveElement.focus();
        }
        // Remove portal after animation
        setTimeout(() => {
            if (this.portal) {
                this.portal.remove();
                this.portal = null;
            }
        }, 200);
        this.dispatch("closed");
    }
    toggle() {
        if (this.openValue) {
            this.close();
        }
        else {
            this.open();
        }
    }
    handleKeydown(event) {
        if (event.key === "Escape") {
            this.close();
        }
    }
    focusInput() {
        if (!this.portalContent)
            return;
        const input = this.portalContent.querySelector('input[data-shadcn--command-target="input"]');
        if (input) {
            setTimeout(() => input.focus(), 50);
        }
    }
    openValueChanged() {
        if (this.openValue) {
            this.open();
        }
        else {
            this.close();
        }
    }
};

/**
 * Context Menu controller for right-click menus
 * Extends BaseMenuController with Floating UI positioning at cursor location
 */
let default_1$l = class default_1 extends default_1$v {
    static { this.targets = [...default_1$v.targets]; }
    static { this.values = {
        ...default_1$v.values,
        hideDelay: { type: Number, default: 100 }
    }; }
    connect() {
        super.connect();
        this.boundHandleContextMenu = this.handleContextMenu.bind(this);
        this.originalOverflow = null;
        this.mouseX = 0;
        this.mouseY = 0;
        this._ignoreClickOutside = false;
    }
    // Override clickOutside to handle the deferred close behavior
    // Context menus need to ignore clicks in the same frame as the right-click
    clickOutside(event) {
        if (this._ignoreClickOutside)
            return;
        super.clickOutside(event);
    }
    show(event) {
        event?.preventDefault();
        // Cancel any pending hide timeout from a previous close
        this.cancelHideTimeout();
        // Store mouse position for positioning
        this.mouseX = event?.clientX || 0;
        this.mouseY = event?.clientY || 0;
        this.openValue = true;
        // Lock scroll (only if not already locked)
        if (document.body.style.overflow !== "hidden") {
            this.originalOverflow = document.body.style.overflow;
            document.body.style.overflow = "hidden";
        }
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            this.positionContent();
        }
        // Defer click outside detection to prevent immediate close from right-click
        // The contextmenu event can sometimes trigger a click in the same event cycle
        this._ignoreClickOutside = true;
        requestAnimationFrame(() => {
            this._ignoreClickOutside = false;
            if (this.openValue) {
                document.addEventListener("contextmenu", this.boundHandleContextMenu);
            }
        });
        document.addEventListener("keydown", this.boundHandleKeydown);
        // Focus first item
        this.focusedIndex = -1;
        this.focusNextItem();
        this.dispatch("opened");
    }
    hide() {
        if (!this.openValue)
            return;
        this.openValue = false;
        // Remove event listeners immediately to prevent double-triggering
        document.removeEventListener("contextmenu", this.boundHandleContextMenu);
        document.removeEventListener("keydown", this.boundHandleKeydown);
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            // Wait for animation to complete before hiding and restoring scroll
            // Animation duration is 100ms, add buffer for smooth transition
            this.hideTimeoutId = setTimeout(() => {
                if (!this.openValue) {
                    this.contentTarget.hidden = true;
                    // Restore scroll only after menu is fully hidden
                    document.body.style.overflow = this.originalOverflow || "";
                }
                this.hideTimeoutId = null;
            }, this.hideDelayValue);
        }
        else {
            // No content target, restore scroll immediately
            document.body.style.overflow = this.originalOverflow || "";
        }
        // Reset focus index
        this.focusedIndex = -1;
        this.dispatch("closed");
    }
    handleContextMenu(event) {
        // Don't close if right-clicking on the trigger element
        // This allows show() to be called again to reposition the menu
        if (this.hasTriggerTarget && this.triggerTarget.contains(event.target)) {
            return;
        }
        // Close if right-clicking outside the content
        if (this.hasContentTarget && !this.contentTarget.contains(event.target)) {
            this.hide();
        }
    }
    shouldCloseOnClickOutside(event) {
        // Don't close if clicking inside the content
        if (this.hasContentTarget && this.contentTarget.contains(event.target)) {
            return false;
        }
        return true;
    }
    positionContent() {
        if (!this.hasContentTarget)
            return;
        // Use Floating UI for smart positioning at cursor location
        positionAtPoint(this.contentTarget, this.mouseX, this.mouseY);
    }
};

/**
 * Dialog controller for modal dialogs
 * Handles opening, closing, focus trapping, and keyboard navigation
 */
let default_1$k = class default_1 extends Controller {
    static { this.targets = ["trigger", "template", "overlay", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        modal: { type: Boolean, default: true }
    }; }
    connect() {
        this.portal = null;
        this.previousActiveElement = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        this.boundHandleClickOutside = this.handleClickOutside.bind(this);
        if (this.openValue) {
            this.open();
        }
    }
    disconnect() {
        this.close();
        if (this.portal) {
            this.portal.remove();
        }
    }
    open() {
        if (this.openValue)
            return;
        this.previousActiveElement = document.activeElement;
        this.openValue = true;
        // Move template content to body
        if (this.hasTemplateTarget && !this.portal) {
            this.portal = document.createElement("div");
            this.portal.className = "shadcn-dialog-portal";
            this.portal.innerHTML = this.templateTarget.innerHTML;
            document.body.appendChild(this.portal);
            // Re-query targets from portal
            this.portalOverlay = this.portal.querySelector('[data-shadcn--dialog-target="overlay"]');
            this.portalContent = this.portal.querySelector('[data-shadcn--dialog-target="content"]');
            // Wire up close actions on portal elements (since they're outside controller scope)
            this.portal.querySelectorAll('[data-action*="shadcn--dialog#close"]').forEach((el) => {
                el.addEventListener("click", (e) => {
                    e.preventDefault();
                    this.close();
                });
            });
            // Also handle overlay click
            if (this.portalOverlay) {
                this.portalOverlay.addEventListener("click", () => this.close());
            }
        }
        // Show overlay and content
        requestAnimationFrame(() => {
            if (this.portalOverlay) {
                this.portalOverlay.dataset.state = "open";
                this.portalOverlay.removeAttribute("hidden");
            }
            if (this.portalContent) {
                this.portalContent.dataset.state = "open";
                this.portalContent.removeAttribute("hidden");
            }
            // Setup event listeners
            document.addEventListener("keydown", this.boundHandleKeydown);
            // Focus first focusable element
            this.focusFirstElement();
            // Prevent body scroll
            if (this.modalValue) {
                document.body.style.overflow = "hidden";
            }
        });
        this.dispatch("opened");
    }
    close() {
        if (!this.openValue)
            return;
        this.openValue = false;
        if (this.portalOverlay) {
            this.portalOverlay.dataset.state = "closed";
        }
        if (this.portalContent) {
            this.portalContent.dataset.state = "closed";
        }
        // Remove event listeners
        document.removeEventListener("keydown", this.boundHandleKeydown);
        // Restore body scroll
        document.body.style.overflow = "";
        // Return focus
        if (this.previousActiveElement) {
            this.previousActiveElement.focus();
        }
        // Remove portal after animation
        setTimeout(() => {
            if (this.portal) {
                this.portal.remove();
                this.portal = null;
            }
        }, 200);
        this.dispatch("closed");
    }
    toggle() {
        if (this.openValue) {
            this.close();
        }
        else {
            this.open();
        }
    }
    handleKeydown(event) {
        if (event.key === "Escape") {
            this.close();
        }
        else if (event.key === "Tab" && this.modalValue) {
            this.trapFocus(event);
        }
    }
    handleClickOutside(event) {
        if (this.portalContent && !this.portalContent.contains(event.target)) {
            this.close();
        }
    }
    focusFirstElement() {
        if (!this.portalContent)
            return;
        const focusable = this.portalContent.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
        if (focusable.length > 0) {
            focusable[0].focus();
        }
        else {
            this.portalContent.focus();
        }
    }
    trapFocus(event) {
        if (!this.portalContent)
            return;
        const focusable = this.portalContent.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
        const firstFocusable = focusable[0];
        const lastFocusable = focusable[focusable.length - 1];
        if (event.shiftKey) {
            if (document.activeElement === firstFocusable) {
                lastFocusable.focus();
                event.preventDefault();
            }
        }
        else {
            if (document.activeElement === lastFocusable) {
                firstFocusable.focus();
                event.preventDefault();
            }
        }
    }
    openValueChanged() {
        if (this.openValue) {
            this.open();
        }
        else {
            this.close();
        }
    }
};

/**
 * Drawer Controller
 * Handles opening/closing drawer panels with swipe support
 */
let default_1$j = class default_1 extends Controller {
    static { this.targets = ["trigger", "template", "overlay", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        direction: { type: String, default: "bottom" }
    }; }
    connect() {
        this.portal = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        if (this.openValue) {
            this.open();
        }
    }
    disconnect() {
        this.removePortal();
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    open() {
        if (!this.hasTemplateTarget)
            return;
        // Create portal at body level
        this.portal = document.createElement("div");
        this.portal.innerHTML = this.templateTarget.innerHTML;
        document.body.appendChild(this.portal);
        // Get references to portal elements
        const overlay = this.portal.querySelector("[data-shadcn--drawer-target='overlay']");
        const content = this.portal.querySelector("[data-shadcn--drawer-target='content']");
        // Add click handler to overlay
        if (overlay) {
            overlay.addEventListener("click", () => this.close());
        }
        // Set open state
        requestAnimationFrame(() => {
            if (overlay)
                overlay.setAttribute("data-state", "open");
            if (content) {
                content.setAttribute("data-state", "open");
                content.focus();
            }
        });
        // Prevent body scroll
        document.body.style.overflow = "hidden";
        document.addEventListener("keydown", this.boundHandleKeydown);
        this.openValue = true;
        this.dispatch("open");
    }
    close() {
        if (!this.portal)
            return;
        const overlay = this.portal.querySelector("[data-shadcn--drawer-target='overlay']");
        const content = this.portal.querySelector("[data-shadcn--drawer-target='content']");
        // Set closing state
        if (overlay)
            overlay.setAttribute("data-state", "closed");
        if (content)
            content.setAttribute("data-state", "closed");
        // Wait for animation then remove portal
        setTimeout(() => {
            this.removePortal();
        }, 200);
        document.body.style.overflow = "";
        document.removeEventListener("keydown", this.boundHandleKeydown);
        this.openValue = false;
        this.dispatch("close");
    }
    toggle() {
        if (this.openValue) {
            this.close();
        }
        else {
            this.open();
        }
    }
    handleKeydown(event) {
        if (event.key === "Escape") {
            this.close();
        }
    }
    removePortal() {
        if (this.portal) {
            this.portal.remove();
            this.portal = null;
        }
    }
    openValueChanged() {
        if (this.openValue && !this.portal) {
            this.open();
        }
        else if (!this.openValue && this.portal) {
            this.close();
        }
    }
};

/**
 * Dropdown controller for dropdown menus
 * Extends BaseMenuController with Floating UI positioning
 */
let default_1$i = class default_1 extends default_1$v {
    static { this.targets = [...default_1$v.targets]; }
    static { this.values = {
        ...default_1$v.values,
        align: { type: String, default: "end" },
        side: { type: String, default: "bottom" }
    }; }
    connect() {
        this.cleanupFloating = null;
        super.connect();
    }
    disconnect() {
        this.cleanupPositioning();
        super.disconnect();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    get placement() {
        // Convert side/align to Floating UI placement
        const align = this.alignValue === "center" ? "" : `-${this.alignValue}`;
        return `${this.sideValue}${align}`;
    }
    positionContent() {
        if (!this.hasContentTarget || !this.hasTriggerTarget)
            return;
        // Use Floating UI for smart positioning
        this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
            placement: this.placement,
            offset: 4,
            sameWidth: false
        });
    }
    hideMenu() {
        this.cleanupPositioning();
        super.hideMenu();
    }
    toggleCheckbox(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const isChecked = item.dataset.state === "checked";
        item.dataset.state = isChecked ? "unchecked" : "checked";
        item.setAttribute("aria-checked", (!isChecked).toString());
        // Toggle the check icon visibility
        const indicator = item.querySelector("span svg");
        if (indicator) {
            indicator.style.display = isChecked ? "none" : "block";
        }
        this.dispatch("check", { detail: { item, checked: !isChecked } });
    }
    selectRadio(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const group = item.closest("[role='group']");
        if (group) {
            // Uncheck all radio items in the group
            group.querySelectorAll("[role='menuitemradio']").forEach((radio) => {
                radio.dataset.state = "unchecked";
                radio.setAttribute("aria-checked", "false");
                const indicator = radio.querySelector("span svg");
                if (indicator)
                    indicator.style.display = "none";
            });
        }
        // Check this item
        item.dataset.state = "checked";
        item.setAttribute("aria-checked", "true");
        const indicator = item.querySelector("span svg");
        if (indicator)
            indicator.style.display = "block";
        this.dispatch("radioChange", { detail: { item, value: item.dataset.value } });
    }
};

/**
 * Hover Card Controller
 * Handles showing/hiding content on hover with delays
 * Uses Floating UI for smart positioning
 */
let default_1$h = class default_1 extends Controller {
    static { this.targets = ["trigger", "content"]; }
    static { this.values = {
        openDelay: { type: Number, default: 700 },
        closeDelay: { type: Number, default: 300 },
        side: { type: String, default: "bottom" },
        align: { type: String, default: "center" }
    }; }
    connect() {
        this.openTimeout = null;
        this.closeTimeout = null;
        this.isOpen = false;
        this.cleanupFloating = null;
        this.triggerTarget.addEventListener("mouseenter", this.scheduleOpen.bind(this));
        this.triggerTarget.addEventListener("mouseleave", this.scheduleClose.bind(this));
        this.triggerTarget.addEventListener("focus", this.scheduleOpen.bind(this));
        this.triggerTarget.addEventListener("blur", this.scheduleClose.bind(this));
        this.contentTarget.addEventListener("mouseenter", this.cancelClose.bind(this));
        this.contentTarget.addEventListener("mouseleave", this.scheduleClose.bind(this));
    }
    disconnect() {
        this.clearTimeouts();
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    get placement() {
        // Convert side/align to Floating UI placement
        const align = this.alignValue === "center" ? "" : `-${this.alignValue}`;
        return `${this.sideValue}${align}`;
    }
    scheduleOpen() {
        this.clearTimeouts();
        this.openTimeout = setTimeout(() => {
            this.open();
        }, this.openDelayValue);
    }
    scheduleClose() {
        this.clearTimeouts();
        this.closeTimeout = setTimeout(() => {
            this.close();
        }, this.closeDelayValue);
    }
    cancelClose() {
        if (this.closeTimeout) {
            clearTimeout(this.closeTimeout);
            this.closeTimeout = null;
        }
    }
    clearTimeouts() {
        if (this.openTimeout) {
            clearTimeout(this.openTimeout);
            this.openTimeout = null;
        }
        if (this.closeTimeout) {
            clearTimeout(this.closeTimeout);
            this.closeTimeout = null;
        }
    }
    open() {
        if (this.isOpen)
            return;
        this.isOpen = true;
        this.contentTarget.style.display = "block";
        this.contentTarget.setAttribute("data-state", "open");
        // Use Floating UI for smart positioning
        this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
            placement: this.placement,
            offset: 8
        });
        this.dispatch("open");
    }
    close() {
        if (!this.isOpen)
            return;
        this.isOpen = false;
        this.contentTarget.setAttribute("data-state", "closed");
        // Cleanup Floating UI
        this.cleanupPositioning();
        // Wait for animation to complete
        setTimeout(() => {
            if (!this.isOpen) {
                this.contentTarget.style.display = "none";
            }
        }, 150);
        this.dispatch("close");
    }
};

/**
 * Menubar controller
 * Handles menu opening/closing, keyboard navigation, hover behavior
 * Uses stimulus-use for click outside detection
 */
let default_1$g = class default_1 extends Controller {
    static { this.targets = ["menu", "trigger", "content", "item", "sub", "subTrigger", "subContent"]; }
    static { this.values = {
        openIndex: { type: Number, default: -1 }
    }; }
    connect() {
        this.focusedIndex = -1;
        this.isMenuOpen = false;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        this.closeSubTimer = null;
        // Use stimulus-use for click outside detection
        useClickOutside(this);
    }
    disconnect() {
        this.closeAll();
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    toggle(event) {
        event?.preventDefault();
        const trigger = event.currentTarget;
        const menu = trigger.closest("[data-shadcn--menubar-target='menu']");
        const menuIndex = this.menuTargets.indexOf(menu);
        if (this.openIndexValue === menuIndex) {
            this.closeAll();
        }
        else {
            this.openMenu(menuIndex);
        }
    }
    hoverOpen(event) {
        // Only open on hover if a menu is already open
        if (!this.isMenuOpen)
            return;
        const trigger = event.currentTarget;
        const menu = trigger.closest("[data-shadcn--menubar-target='menu']");
        const menuIndex = this.menuTargets.indexOf(menu);
        if (this.openIndexValue !== menuIndex) {
            this.openMenu(menuIndex);
        }
    }
    openMenu(index) {
        // Close any currently open menu
        this.closeAllMenus();
        if (index < 0 || index >= this.menuTargets.length)
            return;
        const menu = this.menuTargets[index];
        const trigger = menu.querySelector("[data-shadcn--menubar-target='trigger']");
        const content = menu.querySelector("[data-shadcn--menubar-target='content']");
        if (trigger && content) {
            trigger.setAttribute("aria-expanded", "true");
            trigger.dataset.state = "open";
            content.hidden = false;
            content.dataset.state = "open";
            this.positionContent(trigger, content);
        }
        this.openIndexValue = index;
        this.isMenuOpen = true;
        this.focusedIndex = -1;
        // Add keydown event listener (click outside is handled by stimulus-use)
        document.addEventListener("keydown", this.boundHandleKeydown);
        // Focus first item
        this.focusNextItem();
    }
    closeAllMenus() {
        this.triggerTargets.forEach((trigger) => {
            trigger.setAttribute("aria-expanded", "false");
            trigger.dataset.state = "closed";
        });
        this.contentTargets.forEach((content) => {
            content.dataset.state = "closed";
            content.hidden = true;
        });
        this.closeAllSubs();
    }
    closeAll() {
        this.closeAllMenus();
        this.openIndexValue = -1;
        this.isMenuOpen = false;
        this.focusedIndex = -1;
        // Remove keydown listener (click outside is handled by stimulus-use)
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    selectItem(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        this.dispatch("select", { detail: { item } });
        this.closeAll();
    }
    toggleCheckbox(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const isChecked = item.dataset.state === "checked";
        item.dataset.state = isChecked ? "unchecked" : "checked";
        item.setAttribute("aria-checked", (!isChecked).toString());
        // Toggle the check icon visibility
        const indicator = item.querySelector("span svg");
        if (indicator) {
            indicator.style.display = isChecked ? "none" : "block";
        }
        this.dispatch("check", { detail: { item, checked: !isChecked } });
    }
    selectRadio(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const group = item.closest("[role='group']");
        if (group) {
            // Uncheck all radio items in the group
            group.querySelectorAll("[role='menuitemradio']").forEach((radio) => {
                radio.dataset.state = "unchecked";
                radio.setAttribute("aria-checked", "false");
                const indicator = radio.querySelector("span svg");
                if (indicator)
                    indicator.style.display = "none";
            });
        }
        // Check this item
        item.dataset.state = "checked";
        item.setAttribute("aria-checked", "true");
        const indicator = item.querySelector("span svg");
        if (indicator)
            indicator.style.display = "block";
        this.dispatch("radioChange", { detail: { item, value: item.dataset.value } });
    }
    // Submenu handling
    openSub(event) {
        this.cancelCloseSubTimer();
        const subTrigger = event.currentTarget;
        const sub = subTrigger.closest("[data-shadcn--menubar-target='sub']");
        const subContent = sub?.querySelector("[data-shadcn--menubar-target='subContent']");
        if (subTrigger && subContent) {
            // Close other submenus at the same level
            this.closeAllSubs();
            subTrigger.setAttribute("aria-expanded", "true");
            subTrigger.dataset.state = "open";
            subContent.hidden = false;
            subContent.dataset.state = "open";
            this.positionSubContent(subTrigger, subContent);
        }
    }
    startCloseSubTimer() {
        this.closeSubTimer = setTimeout(() => {
            this.closeAllSubs();
        }, 100);
    }
    cancelCloseSubTimer() {
        if (this.closeSubTimer) {
            clearTimeout(this.closeSubTimer);
            this.closeSubTimer = null;
        }
    }
    closeAllSubs() {
        this.subTriggerTargets.forEach((trigger) => {
            trigger.setAttribute("aria-expanded", "false");
            trigger.dataset.state = "closed";
        });
        this.subContentTargets.forEach((content) => {
            content.dataset.state = "closed";
            content.hidden = true;
        });
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.isMenuOpen) {
            this.closeAll();
        }
    }
    handleKeydown(event) {
        switch (event.key) {
            case "Escape":
                this.closeAll();
                if (this.openIndexValue >= 0) {
                    this.triggerTargets[this.openIndexValue]?.focus();
                }
                break;
            case "ArrowDown":
                event.preventDefault();
                this.focusNextItem();
                break;
            case "ArrowUp":
                event.preventDefault();
                this.focusPreviousItem();
                break;
            case "ArrowRight":
                event.preventDefault();
                this.openNextMenu();
                break;
            case "ArrowLeft":
                event.preventDefault();
                this.openPreviousMenu();
                break;
            case "Home":
                event.preventDefault();
                this.focusFirstItem();
                break;
            case "End":
                event.preventDefault();
                this.focusLastItem();
                break;
            case "Enter":
            case " ":
                event.preventDefault();
                this.selectFocusedItem();
                break;
        }
    }
    openNextMenu() {
        const nextIndex = (this.openIndexValue + 1) % this.menuTargets.length;
        this.openMenu(nextIndex);
    }
    openPreviousMenu() {
        const prevIndex = this.openIndexValue <= 0 ? this.menuTargets.length - 1 : this.openIndexValue - 1;
        this.openMenu(prevIndex);
    }
    focusNextItem() {
        const items = this.currentMenuItems;
        if (items.length === 0)
            return;
        this.focusedIndex = (this.focusedIndex + 1) % items.length;
        items[this.focusedIndex].focus();
    }
    focusPreviousItem() {
        const items = this.currentMenuItems;
        if (items.length === 0)
            return;
        this.focusedIndex = this.focusedIndex <= 0 ? items.length - 1 : this.focusedIndex - 1;
        items[this.focusedIndex].focus();
    }
    focusFirstItem() {
        const items = this.currentMenuItems;
        if (items.length === 0)
            return;
        this.focusedIndex = 0;
        items[0].focus();
    }
    focusLastItem() {
        const items = this.currentMenuItems;
        if (items.length === 0)
            return;
        this.focusedIndex = items.length - 1;
        items[this.focusedIndex].focus();
    }
    selectFocusedItem() {
        const items = this.currentMenuItems;
        if (this.focusedIndex >= 0 && this.focusedIndex < items.length) {
            items[this.focusedIndex].click();
        }
    }
    get currentMenuItems() {
        if (this.openIndexValue < 0)
            return [];
        const menu = this.menuTargets[this.openIndexValue];
        if (!menu)
            return [];
        const content = menu.querySelector("[data-shadcn--menubar-target='content']");
        if (!content)
            return [];
        return Array.from(content.querySelectorAll("[data-shadcn--menubar-target='item']"))
            .filter(item => item.dataset.disabled === undefined);
    }
    positionContent(trigger, content) {
        trigger.getBoundingClientRect();
        content.style.position = "absolute";
        content.style.top = "100%";
        content.style.left = "0";
        content.style.marginTop = "4px";
    }
    positionSubContent(trigger, content) {
        content.style.position = "absolute";
        content.style.top = "0";
        content.style.left = "100%";
        content.style.marginLeft = "2px";
    }
};

/**
 * Navigation Menu Controller
 * Handles navigation menu interactions with dropdown content areas
 * Uses stimulus-use for click outside detection
 */
let default_1$f = class default_1 extends Controller {
    static { this.targets = ["list", "item", "trigger", "content", "viewport"]; }
    static { this.values = {
        openIndex: { type: Number, default: -1 },
        delayDuration: { type: Number, default: 200 },
        skipDelayDuration: { type: Number, default: 300 }
    }; }
    connect() {
        this.isOpen = false;
        this.previousIndex = -1;
        this.openTimer = null;
        this.closeTimer = null;
        this.wasClickOpened = false;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        // Use stimulus-use for click outside detection
        useClickOutside(this);
    }
    disconnect() {
        this.closeAll();
        this.clearTimers();
    }
    toggle(event) {
        event?.preventDefault();
        const trigger = event.currentTarget;
        const item = trigger.closest("[data-shadcn--navigation-menu-target='item']");
        const index = this.itemTargets.indexOf(item);
        this.clearTimers();
        if (this.openIndexValue === index) {
            this.closeAll();
        }
        else {
            this.wasClickOpened = true;
            this.openItem(index);
        }
    }
    hoverOpen(event) {
        // If opened by click, require click to close
        if (this.wasClickOpened && this.isOpen)
            return;
        const trigger = event.currentTarget;
        const item = trigger.closest("[data-shadcn--navigation-menu-target='item']");
        const index = this.itemTargets.indexOf(item);
        this.clearTimers();
        if (this.isOpen) {
            // Already open, switch immediately
            if (this.openIndexValue !== index) {
                this.openItem(index);
            }
        }
        else {
            // Not open, delay before opening
            this.openTimer = setTimeout(() => {
                this.openItem(index);
            }, this.delayDurationValue);
        }
    }
    hoverClose(event) {
        // If opened by click, require click to close
        if (this.wasClickOpened)
            return;
        this.clearTimers();
        this.closeTimer = setTimeout(() => {
            this.closeAll();
        }, this.skipDelayDurationValue);
    }
    contentHover() {
        // Cancel close timer when hovering content
        this.clearTimers();
    }
    openItem(index) {
        if (index < 0 || index >= this.itemTargets.length)
            return;
        // Close previous if different
        if (this.openIndexValue !== -1 && this.openIndexValue !== index) {
            this.closeItem(this.openIndexValue);
        }
        const item = this.itemTargets[index];
        const trigger = item.querySelector("[data-shadcn--navigation-menu-target='trigger']");
        const content = item.querySelector("[data-shadcn--navigation-menu-target='content']");
        if (!trigger || !content)
            return;
        this.previousIndex = this.openIndexValue;
        this.openIndexValue = index;
        // Update trigger state
        trigger.setAttribute("aria-expanded", "true");
        trigger.dataset.state = "open";
        // Show content
        content.hidden = false;
        content.dataset.state = "open";
        // Set motion direction for animation
        if (this.previousIndex !== -1 && this.previousIndex !== index) {
            content.dataset.motion = this.previousIndex < index ? "from-end" : "from-start";
        }
        else {
            content.dataset.motion = "from-start";
        }
        // Update viewport
        if (this.hasViewportTarget) {
            this.viewportTarget.hidden = false;
            this.viewportTarget.dataset.state = "open";
            this.viewportTarget.innerHTML = content.innerHTML;
            this.positionViewport(item);
        }
        this.isOpen = true;
        // Add keydown event listener (click outside is handled by stimulus-use)
        document.addEventListener("keydown", this.boundHandleKeydown);
    }
    closeItem(index) {
        if (index < 0 || index >= this.itemTargets.length)
            return;
        const item = this.itemTargets[index];
        const trigger = item.querySelector("[data-shadcn--navigation-menu-target='trigger']");
        const content = item.querySelector("[data-shadcn--navigation-menu-target='content']");
        if (trigger) {
            trigger.setAttribute("aria-expanded", "false");
            trigger.dataset.state = "closed";
        }
        if (content) {
            content.dataset.state = "closed";
            content.dataset.motion = this.previousIndex < index ? "to-end" : "to-start";
            setTimeout(() => {
                if (content.dataset.state === "closed") {
                    content.hidden = true;
                }
            }, 150);
        }
    }
    closeAll() {
        this.triggerTargets.forEach((trigger) => {
            trigger.setAttribute("aria-expanded", "false");
            trigger.dataset.state = "closed";
        });
        this.contentTargets.forEach((content) => {
            content.dataset.state = "closed";
            setTimeout(() => {
                if (content.dataset.state === "closed") {
                    content.hidden = true;
                }
            }, 150);
        });
        if (this.hasViewportTarget) {
            this.viewportTarget.dataset.state = "closed";
            setTimeout(() => {
                if (this.viewportTarget.dataset.state === "closed") {
                    this.viewportTarget.hidden = true;
                    this.viewportTarget.innerHTML = "";
                }
            }, 150);
        }
        this.openIndexValue = -1;
        this.previousIndex = -1;
        this.isOpen = false;
        this.wasClickOpened = false;
        // Remove keydown listener (click outside is handled by stimulus-use)
        document.removeEventListener("keydown", this.boundHandleKeydown);
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.isOpen) {
            this.closeAll();
        }
    }
    handleKeydown(event) {
        switch (event.key) {
            case "Escape":
                this.closeAll();
                if (this.openIndexValue >= 0) {
                    this.triggerTargets[this.openIndexValue]?.focus();
                }
                break;
            case "ArrowRight":
                event.preventDefault();
                this.navigateToNextItem();
                break;
            case "ArrowLeft":
                event.preventDefault();
                this.navigateToPreviousItem();
                break;
        }
    }
    navigateToNextItem() {
        const nextIndex = (this.openIndexValue + 1) % this.itemTargets.length;
        this.openItem(nextIndex);
        const trigger = this.itemTargets[nextIndex].querySelector("[data-shadcn--navigation-menu-target='trigger']");
        trigger?.focus();
    }
    navigateToPreviousItem() {
        const prevIndex = this.openIndexValue <= 0 ? this.itemTargets.length - 1 : this.openIndexValue - 1;
        this.openItem(prevIndex);
        const trigger = this.itemTargets[prevIndex].querySelector("[data-shadcn--navigation-menu-target='trigger']");
        trigger?.focus();
    }
    clearTimers() {
        if (this.openTimer) {
            clearTimeout(this.openTimer);
            this.openTimer = null;
        }
        if (this.closeTimer) {
            clearTimeout(this.closeTimer);
            this.closeTimer = null;
        }
    }
    positionViewport(item) {
        if (!this.hasViewportTarget)
            return;
        const content = item.querySelector("[data-shadcn--navigation-menu-target='content']");
        if (content) {
            // Set CSS custom properties for width/height based on content
            const rect = content.getBoundingClientRect();
            this.viewportTarget.style.setProperty("--radix-navigation-menu-viewport-width", `${rect.width}px`);
            this.viewportTarget.style.setProperty("--radix-navigation-menu-viewport-height", `${rect.height}px`);
        }
    }
};

/**
 * Popover controller for rich content overlays
 * Uses Floating UI for smart positioning and stimulus-use for click outside detection
 */
let default_1$e = class default_1 extends Controller {
    static { this.targets = ["trigger", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        side: { type: String, default: "bottom" },
        align: { type: String, default: "center" },
        modal: { type: Boolean, default: false }
    }; }
    connect() {
        this.cleanupFloating = null;
        // Use stimulus-use for click outside detection
        useClickOutside(this);
        if (this.openValue) {
            this.show();
        }
    }
    disconnect() {
        this.hide();
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    get placement() {
        // Convert side/align to Floating UI placement
        const align = this.alignValue === "center" ? "" : `-${this.alignValue}`;
        return `${this.sideValue}${align}`;
    }
    toggle(event) {
        event?.preventDefault();
        if (this.openValue) {
            this.hide();
        }
        else {
            this.show();
        }
    }
    show() {
        if (this.openValue)
            return;
        this.openValue = true;
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            // Use Floating UI for smart positioning
            if (this.hasTriggerTarget) {
                this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
                    placement: this.placement,
                    offset: 8
                });
            }
        }
        if (this.modalValue) {
            document.body.style.pointerEvents = "none";
            this.contentTarget.style.pointerEvents = "auto";
        }
        this.dispatch("opened");
    }
    hide() {
        if (!this.openValue)
            return;
        this.openValue = false;
        // Cleanup Floating UI auto-update
        this.cleanupPositioning();
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            setTimeout(() => {
                if (!this.openValue) {
                    this.contentTarget.hidden = true;
                }
            }, 150);
        }
        if (this.modalValue) {
            document.body.style.pointerEvents = "";
        }
        this.dispatch("closed");
    }
    close() {
        this.hide();
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.openValue) {
            this.hide();
        }
    }
};

/**
 * Resizable Panel Controller
 * Handles resizable panel layouts with keyboard and mouse support
 */
let default_1$d = class default_1 extends Controller {
    static { this.targets = ["panel", "handle"]; }
    static { this.values = {
        direction: { type: String, default: "horizontal" },
        autoSaveId: String
    }; }
    connect() {
        this.isDragging = false;
        this.currentHandle = null;
        this.startPosition = 0;
        this.startSizes = [];
        // Bind methods
        this.boundResize = this.resize.bind(this);
        this.boundStopResize = this.stopResize.bind(this);
        // Load saved sizes if autoSaveId is set
        if (this.hasAutoSaveIdValue) {
            this.loadSavedSizes();
        }
        // Add keyboard support
        this.handleTargets.forEach((handle) => {
            handle.addEventListener('keydown', this.handleKeydown.bind(this));
        });
    }
    disconnect() {
        document.removeEventListener('mousemove', this.boundResize);
        document.removeEventListener('mouseup', this.boundStopResize);
        document.removeEventListener('touchmove', this.boundResize);
        document.removeEventListener('touchend', this.boundStopResize);
    }
    startResize(event) {
        event.preventDefault();
        this.isDragging = true;
        this.currentHandle = event.currentTarget;
        this.currentHandle.dataset.state = "dragging";
        // Get the position based on event type
        const position = event.type.includes('touch')
            ? (this.isHorizontal ? event.touches[0].clientX : event.touches[0].clientY)
            : (this.isHorizontal ? event.clientX : event.clientY);
        this.startPosition = position;
        // Find adjacent panels
        this.findAdjacentPanels();
        // Store initial sizes
        this.storePanelSizes();
        // Add document listeners
        document.addEventListener('mousemove', this.boundResize);
        document.addEventListener('mouseup', this.boundStopResize);
        document.addEventListener('touchmove', this.boundResize, { passive: false });
        document.addEventListener('touchend', this.boundStopResize);
        // Prevent text selection during drag
        document.body.style.userSelect = 'none';
        document.body.style.cursor = this.isHorizontal ? 'col-resize' : 'row-resize';
    }
    resize(event) {
        if (!this.isDragging)
            return;
        event.preventDefault();
        const position = event.type.includes('touch')
            ? (this.isHorizontal ? event.touches[0].clientX : event.touches[0].clientY)
            : (this.isHorizontal ? event.clientX : event.clientY);
        const delta = position - this.startPosition;
        const containerSize = this.isHorizontal
            ? this.element.offsetWidth
            : this.element.offsetHeight;
        const deltaPercent = (delta / containerSize) * 100;
        if (this.prevPanel && this.nextPanel) {
            const prevSize = this.prevPanelStartSize + deltaPercent;
            const nextSize = this.nextPanelStartSize - deltaPercent;
            // Get min/max constraints
            const prevMin = parseFloat(this.prevPanel.dataset.minSize) || 0;
            const prevMax = parseFloat(this.prevPanel.dataset.maxSize) || 100;
            const nextMin = parseFloat(this.nextPanel.dataset.minSize) || 0;
            const nextMax = parseFloat(this.nextPanel.dataset.maxSize) || 100;
            // Apply constraints
            if (prevSize >= prevMin && prevSize <= prevMax &&
                nextSize >= nextMin && nextSize <= nextMax) {
                this.setPanelSize(this.prevPanel, prevSize);
                this.setPanelSize(this.nextPanel, nextSize);
            }
        }
    }
    stopResize() {
        if (!this.isDragging)
            return;
        this.isDragging = false;
        if (this.currentHandle) {
            this.currentHandle.dataset.state = "";
        }
        document.removeEventListener('mousemove', this.boundResize);
        document.removeEventListener('mouseup', this.boundStopResize);
        document.removeEventListener('touchmove', this.boundResize);
        document.removeEventListener('touchend', this.boundStopResize);
        document.body.style.userSelect = '';
        document.body.style.cursor = '';
        // Save sizes if autoSaveId is set
        if (this.hasAutoSaveIdValue) {
            this.saveSizes();
        }
        this.currentHandle = null;
    }
    handleKeydown(event) {
        const handle = event.currentTarget;
        const step = event.shiftKey ? 10 : 1;
        let delta = 0;
        if (this.isHorizontal) {
            if (event.key === 'ArrowLeft')
                delta = -step;
            if (event.key === 'ArrowRight')
                delta = step;
        }
        else {
            if (event.key === 'ArrowUp')
                delta = -step;
            if (event.key === 'ArrowDown')
                delta = step;
        }
        if (delta !== 0) {
            event.preventDefault();
            this.currentHandle = handle;
            this.findAdjacentPanels();
            this.storePanelSizes();
            if (this.prevPanel && this.nextPanel) {
                const prevSize = this.prevPanelStartSize + delta;
                const nextSize = this.nextPanelStartSize - delta;
                // Get min/max constraints
                const prevMin = parseFloat(this.prevPanel.dataset.minSize) || 0;
                const prevMax = parseFloat(this.prevPanel.dataset.maxSize) || 100;
                const nextMin = parseFloat(this.nextPanel.dataset.minSize) || 0;
                const nextMax = parseFloat(this.nextPanel.dataset.maxSize) || 100;
                if (prevSize >= prevMin && prevSize <= prevMax &&
                    nextSize >= nextMin && nextSize <= nextMax) {
                    this.setPanelSize(this.prevPanel, prevSize);
                    this.setPanelSize(this.nextPanel, nextSize);
                }
            }
            if (this.hasAutoSaveIdValue) {
                this.saveSizes();
            }
        }
        // Home/End keys
        if (event.key === 'Home') {
            event.preventDefault();
            this.collapsePanel('prev');
        }
        if (event.key === 'End') {
            event.preventDefault();
            this.collapsePanel('next');
        }
    }
    findAdjacentPanels() {
        const allElements = Array.from(this.element.children);
        const handleIndex = allElements.indexOf(this.currentHandle);
        // Find the panel before the handle
        this.prevPanel = null;
        for (let i = handleIndex - 1; i >= 0; i--) {
            if (allElements[i].dataset.panel !== undefined) {
                this.prevPanel = allElements[i];
                break;
            }
        }
        // Find the panel after the handle
        this.nextPanel = null;
        for (let i = handleIndex + 1; i < allElements.length; i++) {
            if (allElements[i].dataset.panel !== undefined) {
                this.nextPanel = allElements[i];
                break;
            }
        }
    }
    storePanelSizes() {
        if (this.prevPanel) {
            this.prevPanelStartSize = this.getPanelSize(this.prevPanel);
        }
        if (this.nextPanel) {
            this.nextPanelStartSize = this.getPanelSize(this.nextPanel);
        }
    }
    getPanelSize(panel) {
        const containerSize = this.isHorizontal
            ? this.element.offsetWidth
            : this.element.offsetHeight;
        const panelSize = this.isHorizontal
            ? panel.offsetWidth
            : panel.offsetHeight;
        return (panelSize / containerSize) * 100;
    }
    setPanelSize(panel, percent) {
        panel.style.flexBasis = `${percent}%`;
        panel.dataset.panelSize = String(percent);
    }
    collapsePanel(which) {
        this.findAdjacentPanels();
        this.storePanelSizes();
        if (which === 'prev' && this.prevPanel && this.nextPanel) {
            const prevMin = parseFloat(this.prevPanel.dataset.minSize) || 0;
            this.setPanelSize(this.prevPanel, prevMin);
            this.setPanelSize(this.nextPanel, this.prevPanelStartSize + this.nextPanelStartSize - prevMin);
        }
        else if (which === 'next' && this.prevPanel && this.nextPanel) {
            const nextMin = parseFloat(this.nextPanel.dataset.minSize) || 0;
            this.setPanelSize(this.nextPanel, nextMin);
            this.setPanelSize(this.prevPanel, this.prevPanelStartSize + this.nextPanelStartSize - nextMin);
        }
    }
    saveSizes() {
        const sizes = this.panelTargets.map((panel) => this.getPanelSize(panel));
        localStorage.setItem(`resizable-${this.autoSaveIdValue}`, JSON.stringify(sizes));
    }
    loadSavedSizes() {
        const saved = localStorage.getItem(`resizable-${this.autoSaveIdValue}`);
        if (saved) {
            try {
                const sizes = JSON.parse(saved);
                this.panelTargets.forEach((panel, index) => {
                    if (sizes[index] !== undefined) {
                        this.setPanelSize(panel, sizes[index]);
                    }
                });
            }
            catch (e) {
                console.warn('Failed to load saved panel sizes:', e);
            }
        }
    }
    get isHorizontal() {
        return this.directionValue === 'horizontal';
    }
};

/**
 * Radio Group Controller
 *
 * Handles radio group selection with keyboard navigation
 *
 * Targets:
 * - item: Individual radio buttons
 * - indicator: Visual indicator element
 *
 * Values:
 * - name: Input name for form submission
 * - value: Currently selected value
 */
let default_1$c = class default_1 extends Controller {
    static { this.targets = ["item", "indicator"]; }
    static { this.values = {
        name: String,
        value: String
    }; }
    connect() {
        this.updateSelection();
    }
    select(event) {
        const item = event.currentTarget;
        if (item.disabled)
            return;
        const value = item.dataset.value;
        this.valueValue = value;
        this.updateSelection();
        this.dispatchChange(value);
    }
    handleKeydown(event) {
        const items = this.enabledItems;
        const currentIndex = items.indexOf(event.currentTarget);
        let newIndex = currentIndex;
        switch (event.key) {
            case "ArrowDown":
            case "ArrowRight":
                event.preventDefault();
                newIndex = (currentIndex + 1) % items.length;
                break;
            case "ArrowUp":
            case "ArrowLeft":
                event.preventDefault();
                newIndex = (currentIndex - 1 + items.length) % items.length;
                break;
            case " ":
            case "Enter":
                event.preventDefault();
                this.select(event);
                return;
            default:
                return;
        }
        const newItem = items[newIndex];
        newItem.focus();
        // Auto-select on arrow navigation (standard radio behavior)
        this.valueValue = newItem.dataset.value;
        this.updateSelection();
        this.dispatchChange(newItem.dataset.value);
    }
    updateSelection() {
        this.itemTargets.forEach((item) => {
            const isSelected = item.dataset.value === this.valueValue;
            if (item.matches('input[type="radio"]')) {
                item.checked = isSelected;
            }
            item.setAttribute("aria-checked", isSelected.toString());
            item.dataset.state = isSelected ? "checked" : "unchecked";
            item.tabIndex = isSelected ? 0 : -1;
            // Update indicator visibility
            const indicator = item.querySelector("[data-shadcn--radio-group-target='indicator']");
            if (indicator) {
                indicator.classList.toggle("opacity-0", !isSelected);
            }
        });
        // Ensure at least one item is focusable if nothing selected
        if (!this.valueValue && this.itemTargets.length > 0) {
            this.enabledItems[0]?.setAttribute("tabindex", "0");
        }
    }
    dispatchChange(value) {
        this.dispatch("change", {
            detail: { value, name: this.nameValue }
        });
        // Also dispatch a native input event for form compatibility
        const event = new Event("input", { bubbles: true });
        this.element.dispatchEvent(event);
    }
    get enabledItems() {
        return this.itemTargets.filter((item) => !item.disabled);
    }
    // Allow programmatic value setting
    valueValueChanged() {
        this.updateSelection();
    }
};

/**
 * Scroll Area controller for custom scrollbars
 */
let default_1$b = class default_1 extends Controller {
    static { this.targets = ["viewport", "scrollbar", "thumb"]; }
    static { this.values = {
        orientation: { type: String, default: "vertical" },
        type: { type: String, default: "hover" }
    }; }
    connect() {
        this.updateScrollbar();
        if (this.hasViewportTarget) {
            this.viewportTarget.addEventListener("scroll", this.handleScroll.bind(this));
        }
        // Show scrollbar based on type
        if (this.typeValue === "always") {
            this.showScrollbar();
        }
    }
    disconnect() {
        if (this.hasViewportTarget) {
            this.viewportTarget.removeEventListener("scroll", this.handleScroll.bind(this));
        }
    }
    handleScroll() {
        this.updateScrollbar();
    }
    updateScrollbar() {
        if (!this.hasViewportTarget || !this.hasThumbTarget)
            return;
        const viewport = this.viewportTarget;
        const thumb = this.thumbTarget;
        if (this.orientationValue === "vertical" || this.orientationValue === "both") {
            const scrollRatio = viewport.scrollTop / (viewport.scrollHeight - viewport.clientHeight);
            const thumbHeight = Math.max((viewport.clientHeight / viewport.scrollHeight) * 100, 10);
            const thumbTop = scrollRatio * (100 - thumbHeight);
            thumb.style.height = `${thumbHeight}%`;
            thumb.style.top = `${thumbTop}%`;
        }
        if (this.orientationValue === "horizontal" || this.orientationValue === "both") {
            const scrollRatio = viewport.scrollLeft / (viewport.scrollWidth - viewport.clientWidth);
            const thumbWidth = Math.max((viewport.clientWidth / viewport.scrollWidth) * 100, 10);
            const thumbLeft = scrollRatio * (100 - thumbWidth);
            thumb.style.width = `${thumbWidth}%`;
            thumb.style.left = `${thumbLeft}%`;
        }
    }
    showScrollbar() {
        this.scrollbarTargets.forEach((scrollbar) => {
            scrollbar.style.opacity = "1";
        });
    }
    hideScrollbar() {
        if (this.typeValue !== "always") {
            this.scrollbarTargets.forEach((scrollbar) => {
                scrollbar.style.opacity = "0";
            });
        }
    }
};

/**
 * Select controller for custom select dropdowns
 * Uses Floating UI for smart positioning and stimulus-use for click outside detection
 */
let default_1$a = class default_1 extends Controller {
    static { this.targets = ["trigger", "content", "input", "item", "display", "checkIcon"]; }
    static { this.values = {
        value: String,
        placement: { type: String, default: "bottom-start" },
        sameWidth: { type: Boolean, default: true }
    }; }
    connect() {
        this.isOpen = false;
        this.focusedIndex = -1;
        this.cleanupFloating = null;
        // Use stimulus-use for click outside detection
        useClickOutside(this);
        // Set initial value display
        if (this.valueValue) {
            this.selectByValue(this.valueValue, false);
        }
    }
    disconnect() {
        this.close();
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    toggle(event) {
        event?.preventDefault();
        if (this.isOpen) {
            this.close();
        }
        else {
            this.open();
        }
    }
    open() {
        if (this.isOpen)
            return;
        this.isOpen = true;
        if (this.hasContentTarget) {
            this.contentTarget.hidden = false;
            this.contentTarget.dataset.state = "open";
            // Use Floating UI for smart positioning
            if (this.hasTriggerTarget) {
                this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
                    placement: this.placementValue,
                    sameWidth: this.sameWidthValue,
                    maxHeight: 384 // max-h-96
                });
            }
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "true");
        }
        // Focus current value or first item
        this.focusedIndex = -1;
        const currentItem = this.itemTargets.find((item) => item.dataset.value === this.valueValue);
        if (currentItem) {
            this.focusedIndex = this.itemTargets.indexOf(currentItem);
            currentItem.focus();
        }
        else {
            this.focusNextItem();
        }
        this.dispatch("opened");
    }
    close() {
        if (!this.isOpen)
            return;
        this.isOpen = false;
        // Cleanup Floating UI auto-update
        this.cleanupPositioning();
        if (this.hasContentTarget) {
            this.contentTarget.dataset.state = "closed";
            setTimeout(() => {
                if (!this.isOpen) {
                    this.contentTarget.hidden = true;
                }
            }, 150);
        }
        if (this.hasTriggerTarget) {
            this.triggerTarget.setAttribute("aria-expanded", "false");
        }
        this.focusedIndex = -1;
        this.dispatch("closed");
    }
    // Called by stimulus-use when clicking outside the element
    clickOutside(event) {
        if (this.isOpen) {
            this.close();
        }
    }
    select(event) {
        const item = event.currentTarget;
        if (item.dataset.disabled !== undefined)
            return;
        const value = item.dataset.value;
        this.selectByValue(value);
        this.close();
        this.triggerTarget?.focus();
    }
    selectByValue(value, dispatch = true) {
        this.valueValue = value;
        // Update hidden input
        if (this.hasInputTarget) {
            this.inputTarget.value = value;
        }
        // Update display
        const selectedItem = this.itemTargets.find((item) => item.dataset.value === value);
        if (this.hasDisplayTarget && selectedItem) {
            this.displayTarget.textContent = selectedItem.textContent.trim();
        }
        // Update aria-selected and check icons
        this.itemTargets.forEach((item) => {
            const isSelected = item.dataset.value === value;
            item.setAttribute("aria-selected", isSelected.toString());
            const checkIcon = item.querySelector('[data-shadcn--select-target="checkIcon"]');
            if (checkIcon) {
                checkIcon.style.opacity = isSelected ? "1" : "0";
            }
        });
        if (dispatch) {
            this.dispatch("change", { detail: { value } });
        }
    }
    handleKeydown(event) {
        if (!this.isOpen) {
            if (event.key === "Enter" || event.key === " " || event.key === "ArrowDown") {
                event.preventDefault();
                this.open();
            }
            return;
        }
        switch (event.key) {
            case "Escape":
                event.preventDefault();
                this.close();
                this.triggerTarget?.focus();
                break;
            case "ArrowDown":
                event.preventDefault();
                this.focusNextItem();
                break;
            case "ArrowUp":
                event.preventDefault();
                this.focusPreviousItem();
                break;
            case "Home":
                event.preventDefault();
                this.focusFirstItem();
                break;
            case "End":
                event.preventDefault();
                this.focusLastItem();
                break;
            case "Enter":
            case " ":
                event.preventDefault();
                this.selectFocusedItem();
                break;
        }
    }
    focusNextItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = (this.focusedIndex + 1) % items.length;
        items[this.focusedIndex].focus();
    }
    focusPreviousItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = this.focusedIndex <= 0 ? items.length - 1 : this.focusedIndex - 1;
        items[this.focusedIndex].focus();
    }
    focusFirstItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = 0;
        items[0].focus();
    }
    focusLastItem() {
        const items = this.enabledItems;
        if (items.length === 0)
            return;
        this.focusedIndex = items.length - 1;
        items[this.focusedIndex].focus();
    }
    selectFocusedItem() {
        const items = this.enabledItems;
        if (this.focusedIndex >= 0 && this.focusedIndex < items.length) {
            items[this.focusedIndex].click();
        }
    }
    get enabledItems() {
        return this.itemTargets.filter((item) => item.dataset.disabled === undefined);
    }
};

/**
 * Sheet controller for slide-out panels
 */
let default_1$9 = class default_1 extends Controller {
    static { this.targets = ["trigger", "template", "overlay", "content"]; }
    static { this.values = {
        open: { type: Boolean, default: false },
        side: { type: String, default: "right" }
    }; }
    connect() {
        this.portal = null;
        this.previousActiveElement = null;
        this.boundHandleKeydown = this.handleKeydown.bind(this);
        if (this.openValue) {
            this.open();
        }
    }
    disconnect() {
        this.close();
        if (this.portal) {
            this.portal.remove();
        }
    }
    open() {
        if (this.openValue)
            return;
        this.previousActiveElement = document.activeElement;
        this.openValue = true;
        // Move template content to body
        if (this.hasTemplateTarget && !this.portal) {
            this.portal = document.createElement("div");
            this.portal.className = "shadcn-sheet-portal";
            this.portal.innerHTML = this.templateTarget.innerHTML;
            document.body.appendChild(this.portal);
            this.portalOverlay = this.portal.querySelector('[data-shadcn--sheet-target="overlay"]');
            this.portalContent = this.portal.querySelector('[data-shadcn--sheet-target="content"]');
            // Re-attach event listeners for close buttons
            const closeButtons = this.portal.querySelectorAll('[data-action*="shadcn--sheet#close"]');
            closeButtons.forEach((btn) => {
                btn.addEventListener("click", () => this.close());
            });
        }
        requestAnimationFrame(() => {
            if (this.portalOverlay) {
                this.portalOverlay.dataset.state = "open";
                this.portalOverlay.removeAttribute("hidden");
            }
            if (this.portalContent) {
                this.portalContent.dataset.state = "open";
                this.portalContent.removeAttribute("hidden");
            }
            document.addEventListener("keydown", this.boundHandleKeydown);
            document.body.style.overflow = "hidden";
            this.focusFirstElement();
        });
        this.dispatch("opened");
    }
    close() {
        if (!this.openValue)
            return;
        this.openValue = false;
        if (this.portalOverlay) {
            this.portalOverlay.dataset.state = "closed";
        }
        if (this.portalContent) {
            this.portalContent.dataset.state = "closed";
        }
        document.removeEventListener("keydown", this.boundHandleKeydown);
        document.body.style.overflow = "";
        if (this.previousActiveElement) {
            this.previousActiveElement.focus();
        }
        setTimeout(() => {
            if (this.portal) {
                this.portal.remove();
                this.portal = null;
            }
        }, 300);
        this.dispatch("closed");
    }
    toggle() {
        if (this.openValue) {
            this.close();
        }
        else {
            this.open();
        }
    }
    handleKeydown(event) {
        if (event.key === "Escape") {
            this.close();
        }
        else if (event.key === "Tab") {
            this.trapFocus(event);
        }
    }
    focusFirstElement() {
        if (!this.portalContent)
            return;
        const focusable = this.portalContent.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
        if (focusable.length > 0) {
            focusable[0].focus();
        }
        else {
            this.portalContent.focus();
        }
    }
    trapFocus(event) {
        if (!this.portalContent)
            return;
        const focusable = this.portalContent.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
        const firstFocusable = focusable[0];
        const lastFocusable = focusable[focusable.length - 1];
        if (event.shiftKey) {
            if (document.activeElement === firstFocusable) {
                lastFocusable.focus();
                event.preventDefault();
            }
        }
        else {
            if (document.activeElement === lastFocusable) {
                firstFocusable.focus();
                event.preventDefault();
            }
        }
    }
};

/**
 * Slider Controller
 *
 * Handles slider value selection with drag and keyboard support
 *
 * Targets:
 * - track: The slider track
 * - range: The filled range portion
 * - thumb: The draggable thumb
 * - input: Hidden input for form submission
 * - output: Optional element to display the current value (auto-synced)
 *
 * Values:
 * - min: Minimum value
 * - max: Maximum value
 * - step: Step increment
 * - value: Current value
 * - name: Input name
 * - disabled: Whether slider is disabled
 * - outputFormat: Format string for output (use {value} for value, {percent} for percentage)
 *
 * Data attributes for native <input type="range">:
 * - data-output-target: ID of element to display value (one-way: slider → output)
 * - data-output-format: Format string with {value} and {percent} placeholders
 * - data-input-target: ID of input element for two-way binding (slider ↔ input)
 */
let default_1$8 = class default_1 extends Controller {
    static { this.targets = ["track", "range", "thumb", "input", "output"]; }
    static { this.values = {
        min: { type: Number, default: 0 },
        max: { type: Number, default: 100 },
        step: { type: Number, default: 1 },
        value: { type: Number, default: 0 },
        name: String,
        disabled: { type: Boolean, default: false },
        outputFormat: { type: String, default: "{value}" }
    }; }
    connect() {
        this.isDragging = false;
        this.updateVisuals();
        this.setupTwoWayBindings();
    }
    disconnect() {
        this.teardownTwoWayBindings();
    }
    /**
     * Set up two-way bindings for native range inputs with data-input-target
     */
    setupTwoWayBindings() {
        this.inputBindings = [];
        // Check if the controller element itself is a range input with data-input-target
        // (This is the case when data-controller is on the input element directly)
        if (this.element instanceof HTMLInputElement &&
            this.element.matches &&
            this.element.matches('input[type="range"][data-input-target]')) {
            this.setupBindingForInput(this.element);
            return;
        }
        // Otherwise, find all native range inputs with data-input-target attribute within the element
        const rangeInputs = this.element.querySelectorAll('input[type="range"][data-input-target]');
        rangeInputs.forEach(rangeInput => {
            this.setupBindingForInput(rangeInput);
        });
    }
    /**
     * Set up two-way binding for a single range input
     * @param {HTMLInputElement} rangeInput - The range input element
     */
    setupBindingForInput(rangeInput) {
        const inputTargetId = rangeInput.dataset.inputTarget;
        if (!inputTargetId)
            return;
        const linkedInput = document.getElementById(inputTargetId);
        if (linkedInput instanceof HTMLInputElement) {
            // Create bound handler for this specific pair
            const handler = this.handleLinkedInputChange.bind(this, rangeInput);
            // Store binding info for cleanup
            this.inputBindings.push({
                rangeInput,
                linkedInput,
                handler
            });
            // Listen for changes on the linked input
            linkedInput.addEventListener('input', handler);
            linkedInput.addEventListener('change', handler);
        }
    }
    /**
     * Clean up event listeners when disconnecting
     */
    teardownTwoWayBindings() {
        if (this.inputBindings) {
            this.inputBindings.forEach(({ linkedInput, handler }) => {
                linkedInput.removeEventListener('input', handler);
                linkedInput.removeEventListener('change', handler);
            });
            this.inputBindings = [];
        }
    }
    /**
     * Handle changes from a linked input element (input → slider sync)
     * @param {HTMLInputElement} rangeInput - The range input to update
     * @param {Event} event - The input/change event from the linked input
     */
    handleLinkedInputChange(rangeInput, event) {
        if (!(event.target instanceof HTMLInputElement))
            return;
        const linkedInput = event.target;
        let value = parseFloat(linkedInput.value);
        // Validate and clamp the value
        const min = parseFloat(rangeInput.min) || 0;
        const max = parseFloat(rangeInput.max) || 100;
        const step = parseFloat(rangeInput.step) || 1;
        // Handle invalid input
        if (isNaN(value)) {
            value = min;
        }
        // Clamp to min/max
        value = Math.max(min, Math.min(max, value));
        // Snap to step
        const steps = Math.round((value - min) / step);
        value = min + steps * step;
        // Update range input
        rangeInput.value = String(value);
        // Update CSS custom property for fill
        const percentage = ((value - min) / (max - min)) * 100;
        rangeInput.style.setProperty("--slider-fill", `${percentage}%`);
        // Update the linked input if value was clamped/snapped
        if (parseFloat(linkedInput.value) !== value) {
            linkedInput.value = String(value);
        }
        // Also update output if present
        const outputTargetId = rangeInput.dataset.outputTarget;
        if (outputTargetId) {
            const outputElement = document.getElementById(outputTargetId);
            if (outputElement) {
                const format = rangeInput.dataset.outputFormat || "{value}";
                const formattedValue = format
                    .replace("{value}", String(value))
                    .replace("{percent}", String(Math.round(percentage)));
                outputElement.textContent = formattedValue;
            }
        }
        // Dispatch change event
        this.dispatch("change", {
            detail: { value: value, percentage: percentage }
        });
    }
    startDrag(event) {
        if (this.disabledValue)
            return;
        event.preventDefault();
        this.isDragging = true;
        // Handle both mouse and touch events
        const moveEvent = event.type === "touchstart" ? "touchmove" : "mousemove";
        const endEvent = event.type === "touchstart" ? "touchend" : "mouseup";
        this.handleDrag(event);
        this.boundHandleDrag = this.handleDrag.bind(this);
        this.boundStopDrag = this.stopDrag.bind(this);
        document.addEventListener(moveEvent, this.boundHandleDrag);
        document.addEventListener(endEvent, this.boundStopDrag);
    }
    handleDrag(event) {
        if (!this.isDragging && event.type !== "mousedown" && event.type !== "touchstart")
            return;
        const track = this.trackTarget;
        const rect = track.getBoundingClientRect();
        // Get clientX from either mouse or touch event
        const clientX = event.type.includes("touch")
            ? event.touches[0].clientX
            : event.clientX;
        const percentage = Math.max(0, Math.min(1, (clientX - rect.left) / rect.width));
        const rawValue = this.minValue + percentage * (this.maxValue - this.minValue);
        const steppedValue = this.snapToStep(rawValue);
        this.valueValue = steppedValue;
        this.updateVisuals();
        this.dispatchChange();
    }
    stopDrag() {
        this.isDragging = false;
        document.removeEventListener("mousemove", this.boundHandleDrag);
        document.removeEventListener("mouseup", this.boundStopDrag);
        document.removeEventListener("touchmove", this.boundHandleDrag);
        document.removeEventListener("touchend", this.boundStopDrag);
    }
    handleKeydown(event) {
        if (this.disabledValue)
            return;
        let newValue = this.valueValue;
        const bigStep = (this.maxValue - this.minValue) / 10;
        switch (event.key) {
            case "ArrowRight":
            case "ArrowUp":
                event.preventDefault();
                newValue = Math.min(this.maxValue, this.valueValue + this.stepValue);
                break;
            case "ArrowLeft":
            case "ArrowDown":
                event.preventDefault();
                newValue = Math.max(this.minValue, this.valueValue - this.stepValue);
                break;
            case "PageUp":
                event.preventDefault();
                newValue = Math.min(this.maxValue, this.valueValue + bigStep);
                break;
            case "PageDown":
                event.preventDefault();
                newValue = Math.max(this.minValue, this.valueValue - bigStep);
                break;
            case "Home":
                event.preventDefault();
                newValue = this.minValue;
                break;
            case "End":
                event.preventDefault();
                newValue = this.maxValue;
                break;
            default:
                return;
        }
        this.valueValue = this.snapToStep(newValue);
        this.updateVisuals();
        this.dispatchChange();
    }
    snapToStep(value) {
        const steps = Math.round((value - this.minValue) / this.stepValue);
        return Math.max(this.minValue, Math.min(this.maxValue, this.minValue + steps * this.stepValue));
    }
    updateVisuals() {
        const percentage = this.percentage;
        if (this.hasRangeTarget) {
            this.rangeTarget.style.width = `${percentage}%`;
        }
        if (this.hasThumbTarget) {
            this.thumbTarget.style.left = `calc(${percentage}% - 8px)`;
        }
        // Update ARIA attributes
        this.element.setAttribute("aria-valuenow", String(this.valueValue));
        // Update hidden input
        if (this.hasInputTarget) {
            this.inputTarget.value = String(this.valueValue);
        }
        // Update output element if present (for syncing value labels)
        if (this.hasOutputTarget) {
            this.updateOutput();
        }
    }
    updateOutput() {
        const formattedValue = this.outputFormatValue
            .replace("{value}", String(this.valueValue))
            .replace("{percent}", String(Math.round(this.percentage)));
        this.outputTarget.textContent = formattedValue;
    }
    dispatchChange() {
        this.dispatch("change", {
            detail: { value: this.valueValue, name: this.nameValue }
        });
        // Dispatch native input event for form compatibility
        if (this.hasInputTarget) {
            this.inputTarget.dispatchEvent(new Event("input", { bubbles: true }));
        }
    }
    get percentage() {
        if (this.maxValue === this.minValue)
            return 0;
        return ((this.valueValue - this.minValue) / (this.maxValue - this.minValue)) * 100;
    }
    valueValueChanged() {
        this.updateVisuals();
    }
    /**
     * Update style for native input range element
     * Called on input event from native <input type="range">
     * Updates CSS custom property for fill and syncs output element
     */
    updateStyle(event) {
        const input = event.target;
        const value = parseFloat(input.value);
        const min = parseFloat(input.min) || 0;
        const max = parseFloat(input.max) || 100;
        // Calculate percentage and update CSS custom property
        const percentage = ((value - min) / (max - min)) * 100;
        input.style.setProperty("--slider-fill", `${percentage}%`);
        // Update value for output sync
        this.valueValue = value;
        // Update output if present (Stimulus target)
        if (this.hasOutputTarget) {
            this.updateOutput();
        }
        // Also check for data-output-target attribute (ID-based targeting)
        const outputTargetId = input.dataset.outputTarget;
        if (outputTargetId) {
            const outputElement = document.getElementById(outputTargetId);
            if (outputElement) {
                const format = input.dataset.outputFormat || "{value}";
                const formattedValue = format
                    .replace("{value}", String(value))
                    .replace("{percent}", String(Math.round(percentage)));
                outputElement.textContent = formattedValue;
            }
        }
        // Sync to linked input element for two-way binding (slider → input)
        const inputTargetId = input.dataset.inputTarget;
        if (inputTargetId) {
            const linkedInput = document.getElementById(inputTargetId);
            if (linkedInput) {
                linkedInput.value = String(value);
            }
        }
        // Dispatch change event
        this.dispatch("change", {
            detail: { value: value, percentage: percentage }
        });
    }
};

/**
 * Switch Controller
 *
 * Handles toggle switch with hidden input sync for form submission
 *
 * Targets:
 * - button: The visual switch button element
 * - thumb: The sliding thumb element
 * - input: Hidden checkbox input for form submission
 *
 * Values:
 * - checked: Boolean indicating current state
 */
let default_1$7 = class default_1 extends Controller {
    static { this.targets = ["button", "thumb", "input"]; }
    static { this.values = {
        checked: { type: Boolean, default: false }
    }; }
    connect() {
        this.updateVisuals();
    }
    toggle() {
        if (this.hasButtonTarget && this.buttonTarget.disabled)
            return;
        this.checkedValue = !this.checkedValue;
        this.updateVisuals();
        this.syncInput();
        this.dispatchChange();
    }
    handleKeydown(event) {
        if (event.key === " " || event.key === "Enter") {
            event.preventDefault();
            this.toggle();
        }
    }
    updateVisuals() {
        const state = this.checkedValue ? "checked" : "unchecked";
        // Update button state
        if (this.hasButtonTarget) {
            this.buttonTarget.dataset.state = state;
            this.buttonTarget.setAttribute("aria-checked", this.checkedValue.toString());
        }
        // Update thumb position
        if (this.hasThumbTarget) {
            this.thumbTarget.dataset.state = state;
        }
        // Update wrapper element state
        this.element.dataset.state = state;
    }
    syncInput() {
        if (this.hasInputTarget) {
            this.inputTarget.checked = this.checkedValue;
            // Dispatch native change event for form compatibility
            this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }));
        }
    }
    dispatchChange() {
        this.dispatch("change", {
            detail: { checked: this.checkedValue }
        });
    }
    checkedValueChanged() {
        this.updateVisuals();
        this.syncInput();
    }
};

/**
 * Tabs controller for tabbed interfaces
 * Handles tab selection, keyboard navigation, content switching, and URL sync
 */
let default_1$6 = class default_1 extends Controller {
    static { this.targets = ["list", "trigger", "content"]; }
    static { this.values = {
        defaultValue: String,
        urlParam: String // Query parameter name for URL sync (e.g., "tab")
    }; }
    connect() {
        // Determine initial tab value
        let initialValue = this.getValueFromUrl() || this.defaultValueValue || this.triggerTargets[0]?.dataset.value;
        if (initialValue) {
            // Validate that the value exists in our triggers
            const validValues = this.triggerTargets.map((t) => t.dataset.value);
            if (!validValues.includes(initialValue)) {
                initialValue = this.defaultValueValue || this.triggerTargets[0]?.dataset.value;
            }
            this.selectTabByValue(initialValue, false); // Don't update URL on initial load
        }
        // Listen for browser back/forward navigation
        if (this.hasUrlParamValue) {
            window.addEventListener("popstate", this.handlePopState.bind(this));
        }
    }
    disconnect() {
        if (this.hasUrlParamValue) {
            window.removeEventListener("popstate", this.handlePopState.bind(this));
        }
    }
    handlePopState() {
        const value = this.getValueFromUrl();
        if (value) {
            this.selectTabByValue(value, false);
        }
    }
    getValueFromUrl() {
        if (!this.hasUrlParamValue)
            return null;
        const url = new URL(window.location.href);
        return url.searchParams.get(this.urlParamValue);
    }
    updateUrl(value) {
        if (!this.hasUrlParamValue)
            return;
        const url = new URL(window.location.href);
        url.searchParams.set(this.urlParamValue, value);
        window.history.replaceState({}, "", url.toString());
    }
    selectTab(event) {
        const trigger = event.currentTarget;
        const value = trigger.dataset.value;
        this.selectTabByValue(value, true);
    }
    selectTabByValue(value, updateUrl = true) {
        // Update triggers
        this.triggerTargets.forEach((trigger) => {
            const isSelected = trigger.dataset.value === value;
            trigger.dataset.state = isSelected ? "active" : "inactive";
            trigger.setAttribute("aria-selected", isSelected.toString());
            trigger.tabIndex = isSelected ? 0 : -1;
        });
        // Update content panels
        this.contentTargets.forEach((content) => {
            const isSelected = content.dataset.value === value;
            content.dataset.state = isSelected ? "active" : "inactive";
            content.hidden = !isSelected;
        });
        // Update URL if enabled
        if (updateUrl) {
            this.updateUrl(value);
        }
        this.dispatch("change", { detail: { value } });
    }
    // Keyboard navigation
    handleKeydown(event) {
        const triggers = this.triggerTargets.filter((t) => !t.disabled);
        const currentIndex = triggers.findIndex((t) => t === document.activeElement);
        if (currentIndex === -1)
            return;
        let newIndex = currentIndex;
        switch (event.key) {
            case "ArrowLeft":
            case "ArrowUp":
                event.preventDefault();
                newIndex = currentIndex === 0 ? triggers.length - 1 : currentIndex - 1;
                break;
            case "ArrowRight":
            case "ArrowDown":
                event.preventDefault();
                newIndex = currentIndex === triggers.length - 1 ? 0 : currentIndex + 1;
                break;
            case "Home":
                event.preventDefault();
                newIndex = 0;
                break;
            case "End":
                event.preventDefault();
                newIndex = triggers.length - 1;
                break;
            default:
                return;
        }
        triggers[newIndex].focus();
        triggers[newIndex].click();
    }
};

/**
 * Toast controller for notification toasts
 */
let default_1$5 = class default_1 extends Controller {
    static { this.values = {
        duration: { type: Number, default: 5000 },
        open: { type: Boolean, default: true }
    }; }
    connect() {
        if (this.openValue && this.durationValue > 0) {
            this.startDismissTimer();
        }
    }
    disconnect() {
        this.clearDismissTimer();
    }
    close() {
        this.openValue = false;
        this.element.dataset.state = "closed";
        // Remove after animation
        setTimeout(() => {
            this.element.remove();
            this.dispatch("closed");
        }, 200);
    }
    startDismissTimer() {
        this.clearDismissTimer();
        this.dismissTimeout = setTimeout(() => {
            this.close();
        }, this.durationValue);
    }
    clearDismissTimer() {
        if (this.dismissTimeout) {
            clearTimeout(this.dismissTimeout);
            this.dismissTimeout = null;
        }
    }
    // Pause timer on hover
    pause() {
        this.clearDismissTimer();
    }
    // Resume timer when hover ends
    resume() {
        if (this.openValue && this.durationValue > 0) {
            this.startDismissTimer();
        }
    }
};

/**
 * Toggle Controller
 *
 * Handles toggle button state management
 *
 * Values:
 * - pressed: Boolean indicating if toggle is pressed
 */
let default_1$4 = class default_1 extends Controller {
    static { this.values = {
        pressed: { type: Boolean, default: false }
    }; }
    connect() {
        this.updateState();
    }
    toggle() {
        if (this.element.disabled)
            return;
        this.pressedValue = !this.pressedValue;
        this.updateState();
        this.dispatchChange();
    }
    updateState() {
        this.element.setAttribute("aria-pressed", this.pressedValue.toString());
        this.element.dataset.state = this.pressedValue ? "on" : "off";
    }
    dispatchChange() {
        this.dispatch("change", {
            detail: { pressed: this.pressedValue }
        });
    }
    pressedValueChanged() {
        this.updateState();
    }
};

/**
 * Toggle Group Controller
 * Handles single or multiple selection of toggle items
 */
let default_1$3 = class default_1 extends Controller {
    static { this.targets = ["item", "input"]; }
    static { this.values = {
        type: { type: String, default: "single" }, // "single" or "multiple"
        value: { type: String, default: "" }
    }; }
    connect() {
        this.updateStates();
    }
    toggle(event) {
        const item = event.currentTarget;
        const value = item.dataset.value;
        const currentValues = this.getValues();
        if (this.typeValue === "single") {
            // Single selection - toggle or select new
            if (currentValues.includes(value)) {
                this.valueValue = "";
            }
            else {
                this.valueValue = value;
            }
        }
        else {
            // Multiple selection - toggle individual item
            if (currentValues.includes(value)) {
                this.valueValue = currentValues.filter((v) => v !== value).join(",");
            }
            else {
                this.valueValue = [...currentValues, value].filter(Boolean).join(",");
            }
        }
        this.updateStates();
        this.updateInput();
        this.dispatch("change", { detail: { value: this.getValues() } });
    }
    getValues() {
        return this.valueValue.split(",").filter(Boolean);
    }
    updateStates() {
        const values = this.getValues();
        this.itemTargets.forEach((item) => {
            const isOn = values.includes(item.dataset.value);
            item.setAttribute("data-state", isOn ? "on" : "off");
            item.setAttribute("aria-pressed", isOn.toString());
        });
    }
    updateInput() {
        if (this.hasInputTarget) {
            this.inputTarget.value = this.valueValue;
        }
    }
    valueValueChanged() {
        this.updateStates();
        this.updateInput();
    }
};

/**
 * Tooltip controller for contextual information
 * Uses Floating UI for smart positioning
 */
let default_1$2 = class default_1 extends Controller {
    static { this.targets = ["trigger", "content"]; }
    static { this.values = {
        side: { type: String, default: "top" },
        align: { type: String, default: "center" },
        delay: { type: Number, default: 200 },
        skipDelay: { type: Number, default: 300 }
    }; }
    connect() {
        this.showTimeout = null;
        this.hideTimeout = null;
        this.cleanupFloating = null;
    }
    disconnect() {
        this.clearTimeouts();
        this.cleanupPositioning();
    }
    cleanupPositioning() {
        if (this.cleanupFloating) {
            this.cleanupFloating();
            this.cleanupFloating = null;
        }
    }
    get placement() {
        // Convert side/align to Floating UI placement
        const align = this.alignValue === "center" ? "" : `-${this.alignValue}`;
        return `${this.sideValue}${align}`;
    }
    show() {
        this.clearTimeouts();
        this.showTimeout = setTimeout(() => {
            if (this.hasContentTarget) {
                this.contentTarget.hidden = false;
                this.contentTarget.dataset.state = "open";
                // Use Floating UI for smart positioning
                if (this.hasTriggerTarget) {
                    this.cleanupFloating = positionFloating(this.triggerTarget, this.contentTarget, {
                        placement: this.placement,
                        offset: 8
                    });
                }
            }
        }, this.delayValue);
    }
    hide() {
        this.clearTimeouts();
        // Cleanup Floating UI
        this.cleanupPositioning();
        this.hideTimeout = setTimeout(() => {
            if (this.hasContentTarget) {
                this.contentTarget.dataset.state = "closed";
                setTimeout(() => {
                    this.contentTarget.hidden = true;
                }, 100);
            }
        }, 0);
    }
    clearTimeouts() {
        if (this.showTimeout) {
            clearTimeout(this.showTimeout);
            this.showTimeout = null;
        }
        if (this.hideTimeout) {
            clearTimeout(this.hideTimeout);
            this.hideTimeout = null;
        }
    }
};

/**
 * Stimulus controller for the Input OTP component
 * Handles multi-slot OTP input with keyboard navigation
 */
let default_1$1 = class default_1 extends Controller {
    static { this.targets = ["slot", "input", "hiddenInput", "caret"]; }
    static { this.values = {
        length: { type: Number, default: 6 },
        pattern: { type: String, default: "" },
        disabled: { type: Boolean, default: false }
    }; }
    connect() {
        this.updateHiddenInput();
        this.updateCarets();
    }
    handleInput(event) {
        const input = event.target;
        const index = parseInt(input.dataset.index);
        let value = input.value;
        // Apply pattern validation if set
        if (this.patternValue) {
            const regex = new RegExp(this.patternValue);
            if (!regex.test(value)) {
                input.value = "";
                return;
            }
        }
        // Only keep last character if multiple entered
        if (value.length > 1) {
            value = value.slice(-1);
            input.value = value;
        }
        this.updateHiddenInput({ dispatch: true });
        this.updateCarets();
        // Auto-advance to next slot
        if (value && index < this.lengthValue - 1) {
            this.focusInput(index + 1);
        }
    }
    handleKeydown(event) {
        const input = event.target;
        const index = parseInt(input.dataset.index);
        switch (event.key) {
            case "Backspace":
                if (!input.value && index > 0) {
                    // Move to previous slot and clear it
                    event.preventDefault();
                    this.focusInput(index - 1);
                    this.inputTargets[index - 1].value = "";
                    this.updateHiddenInput({ dispatch: true });
                    this.updateCarets();
                }
                break;
            case "ArrowLeft":
                if (index > 0) {
                    event.preventDefault();
                    this.focusInput(index - 1);
                }
                break;
            case "ArrowRight":
                if (index < this.lengthValue - 1) {
                    event.preventDefault();
                    this.focusInput(index + 1);
                }
                break;
            case "Delete":
                input.value = "";
                this.updateHiddenInput({ dispatch: true });
                this.updateCarets();
                break;
        }
    }
    handleFocus(event) {
        const input = event.target;
        const slot = input.closest("[data-shadcn--input-otp-target='slot']");
        if (slot) {
            slot.classList.add("z-10", "ring-1", "ring-ring");
        }
        this.updateCarets();
    }
    handleBlur(event) {
        const input = event.target;
        const slot = input.closest("[data-shadcn--input-otp-target='slot']");
        if (slot) {
            slot.classList.remove("z-10", "ring-1", "ring-ring");
        }
        this.updateCarets();
    }
    handlePaste(event) {
        event.preventDefault();
        const pastedData = event.clipboardData.getData("text");
        // Apply pattern validation if set
        let chars = pastedData.split("");
        if (this.patternValue) {
            const regex = new RegExp(this.patternValue);
            chars = chars.filter((char) => regex.test(char));
        }
        // Fill slots starting from current position
        const startIndex = parseInt(event.target.dataset.index);
        chars.slice(0, this.lengthValue - startIndex).forEach((char, i) => {
            const input = this.inputTargets[startIndex + i];
            if (input) {
                input.value = char;
            }
        });
        this.updateHiddenInput({ dispatch: true });
        this.updateCarets();
        // Focus appropriate slot after paste
        const nextEmptyIndex = this.findNextEmptySlot(startIndex);
        if (nextEmptyIndex !== -1) {
            this.focusInput(nextEmptyIndex);
        }
        else {
            this.focusInput(Math.min(startIndex + chars.length, this.lengthValue - 1));
        }
    }
    focusSlot(event) {
        const slot = event.currentTarget;
        const index = parseInt(slot.dataset.index);
        this.focusInput(index);
    }
    focusInput(index) {
        const input = this.inputTargets[index];
        if (input && !this.disabledValue) {
            input.focus();
            input.select();
        }
    }
    findNextEmptySlot(startIndex) {
        for (let i = startIndex; i < this.lengthValue; i++) {
            if (!this.inputTargets[i]?.value) {
                return i;
            }
        }
        return -1;
    }
    updateHiddenInput({ dispatch = false } = {}) {
        if (!this.hasHiddenInputTarget)
            return;
        const value = this.inputTargets.map((input) => input.value || "").join("");
        this.hiddenInputTarget.value = value;
        if (dispatch) {
            this.hiddenInputTarget.dispatchEvent(new Event("input", { bubbles: true }));
            this.dispatch("change", { detail: { value } });
        }
    }
    updateCarets() {
        // Hide all carets
        this.caretTargets.forEach((caret) => {
            caret.classList.add("hidden");
        });
        // Show caret in focused empty slot
        const activeInput = this.inputTargets.find((input) => document.activeElement === input && !input.value);
        if (activeInput) {
            const index = parseInt(activeInput.dataset.index);
            const caret = this.caretTargets[index];
            if (caret) {
                caret.classList.remove("hidden");
            }
        }
    }
    // Get the complete OTP value
    get value() {
        return this.inputTargets.map((input) => input.value || "").join("");
    }
    // Check if OTP is complete
    get isComplete() {
        return this.value.length === this.lengthValue;
    }
    // Clear all inputs
    clear() {
        this.inputTargets.forEach((input) => {
            input.value = "";
        });
        this.updateHiddenInput({ dispatch: true });
        this.updateCarets();
        this.focusInput(0);
    }
};

// Constants for sidebar dimensions
const SIDEBAR_COOKIE_NAME = "sidebar:state";
const SIDEBAR_COOKIE_MAX_AGE = 60 * 60 * 24 * 7; // 7 days
/**
 * Sidebar Controller
 * Uses stimulus-use useMatchMedia for responsive behavior
 */
class default_1 extends Controller {
    static { this.targets = ["sidebar"]; }
    static { this.values = {
        open: { type: Boolean, default: true },
        openMobile: { type: Boolean, default: false },
        keyboardShortcut: { type: String, default: "b" }
    }; }
    connect() {
        // Set initial state from cookie if available
        const savedState = this.getCookie(SIDEBAR_COOKIE_NAME);
        if (savedState !== null) {
            this.openValue = savedState === "true";
        }
        // Set up keyboard shortcut
        this.handleKeyDown = this.handleKeyDown.bind(this);
        document.addEventListener("keydown", this.handleKeyDown);
        // Use stimulus-use for responsive media query detection
        this.isMobile = window.innerWidth < 768;
        useMatchMedia(this, {
            mediaQueries: {
                mobile: "(max-width: 767px)"
            }
        });
        // Initial state sync
        this.syncState();
    }
    disconnect() {
        document.removeEventListener("keydown", this.handleKeyDown);
    }
    // Called by stimulus-use when mobile media query state changes
    mobileChanged({ matches }) {
        const wasMobile = this.isMobile;
        this.isMobile = matches;
        // Close mobile sidebar when switching to desktop
        if (wasMobile && !this.isMobile) {
            this.openMobileValue = false;
        }
        this.syncState();
    }
    handleKeyDown(event) {
        // Check for Cmd/Ctrl + keyboard shortcut
        if ((event.metaKey || event.ctrlKey) &&
            event.key.toLowerCase() === this.keyboardShortcutValue.toLowerCase()) {
            event.preventDefault();
            this.toggle();
        }
    }
    toggle() {
        if (this.isMobile) {
            this.openMobileValue = !this.openMobileValue;
        }
        else {
            this.openValue = !this.openValue;
        }
    }
    setOpen(open) {
        if (this.isMobile) {
            this.openMobileValue = open;
        }
        else {
            this.openValue = open;
        }
    }
    openValueChanged() {
        this.syncState();
        // Save to cookie
        this.setCookie(SIDEBAR_COOKIE_NAME, String(this.openValue), SIDEBAR_COOKIE_MAX_AGE);
    }
    openMobileValueChanged() {
        this.syncState();
    }
    syncState() {
        const state = this.isMobile ? (this.openMobileValue ? "expanded" : "collapsed") : (this.openValue ? "expanded" : "collapsed");
        // Update data attributes on the provider element
        this.element.dataset.state = state;
        this.element.dataset.mobile = String(this.isMobile);
        // Update sidebar targets if they exist
        if (this.hasSidebarTarget) {
            this.sidebarTargets.forEach((sidebar) => {
                sidebar.dataset.state = state;
                sidebar.dataset.mobile = String(this.isMobile);
            });
        }
        // Dispatch custom event for other components to listen to
        this.element.dispatchEvent(new CustomEvent("sidebar:state-change", {
            bubbles: true,
            detail: {
                open: this.isMobile ? this.openMobileValue : this.openValue,
                isMobile: this.isMobile,
                state: state
            }
        }));
    }
    // Cookie helpers
    getCookie(name) {
        const value = `; ${document.cookie}`;
        const parts = value.split(`; ${name}=`);
        if (parts.length === 2) {
            return parts.pop()?.split(";").shift() || null;
        }
        return null;
    }
    setCookie(name, value, maxAge) {
        document.cookie = `${name}=${value}; path=/; max-age=${maxAge}; SameSite=Lax`;
    }
    // Actions for external triggers
    open() {
        this.setOpen(true);
    }
    close() {
        this.setOpen(false);
    }
    // Handle clicking outside on mobile to close
    clickOutside(event) {
        if (this.isMobile && this.openMobileValue) {
            const sidebar = this.sidebarTargets[0];
            if (sidebar && !sidebar.contains(event.target)) {
                this.openMobileValue = false;
            }
        }
    }
}

/**
 * shadcn-rails Stimulus Controllers
 *
 * This file exports all Stimulus controllers for the shadcn-rails gem.
 * Import this file to register all controllers with your Stimulus application.
 *
 * Usage with importmaps:
 *   import { registerShadcnControllers } from "shadcn"
 *   registerShadcnControllers(application)
 *
 * Usage with esbuild/webpack:
 *   import { registerShadcnControllers } from "shadcn-rails-stimulus"
 *   registerShadcnControllers(application)
 */
// Controller definitions for registration
const controllers = {
    "shadcn--accordion": default_1$u,
    "shadcn--avatar": default_1$t,
    "shadcn--calendar": CalendarController,
    "shadcn--carousel": default_1$s,
    "shadcn--chart": default_1$r,
    "shadcn--date-picker": DatePickerController,
    "shadcn--checkbox": default_1$q,
    "shadcn--collapsible": default_1$p,
    "shadcn--combobox": default_1$o,
    "shadcn--command": default_1$n,
    "shadcn--command-dialog": default_1$m,
    "shadcn--context-menu": default_1$l,
    "shadcn--dialog": default_1$k,
    "shadcn--drawer": default_1$j,
    "shadcn--dropdown": default_1$i,
    "shadcn--hover-card": default_1$h,
    "shadcn--input-otp": default_1$1,
    "shadcn--menubar": default_1$g,
    "shadcn--navigation-menu": default_1$f,
    "shadcn--popover": default_1$e,
    "shadcn--radio-group": default_1$c,
    "shadcn--resizable": default_1$d,
    "shadcn--scroll-area": default_1$b,
    "shadcn--select": default_1$a,
    "shadcn--sheet": default_1$9,
    "shadcn--slider": default_1$8,
    "shadcn--switch": default_1$7,
    "shadcn--tabs": default_1$6,
    "shadcn--toast": default_1$5,
    "shadcn--toggle": default_1$4,
    "shadcn--toggle-group": default_1$3,
    "shadcn--tooltip": default_1$2,
    "shadcn--sidebar": default_1
};
/**
 * Register all shadcn controllers with a Stimulus application
 * @param {Application} application - The Stimulus application instance
 */
function registerShadcnControllers(application) {
    for (const [name, controller] of Object.entries(controllers)) {
        application.register(name, controller);
    }
}
// Default export for convenience
var index = { controllers, registerShadcnControllers };

export { default_1$u as AccordionController, default_1$t as AvatarController, default_1$v as BaseMenuController, CalendarController, default_1$s as CarouselController, default_1$r as ChartController, default_1$q as CheckboxController, default_1$p as CollapsibleController, default_1$o as ComboboxController, default_1$n as CommandController, default_1$m as CommandDialogController, default_1$l as ContextMenuController, DatePickerController, default_1$k as DialogController, default_1$j as DrawerController, default_1$i as DropdownController, default_1$h as HoverCardController, default_1$1 as InputOtpController, default_1$g as MenubarController, default_1$f as NavigationMenuController, default_1$e as PopoverController, default_1$c as RadioGroupController, default_1$d as ResizableController, default_1$b as ScrollAreaController, default_1$a as SelectController, default_1$9 as SheetController, default_1 as SidebarController, default_1$8 as SliderController, default_1$7 as SwitchController, default_1$6 as TabsController, default_1$5 as ToastController, default_1$4 as ToggleController, default_1$3 as ToggleGroupController, default_1$2 as TooltipController, controllers, index as default, positionAtPoint, positionFloating, registerShadcnControllers };
//# sourceMappingURL=index.esm.js.map
