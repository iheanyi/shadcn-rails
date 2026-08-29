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
import type { Application } from "@hotwired/stimulus";
import type { ShadcnControllerMap } from "./stimulus";
import BaseMenuController from "./controllers/base_menu_controller";
import AccordionController from "./controllers/accordion_controller";
import AvatarController from "./controllers/avatar_controller";
import CalendarController from "./controllers/calendar_controller";
import CarouselController from "./controllers/carousel_controller";
import DatePickerController from "./controllers/date_picker_controller";
import CheckboxController from "./controllers/checkbox_controller";
import CollapsibleController from "./controllers/collapsible_controller";
import ComboboxController from "./controllers/combobox_controller";
import CommandController from "./controllers/command_controller";
import CommandDialogController from "./controllers/command_dialog_controller";
import ContextMenuController from "./controllers/context_menu_controller";
import DialogController from "./controllers/dialog_controller";
import DrawerController from "./controllers/drawer_controller";
import DropdownController from "./controllers/dropdown_controller";
import HoverCardController from "./controllers/hover_card_controller";
import MenubarController from "./controllers/menubar_controller";
import NavigationMenuController from "./controllers/navigation_menu_controller";
import PopoverController from "./controllers/popover_controller";
import ResizableController from "./controllers/resizable_controller";
import RadioGroupController from "./controllers/radio_group_controller";
import ScrollAreaController from "./controllers/scroll_area_controller";
import SelectController from "./controllers/select_controller";
import SheetController from "./controllers/sheet_controller";
import SliderController from "./controllers/slider_controller";
import SwitchController from "./controllers/switch_controller";
import TabsController from "./controllers/tabs_controller";
import ToastController from "./controllers/toast_controller";
import ToggleController from "./controllers/toggle_controller";
import ToggleGroupController from "./controllers/toggle_group_controller";
import TooltipController from "./controllers/tooltip_controller";
import InputOtpController from "./controllers/input_otp_controller";
import SidebarController from "./controllers/sidebar_controller";
import { positionFloating, positionAtPoint } from "./utils/floating";
export type { ShadcnControllerIdentifier, ShadcnControllerMap, ShadcnStimulusEvent, StimulusControllerConstructor } from "./stimulus";
export { BaseMenuController, AccordionController, AvatarController, CalendarController, CarouselController, DatePickerController, CheckboxController, CollapsibleController, ComboboxController, CommandController, CommandDialogController, ContextMenuController, DialogController, DrawerController, DropdownController, HoverCardController, InputOtpController, MenubarController, NavigationMenuController, PopoverController, RadioGroupController, ResizableController, ScrollAreaController, SelectController, SheetController, SliderController, SwitchController, TabsController, ToastController, ToggleController, ToggleGroupController, TooltipController, SidebarController, positionFloating, positionAtPoint };
export declare const controllers: ShadcnControllerMap;
/**
 * Register all shadcn controllers with a Stimulus application
 * @param {Application} application - The Stimulus application instance
 */
export declare function registerShadcnControllers(application: Application): void;
declare const _default: {
    controllers: ShadcnControllerMap;
    registerShadcnControllers: typeof registerShadcnControllers;
};
export default _default;
//# sourceMappingURL=index.d.ts.map