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

// Import all controllers
import type { Application } from "@hotwired/stimulus"
import type { ShadcnControllerMap } from "./stimulus"
import BaseMenuController from "./controllers/base_menu_controller"
import AccordionController from "./controllers/accordion_controller"
import AvatarController from "./controllers/avatar_controller"
import CalendarController from "./controllers/calendar_controller"
import CarouselController from "./controllers/carousel_controller"
import ChartController from "./controllers/chart_controller"
import DatePickerController from "./controllers/date_picker_controller"
import CheckboxController from "./controllers/checkbox_controller"
import CollapsibleController from "./controllers/collapsible_controller"
import ComboboxController from "./controllers/combobox_controller"
import CommandController from "./controllers/command_controller"
import CommandDialogController from "./controllers/command_dialog_controller"
import ContextMenuController from "./controllers/context_menu_controller"
import DialogController from "./controllers/dialog_controller"
import DrawerController from "./controllers/drawer_controller"
import DropdownController from "./controllers/dropdown_controller"
import HoverCardController from "./controllers/hover_card_controller"
import MenubarController from "./controllers/menubar_controller"
import NavigationMenuController from "./controllers/navigation_menu_controller"
import PopoverController from "./controllers/popover_controller"
import ResizableController from "./controllers/resizable_controller"
import RadioGroupController from "./controllers/radio_group_controller"
import ScrollAreaController from "./controllers/scroll_area_controller"
import SelectController from "./controllers/select_controller"
import SheetController from "./controllers/sheet_controller"
import SliderController from "./controllers/slider_controller"
import SwitchController from "./controllers/switch_controller"
import TabsController from "./controllers/tabs_controller"
import ToastController from "./controllers/toast_controller"
import ToggleController from "./controllers/toggle_controller"
import ToggleGroupController from "./controllers/toggle_group_controller"
import TooltipController from "./controllers/tooltip_controller"
import InputOtpController from "./controllers/input_otp_controller"
import SidebarController from "./controllers/sidebar_controller"

// Import floating utility
import { positionFloating, positionAtPoint } from "./utils/floating"

export type {
  ShadcnControllerIdentifier,
  ShadcnControllerMap,
  ShadcnStimulusEvent,
  StimulusControllerConstructor
} from "./stimulus"

// Export individual controllers
export {
  BaseMenuController,
  AccordionController,
  AvatarController,
  CalendarController,
  CarouselController,
  ChartController,
  DatePickerController,
  CheckboxController,
  CollapsibleController,
  ComboboxController,
  CommandController,
  CommandDialogController,
  ContextMenuController,
  DialogController,
  DrawerController,
  DropdownController,
  HoverCardController,
  InputOtpController,
  MenubarController,
  NavigationMenuController,
  PopoverController,
  RadioGroupController,
  ResizableController,
  ScrollAreaController,
  SelectController,
  SheetController,
  SliderController,
  SwitchController,
  TabsController,
  ToastController,
  ToggleController,
  ToggleGroupController,
  TooltipController,
  SidebarController,
  // Utilities
  positionFloating,
  positionAtPoint
}

// Controller definitions for registration
export const controllers: ShadcnControllerMap = {
  "shadcn--accordion": AccordionController,
  "shadcn--avatar": AvatarController,
  "shadcn--calendar": CalendarController,
  "shadcn--carousel": CarouselController,
  "shadcn--chart": ChartController,
  "shadcn--date-picker": DatePickerController,
  "shadcn--checkbox": CheckboxController,
  "shadcn--collapsible": CollapsibleController,
  "shadcn--combobox": ComboboxController,
  "shadcn--command": CommandController,
  "shadcn--command-dialog": CommandDialogController,
  "shadcn--context-menu": ContextMenuController,
  "shadcn--dialog": DialogController,
  "shadcn--drawer": DrawerController,
  "shadcn--dropdown": DropdownController,
  "shadcn--hover-card": HoverCardController,
  "shadcn--input-otp": InputOtpController,
  "shadcn--menubar": MenubarController,
  "shadcn--navigation-menu": NavigationMenuController,
  "shadcn--popover": PopoverController,
  "shadcn--radio-group": RadioGroupController,
  "shadcn--resizable": ResizableController,
  "shadcn--scroll-area": ScrollAreaController,
  "shadcn--select": SelectController,
  "shadcn--sheet": SheetController,
  "shadcn--slider": SliderController,
  "shadcn--switch": SwitchController,
  "shadcn--tabs": TabsController,
  "shadcn--toast": ToastController,
  "shadcn--toggle": ToggleController,
  "shadcn--toggle-group": ToggleGroupController,
  "shadcn--tooltip": TooltipController,
  "shadcn--sidebar": SidebarController
}

/**
 * Register all shadcn controllers with a Stimulus application
 * @param {Application} application - The Stimulus application instance
 */
export function registerShadcnControllers(application: Application): void {
  for (const [name, controller] of Object.entries(controllers)) {
    application.register(name, controller)
  }
}

// Default export for convenience
export default { controllers, registerShadcnControllers }
