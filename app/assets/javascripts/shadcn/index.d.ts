/**
 * shadcn-rails Stimulus Controllers - TypeScript Type Definitions
 *
 * This file provides TypeScript type definitions for all shadcn-rails
 * Stimulus controllers without requiring TypeScript compilation.
 */

import { Application } from "@hotwired/stimulus";

// Re-export individual controllers
export { default as AccordionController } from "./controllers/accordion_controller";
export { default as AvatarController } from "./controllers/avatar_controller";
export { default as CheckboxController } from "./controllers/checkbox_controller";
export { default as CollapsibleController } from "./controllers/collapsible_controller";
export { default as DialogController } from "./controllers/dialog_controller";
export { default as DrawerController } from "./controllers/drawer_controller";
export { default as DropdownController } from "./controllers/dropdown_controller";
export { default as HoverCardController } from "./controllers/hover_card_controller";
export { default as PopoverController } from "./controllers/popover_controller";
export { default as RadioGroupController } from "./controllers/radio_group_controller";
export { default as ScrollAreaController } from "./controllers/scroll_area_controller";
export { default as SelectController } from "./controllers/select_controller";
export { default as SheetController } from "./controllers/sheet_controller";
export { default as SliderController } from "./controllers/slider_controller";
export { default as SwitchController } from "./controllers/switch_controller";
export { default as TabsController } from "./controllers/tabs_controller";
export { default as ToastController } from "./controllers/toast_controller";
export { default as ToggleController } from "./controllers/toggle_controller";
export { default as ToggleGroupController } from "./controllers/toggle_group_controller";
export { default as TooltipController } from "./controllers/tooltip_controller";

/**
 * Controller name to controller class mapping
 */
export const controllers: {
  "shadcn--accordion": typeof AccordionController;
  "shadcn--avatar": typeof AvatarController;
  "shadcn--checkbox": typeof CheckboxController;
  "shadcn--collapsible": typeof CollapsibleController;
  "shadcn--dialog": typeof DialogController;
  "shadcn--drawer": typeof DrawerController;
  "shadcn--dropdown": typeof DropdownController;
  "shadcn--hover-card": typeof HoverCardController;
  "shadcn--popover": typeof PopoverController;
  "shadcn--radio-group": typeof RadioGroupController;
  "shadcn--scroll-area": typeof ScrollAreaController;
  "shadcn--select": typeof SelectController;
  "shadcn--sheet": typeof SheetController;
  "shadcn--slider": typeof SliderController;
  "shadcn--switch": typeof SwitchController;
  "shadcn--tabs": typeof TabsController;
  "shadcn--toast": typeof ToastController;
  "shadcn--toggle": typeof ToggleController;
  "shadcn--toggle-group": typeof ToggleGroupController;
  "shadcn--tooltip": typeof TooltipController;
};

/**
 * Register all shadcn controllers with a Stimulus application
 * @param application - The Stimulus application instance
 */
export function registerShadcnControllers(application: Application): void;

/**
 * Default export containing controllers and registration function
 */
declare const _default: {
  controllers: typeof controllers;
  registerShadcnControllers: typeof registerShadcnControllers;
};

export default _default;
