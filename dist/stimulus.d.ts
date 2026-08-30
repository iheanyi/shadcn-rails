import type { ControllerConstructor } from "@hotwired/stimulus";
export type StimulusControllerConstructor = ControllerConstructor;
export type ShadcnControllerIdentifier = "shadcn--accordion" | "shadcn--avatar" | "shadcn--calendar" | "shadcn--carousel" | "shadcn--chart" | "shadcn--date-picker" | "shadcn--checkbox" | "shadcn--collapsible" | "shadcn--combobox" | "shadcn--command" | "shadcn--command-dialog" | "shadcn--context-menu" | "shadcn--dialog" | "shadcn--drawer" | "shadcn--dropdown" | "shadcn--hover-card" | "shadcn--input-otp" | "shadcn--menubar" | "shadcn--navigation-menu" | "shadcn--popover" | "shadcn--radio-group" | "shadcn--resizable" | "shadcn--scroll-area" | "shadcn--select" | "shadcn--sheet" | "shadcn--slider" | "shadcn--switch" | "shadcn--tabs" | "shadcn--toast" | "shadcn--toggle" | "shadcn--toggle-group" | "shadcn--tooltip" | "shadcn--sidebar";
export type ShadcnCoreControllerIdentifier = Exclude<ShadcnControllerIdentifier, "shadcn--chart">;
export type ShadcnControllerMap = Record<ShadcnCoreControllerIdentifier, StimulusControllerConstructor>;
export type ShadcnStimulusEvent<T extends EventTarget = HTMLElement> = Event & {
    currentTarget: T;
    target: EventTarget | null;
};
declare global {
    type ShadcnEvent<T extends HTMLElement = HTMLElement> = Event & {
        [eventProperty: string]: any;
        currentTarget: any;
        target: any;
    };
    interface Element {
        [htmlTargetProperty: string]: any;
    }
    interface HTMLElement {
        [htmlTargetProperty: string]: any;
    }
}
declare module "@hotwired/stimulus" {
    interface Controller<ElementType extends Element = Element> {
        [stimulusGeneratedProperty: string]: any;
    }
}
//# sourceMappingURL=stimulus.d.ts.map