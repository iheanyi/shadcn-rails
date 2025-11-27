# frozen_string_literal: true

class DocsController < ApplicationController
  layout "docs"

  # Complete list of all shadcn-rails components with metadata
  COMPONENTS = {
    # Buttons & Actions
    "button" => {
      name: "Button",
      category: "Buttons & Actions",
      description: "Displays a button or a component that looks like a button.",
      has_stimulus: false
    },
    "toggle" => {
      name: "Toggle",
      category: "Buttons & Actions",
      description: "A two-state button that can be either on or off.",
      has_stimulus: true,
      controller: "shadcn--toggle"
    },
    "toggle-group" => {
      name: "Toggle Group",
      category: "Buttons & Actions",
      description: "A set of two-state buttons that can be toggled on or off.",
      has_stimulus: true,
      controller: "shadcn--toggle-group"
    },
    "button-group" => {
      name: "Button Group",
      category: "Buttons & Actions",
      description: "Groups related buttons together with connected styling.",
      has_stimulus: false
    },

    # Form Inputs
    "input" => {
      name: "Input",
      category: "Form Inputs",
      description: "Displays a form input field or a component that looks like an input field.",
      has_stimulus: false
    },
    "textarea" => {
      name: "Textarea",
      category: "Form Inputs",
      description: "Displays a form textarea or a component that looks like a textarea.",
      has_stimulus: false
    },
    "label" => {
      name: "Label",
      category: "Form Inputs",
      description: "Renders an accessible label associated with controls.",
      has_stimulus: false
    },
    "checkbox" => {
      name: "Checkbox",
      category: "Form Inputs",
      description: "A control that allows the user to toggle between checked and unchecked.",
      has_stimulus: true,
      controller: "shadcn--checkbox"
    },
    "switch" => {
      name: "Switch",
      category: "Form Inputs",
      description: "A control that allows the user to toggle between two states.",
      has_stimulus: true,
      controller: "shadcn--switch"
    },
    "slider" => {
      name: "Slider",
      category: "Form Inputs",
      description: "An input where the user selects a value from within a given range.",
      has_stimulus: true,
      controller: "shadcn--slider"
    },
    "select" => {
      name: "Select",
      category: "Form Inputs",
      description: "Displays a list of options for the user to pick from.",
      has_stimulus: true,
      controller: "shadcn--select"
    },
    "radio-group" => {
      name: "Radio Group",
      category: "Form Inputs",
      description: "A set of checkable buttons where only one can be checked at a time.",
      has_stimulus: true,
      controller: "shadcn--radio-group"
    },
    "field" => {
      name: "Field",
      category: "Form Inputs",
      description: "A form field wrapper with label, input, description, and error message support.",
      has_stimulus: false
    },
    "input-group" => {
      name: "Input Group",
      category: "Form Inputs",
      description: "Input with prefix and/or suffix addons for icons, text, or other elements.",
      has_stimulus: false
    },
    "native-select" => {
      name: "Native Select",
      category: "Form Inputs",
      description: "A styled native HTML select element with optgroup support.",
      has_stimulus: false
    },
    "input-otp" => {
      name: "Input OTP",
      category: "Form Inputs",
      description: "One-time password input with auto-focus and paste support.",
      has_stimulus: true,
      controller: "shadcn--input-otp"
    },

    # Data Display
    "badge" => {
      name: "Badge",
      category: "Data Display",
      description: "Displays a badge or a component that looks like a badge.",
      has_stimulus: false
    },
    "avatar" => {
      name: "Avatar",
      category: "Data Display",
      description: "An image element with a fallback for representing the user.",
      has_stimulus: true,
      controller: "shadcn--avatar"
    },
    "card" => {
      name: "Card",
      category: "Data Display",
      description: "Displays a card with header, content, and footer.",
      has_stimulus: false
    },
    "table" => {
      name: "Table",
      category: "Data Display",
      description: "A responsive table component.",
      has_stimulus: false
    },
    "progress" => {
      name: "Progress",
      category: "Data Display",
      description: "Displays an indicator showing the completion progress of a task.",
      has_stimulus: false
    },
    "skeleton" => {
      name: "Skeleton",
      category: "Data Display",
      description: "Used to show a placeholder while content is loading.",
      has_stimulus: false
    },
    "spinner" => {
      name: "Spinner",
      category: "Data Display",
      description: "A loading spinner animation for indicating loading states.",
      has_stimulus: false
    },
    "kbd" => {
      name: "Kbd",
      category: "Data Display",
      description: "Displays keyboard input or shortcuts.",
      has_stimulus: false
    },
    "typography" => {
      name: "Typography",
      category: "Data Display",
      description: "Styles for headings, paragraphs, lists, and other text elements.",
      has_stimulus: false
    },
    "aspect-ratio" => {
      name: "Aspect Ratio",
      category: "Data Display",
      description: "Displays content within a desired ratio.",
      has_stimulus: false
    },
    "empty" => {
      name: "Empty",
      category: "Data Display",
      description: "Displays an empty state with media, title, description, and action content.",
      has_stimulus: false
    },
    "item" => {
      name: "Item",
      category: "Data Display",
      description: "A flexible flex container for displaying titles, descriptions, and actions.",
      has_stimulus: false
    },
    "scroll-area" => {
      name: "Scroll Area",
      category: "Data Display",
      description: "Augments native scroll functionality for custom, cross-browser styling.",
      has_stimulus: true,
      controller: "shadcn--scroll-area"
    },

    # Feedback
    "alert" => {
      name: "Alert",
      category: "Feedback",
      description: "Displays a callout for user attention.",
      has_stimulus: false
    },
    "tooltip" => {
      name: "Tooltip",
      category: "Feedback",
      description: "A popup that displays information related to an element.",
      has_stimulus: true,
      controller: "shadcn--tooltip"
    },
    "toast" => {
      name: "Toast",
      category: "Feedback",
      description: "A succinct message that is displayed temporarily.",
      has_stimulus: true,
      controller: "shadcn--toast"
    },

    # Overlays
    "dialog" => {
      name: "Dialog",
      category: "Overlays",
      description: "A modal dialog that interrupts the user with important content.",
      has_stimulus: true,
      controller: "shadcn--dialog"
    },
    "alert-dialog" => {
      name: "Alert Dialog",
      category: "Overlays",
      description: "A modal dialog that interrupts the user with important content and expects a response.",
      has_stimulus: true,
      controller: "shadcn--dialog"
    },
    "sheet" => {
      name: "Sheet",
      category: "Overlays",
      description: "Extends the Dialog component to display content that complements the main content.",
      has_stimulus: true,
      controller: "shadcn--sheet"
    },
    "drawer" => {
      name: "Drawer",
      category: "Overlays",
      description: "A panel that slides in from the edge of the screen.",
      has_stimulus: true,
      controller: "shadcn--drawer"
    },
    "popover" => {
      name: "Popover",
      category: "Overlays",
      description: "Displays rich content in a portal, triggered by a button.",
      has_stimulus: true,
      controller: "shadcn--popover"
    },
    "hover-card" => {
      name: "Hover Card",
      category: "Overlays",
      description: "For sighted users to preview content available behind a link.",
      has_stimulus: true,
      controller: "shadcn--hover-card"
    },
    "dropdown-menu" => {
      name: "Dropdown Menu",
      category: "Overlays",
      description: "Displays a menu to the user.",
      has_stimulus: true,
      controller: "shadcn--dropdown"
    },
    "context-menu" => {
      name: "Context Menu",
      category: "Overlays",
      description: "Displays a menu to the user triggered by right-click.",
      has_stimulus: true,
      controller: "shadcn--context-menu"
    },

    # Navigation
    "tabs" => {
      name: "Tabs",
      category: "Navigation",
      description: "A set of layered sections of content.",
      has_stimulus: true,
      controller: "shadcn--tabs"
    },
    "accordion" => {
      name: "Accordion",
      category: "Navigation",
      description: "A vertically stacked set of interactive headings.",
      has_stimulus: true,
      controller: "shadcn--accordion"
    },
    "breadcrumb" => {
      name: "Breadcrumb",
      category: "Navigation",
      description: "Displays the path to the current resource using a hierarchy of links.",
      has_stimulus: false
    },
    "menubar" => {
      name: "Menubar",
      category: "Navigation",
      description: "A visually persistent menu common in desktop applications that provides quick access to a consistent set of commands.",
      has_stimulus: true,
      controller: "shadcn--menubar"
    },
    "navigation-menu" => {
      name: "Navigation Menu",
      category: "Navigation",
      description: "A collection of links for navigating websites.",
      has_stimulus: true,
      controller: "shadcn--navigation-menu"
    },
    "pagination" => {
      name: "Pagination",
      category: "Navigation",
      description: "Pagination with page navigation, next and previous links.",
      has_stimulus: false
    },
    "collapsible" => {
      name: "Collapsible",
      category: "Navigation",
      description: "An interactive component which expands/collapses a panel.",
      has_stimulus: true,
      controller: "shadcn--collapsible"
    },
    "separator" => {
      name: "Separator",
      category: "Navigation",
      description: "Visually or semantically separates content.",
      has_stimulus: false
    },

    # Layout
    "resizable" => {
      name: "Resizable",
      category: "Layout",
      description: "Accessible resizable panel groups and layouts with keyboard support.",
      has_stimulus: true,
      controller: "shadcn--resizable"
    }
  }.freeze

  CATEGORIES = [
    "Buttons & Actions",
    "Form Inputs",
    "Data Display",
    "Feedback",
    "Overlays",
    "Navigation",
    "Layout"
  ].freeze

  def index
    @components = COMPONENTS
    @categories = CATEGORIES
    @components_by_category = COMPONENTS.group_by { |_slug, meta| meta[:category] }
  end

  def show
    @slug = params[:slug]
    @component = COMPONENTS[@slug]

    if @component.nil?
      redirect_to docs_path, alert: "Component not found"
      return
    end

    # Try to render a specific template, fall back to a generic show template
    render @slug
  rescue ActionView::MissingTemplate
    render :show
  end

  private

  def component_class_name(slug)
    "Shadcn::#{slug.gsub('-', '_').camelize}Component"
  end
  helper_method :component_class_name

  def component_class(slug)
    component_class_name(slug).constantize
  rescue NameError
    nil
  end
  helper_method :component_class
end
