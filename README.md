# shadcn-rails

Beautiful, accessible UI components for Rails built with ViewComponents, Stimulus, and Tailwind CSS. A Ruby port of [shadcn/ui](https://ui.shadcn.com).

[![CI](https://github.com/iheanyi/shadcn-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/iheanyi/shadcn-rails/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/shadcn-rails.svg)](https://rubygems.org/gems/shadcn-rails)
[![npm version](https://badge.fury.io/js/shadcn-rails-stimulus.svg)](https://www.npmjs.com/package/shadcn-rails-stimulus)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.1-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/rails-%3E%3D%207.0-red.svg)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- **Beautiful by default** - Carefully crafted components that look great out of the box
- **Accessible** - Built with accessibility in mind, following WAI-ARIA patterns
- **Customizable** - Use CSS variables to customize the look and feel
- **Dark mode** - Built-in dark mode support with multiple strategies
- **ViewComponents** - Leverages Rails' ViewComponent library for composable, testable components
- **Stimulus** - Interactive components powered by Stimulus controllers
- **Rails-first** - Designed specifically for Ruby on Rails applications
- **47 Components** - Comprehensive library covering all common UI patterns

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Components](#components)
  - [Buttons & Actions](#buttons--actions)
  - [Form Inputs](#form-inputs)
  - [Data Display](#data-display)
  - [Feedback](#feedback)
  - [Overlays](#overlays)
  - [Navigation](#navigation)
  - [Layout](#layout)
- [Theming](#theming)
- [Dark Mode](#dark-mode)
- [Configuration](#configuration)
- [Stimulus Controllers](#stimulus-controllers)
- [Testing](#testing)
- [Development](#development)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "shadcn-rails"
```

Then execute:

```bash
bundle install
rails generate shadcn:install
```

This will:
1. Create a configuration initializer at `config/initializers/shadcn.rb`
2. Add the required CSS imports to your application
3. Configure your Stimulus controllers

### Stylesheets

shadcn-rails includes two CSS files:

| File | Purpose |
|------|---------|
| `shadcn/base.css` | CSS variables for theming (colors, border radius), animations, and focus styles |
| `shadcn/components.css` | Component-specific styles for interactive elements (`data-state` attributes, custom inputs) |

**For Tailwind CSS** (application.tailwind.css):

```css
@import "shadcn/base";
@import "shadcn/components";

@tailwind base;
@tailwind components;
@tailwind utilities;
```

**For Sprockets** (application.css):

```css
/*
 *= require shadcn/base
 *= require shadcn/components
 *= require_self
 */
```

The `components.css` file includes essential styles for:
- **Switch** - `data-state` based checked/unchecked styling
- **Slider** - Custom range input with fill indicator
- **Checkbox/Radio** - Native inputs with custom styling
- **Accordion/Collapsible** - Content animations
- **Dialog/Sheet/Popover** - Open/close animations and overlays
- **Tabs** - Active/inactive state styling

### Requirements

- Ruby >= 3.1
- Rails >= 7.0
- Tailwind CSS >= 3.0
- Stimulus >= 3.0
- ViewComponent >= 3.0

### Tailwind CSS Configuration

Ensure your `tailwind.config.js` includes the shadcn-rails color configuration:

```javascript
module.exports = {
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
}
```

## Quick Start

```erb
<%# Simple button %>
<%= render Shadcn::ButtonComponent.new { "Click me" } %>

<%# Button with variant %>
<%= render Shadcn::ButtonComponent.new(variant: :destructive) { "Delete" } %>

<%# Card with slots %>
<%= render Shadcn::CardComponent.new do |card| %>
  <% card.with_header do |header| %>
    <% header.with_title { "Welcome" } %>
    <% header.with_description { "Get started with shadcn-rails" } %>
  <% end %>
  <% card.with_content_slot do %>
    <p>Your content here</p>
  <% end %>
<% end %>
```

## Components

### Buttons & Actions

#### Button

Displays a button or a component that looks like a button.

```erb
<%# Variants %>
<%= render Shadcn::ButtonComponent.new(variant: :default) { "Default" } %>
<%= render Shadcn::ButtonComponent.new(variant: :secondary) { "Secondary" } %>
<%= render Shadcn::ButtonComponent.new(variant: :destructive) { "Destructive" } %>
<%= render Shadcn::ButtonComponent.new(variant: :outline) { "Outline" } %>
<%= render Shadcn::ButtonComponent.new(variant: :ghost) { "Ghost" } %>
<%= render Shadcn::ButtonComponent.new(variant: :link) { "Link" } %>

<%# Sizes %>
<%= render Shadcn::ButtonComponent.new(size: :sm) { "Small" } %>
<%= render Shadcn::ButtonComponent.new(size: :default) { "Default" } %>
<%= render Shadcn::ButtonComponent.new(size: :lg) { "Large" } %>
<%= render Shadcn::ButtonComponent.new(size: :icon) { "+" } %>

<%# States %>
<%= render Shadcn::ButtonComponent.new(disabled: true) { "Disabled" } %>

<%# As link %>
<%= render Shadcn::ButtonComponent.new(href: "/path", variant: :outline) { "Link Button" } %>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | Symbol | `:default` | `:default`, `:secondary`, `:destructive`, `:outline`, `:ghost`, `:link` |
| `size` | Symbol | `:default` | `:default`, `:sm`, `:lg`, `:icon` |
| `disabled` | Boolean | `false` | Disables the button |
| `href` | String | `nil` | Renders as a link when provided |
| `type` | String | `"button"` | Button type attribute |

#### Toggle

A two-state button that can be either on or off.

```erb
<%= render Shadcn::ToggleComponent.new do %>
  <svg><!-- icon --></svg>
<% end %>

<%= render Shadcn::ToggleComponent.new(variant: :outline, pressed: true) do %>
  Bold
<% end %>
```

#### Toggle Group

A set of two-state buttons that can be toggled on or off.

```erb
<%# Single selection %>
<%= render Shadcn::ToggleGroupComponent.new(type: :single) do |group| %>
  <% group.with_item(value: "bold") { "B" } %>
  <% group.with_item(value: "italic") { "I" } %>
  <% group.with_item(value: "underline") { "U" } %>
<% end %>

<%# Multiple selection %>
<%= render Shadcn::ToggleGroupComponent.new(type: :multiple, variant: :outline) do |group| %>
  <% group.with_item(value: "left") { "Left" } %>
  <% group.with_item(value: "center") { "Center" } %>
  <% group.with_item(value: "right") { "Right" } %>
<% end %>
```

### Form Inputs

#### Input

Displays a form input field.

```erb
<%= render Shadcn::InputComponent.new(
  type: :email,
  placeholder: "you@example.com",
  id: "email",
  name: "user[email]"
) %>

<%# Disabled %>
<%= render Shadcn::InputComponent.new(
  type: :text,
  placeholder: "Disabled",
  disabled: true
) %>

<%# With validation error %>
<%= render Shadcn::InputComponent.new(
  type: :text,
  class_name: "border-destructive"
) %>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `type` | Symbol/String | `:text` | Input type (`:text`, `:email`, `:password`, `:number`, `:search`, `:file`, etc.) |
| `placeholder` | String | `nil` | Placeholder text |
| `disabled` | Boolean | `false` | Disables the input |
| `required` | Boolean | `false` | Makes input required |

#### Textarea

Displays a multi-line text input.

```erb
<%= render Shadcn::TextareaComponent.new(
  placeholder: "Type your message here...",
  rows: 4,
  name: "message"
) %>
```

#### Label

Renders an accessible label associated with controls.

```erb
<%= render Shadcn::LabelComponent.new(for: "email") { "Email Address" } %>
<%= render Shadcn::InputComponent.new(id: "email", type: :email) %>
```

#### Checkbox

A control that allows toggling between checked and not checked.

```erb
<%= render Shadcn::CheckboxComponent.new(
  id: "terms",
  label: "Accept terms and conditions"
) %>

<%# Checked by default %>
<%= render Shadcn::CheckboxComponent.new(
  id: "newsletter",
  label: "Subscribe to newsletter",
  checked: true
) %>

<%# Disabled %>
<%= render Shadcn::CheckboxComponent.new(
  id: "disabled",
  label: "Disabled option",
  disabled: true
) %>
```

#### Switch

A control that allows toggling between a checked and not checked state.

```erb
<%= render Shadcn::SwitchComponent.new(
  id: "airplane",
  label: "Airplane Mode"
) %>

<%= render Shadcn::SwitchComponent.new(
  id: "notifications",
  label: "Enable notifications",
  checked: true
) %>
```

#### Radio Group

A set of checkable buttons where only one can be checked at a time.

```erb
<%= render Shadcn::RadioGroupComponent.new(name: "plan", default_value: "comfortable") do |group| %>
  <% group.with_item(value: "default", label: "Default") %>
  <% group.with_item(value: "comfortable", label: "Comfortable") %>
  <% group.with_item(value: "compact", label: "Compact") %>
<% end %>
```

#### Select

Displays a list of options for the user to pick from.

```erb
<%= render Shadcn::SelectComponent.new(placeholder: "Select a fruit") do |select| %>
  <% select.with_group(label: "Fruits") do |group| %>
    <% group.with_item(value: "apple") { "Apple" } %>
    <% group.with_item(value: "banana") { "Banana" } %>
    <% group.with_item(value: "orange") { "Orange" } %>
  <% end %>
<% end %>
```

#### Slider

An input where the user selects a value from within a given range.

```erb
<%= render Shadcn::SliderComponent.new(value: 50, max: 100) %>
<%= render Shadcn::SliderComponent.new(value: 25, min: 0, max: 100, step: 5) %>
```

### Data Display

#### Badge

Displays a badge or label.

```erb
<%= render Shadcn::BadgeComponent.new(variant: :default) { "Default" } %>
<%= render Shadcn::BadgeComponent.new(variant: :secondary) { "Secondary" } %>
<%= render Shadcn::BadgeComponent.new(variant: :destructive) { "Error" } %>
<%= render Shadcn::BadgeComponent.new(variant: :outline) { "Outline" } %>
```

#### Avatar

An image element with a fallback for representing the user.

```erb
<%# With image %>
<%= render Shadcn::AvatarComponent.new(
  src: "https://example.com/avatar.jpg",
  alt: "John Doe",
  fallback: "JD"
) %>

<%# Without image (shows fallback) %>
<%= render Shadcn::AvatarComponent.new(
  alt: "Jane Smith",
  fallback: "JS"
) %>

<%# Sizes %>
<%= render Shadcn::AvatarComponent.new(size: :sm, fallback: "SM") %>
<%= render Shadcn::AvatarComponent.new(size: :default, fallback: "MD") %>
<%= render Shadcn::AvatarComponent.new(size: :lg, fallback: "LG") %>
```

#### Card

Displays a card with header, content, and footer.

```erb
<%= render Shadcn::CardComponent.new do |card| %>
  <% card.with_header do |header| %>
    <% header.with_title { "Card Title" } %>
    <% header.with_description { "Card description goes here" } %>
  <% end %>
  <% card.with_content_slot do %>
    <p>This is the main content of the card.</p>
  <% end %>
  <% card.with_footer do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Cancel" } %>
    <%= render Shadcn::ButtonComponent.new { "Save" } %>
  <% end %>
<% end %>

<%# Simple card (content only) %>
<%= render Shadcn::CardComponent.new do |card| %>
  <% card.with_content_slot(standalone: true) do %>
    <p>A simple card with just content.</p>
  <% end %>
<% end %>
```

#### Table

A responsive table component.

```erb
<%= render Shadcn::TableComponent.new do |table| %>
  <% table.with_header do |header| %>
    <% header.with_row do |row| %>
      <% row.with_head { "Name" } %>
      <% row.with_head { "Status" } %>
      <% row.with_head(class_name: "text-right") { "Amount" } %>
    <% end %>
  <% end %>
  <% table.with_body do |body| %>
    <% body.with_row do |row| %>
      <% row.with_cell { "John Doe" } %>
      <% row.with_cell { "Active" } %>
      <% row.with_cell(class_name: "text-right") { "$250.00" } %>
    <% end %>
  <% end %>
<% end %>
```

#### Progress

Displays an indicator showing the completion progress of a task.

```erb
<%= render Shadcn::ProgressComponent.new(value: 33) %>
<%= render Shadcn::ProgressComponent.new(value: 66) %>
<%= render Shadcn::ProgressComponent.new(value: 100) %>
```

#### Skeleton

Use to show a placeholder while content is loading.

```erb
<div class="flex items-center space-x-4">
  <%= render Shadcn::SkeletonComponent.new(class_name: "h-12 w-12 rounded-full") %>
  <div class="space-y-2">
    <%= render Shadcn::SkeletonComponent.new(class_name: "h-4 w-[250px]") %>
    <%= render Shadcn::SkeletonComponent.new(class_name: "h-4 w-[200px]") %>
  </div>
</div>
```

#### Aspect Ratio

Displays content within a desired ratio.

```erb
<%= render Shadcn::AspectRatioComponent.new(ratio: "16/9") do %>
  <img src="image.jpg" class="object-cover w-full h-full" />
<% end %>

<%# Common ratios: "1/1", "4/3", "16/9", "21/9" %>
```

### Feedback

#### Alert

Displays a callout for user attention.

```erb
<%# Default alert %>
<%= render Shadcn::AlertComponent.new do |alert| %>
  <% alert.with_title { "Heads up!" } %>
  <% alert.with_description { "You can add components using the CLI." } %>
<% end %>

<%# Destructive alert %>
<%= render Shadcn::AlertComponent.new(variant: :destructive) do |alert| %>
  <% alert.with_title { "Error" } %>
  <% alert.with_description { "Your session has expired." } %>
<% end %>
```

#### Tooltip

A popup that displays information when hovering.

```erb
<%= render Shadcn::TooltipComponent.new(content: "Add to library", side: :top) do |tooltip| %>
  <% tooltip.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline, size: :icon) { "+" } %>
  <% end %>
<% end %>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `content` | String | required | Tooltip text |
| `side` | Symbol | `:top` | `:top`, `:bottom`, `:left`, `:right` |
| `delay` | Integer | `200` | Delay in milliseconds before showing |

### Overlays

#### Dialog

A modal dialog window.

```erb
<%= render Shadcn::DialogComponent.new do |dialog| %>
  <% dialog.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new { "Open Dialog" } %>
  <% end %>
  <% dialog.with_body do |body| %>
    <% body.with_header do |header| %>
      <% header.with_title { "Edit Profile" } %>
      <% header.with_description { "Make changes to your profile here." } %>
    <% end %>
    <div class="py-4">
      <%# Form content %>
    </div>
    <% body.with_footer do %>
      <%= render Shadcn::ButtonComponent.new { "Save changes" } %>
    <% end %>
  <% end %>
<% end %>
```

##### Dialog with ID (for Turbo Stream targeting)

```erb
<%= render Shadcn::DialogComponent.new(id: "edit-profile-dialog") do |dialog| %>
  <%# ... %>
<% end %>
```

##### Closing Dialog Programmatically

Use Stimulus actions to close dialogs from buttons:

```erb
<%# Cancel button closes immediately %>
<%= render Shadcn::ButtonComponent.new(
  variant: :outline,
  type: "button",
  data: { action: "click->shadcn--dialog#close" }
) { "Cancel" } %>

<%# Or close from any element %>
<button data-action="click->shadcn--dialog#close">Close</button>
```

##### Forms Inside Dialogs

For forms that should close the dialog only on successful submission:

```erb
<%= render Shadcn::DialogComponent.new do |dialog| %>
  <% dialog.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Edit Profile" } %>
  <% end %>
  <% dialog.with_body do |body| %>
    <% body.with_header do |header| %>
      <% header.with_title { "Edit Profile" } %>
      <% header.with_description { "Make changes to your profile here." } %>
    <% end %>
    <%= form_with model: @user, data: { remote: "true" } do |f| %>
      <div class="space-y-4">
        <%= render Shadcn::LabelComponent.new(for: "name") { "Name" } %>
        <%= render Shadcn::InputComponent.new(id: "name", name: "user[name]", value: @user.name) %>
      </div>
      <div class="flex justify-end gap-3 mt-4">
        <%= render Shadcn::ButtonComponent.new(
          variant: :outline,
          type: "button",
          data: { action: "click->shadcn--dialog#close" }
        ) { "Cancel" } %>
        <%= render Shadcn::ButtonComponent.new(type: "submit") { "Save Changes" } %>
      </div>
    <% end %>
  <% end %>
<% end %>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `id` | String | `nil` | Unique identifier for Turbo Stream targeting |
| `open` | Boolean | `false` | Whether dialog starts open |
| `modal` | Boolean | `true` | Whether dialog traps focus and blocks interaction |

#### Alert Dialog

A modal dialog for destructive or important actions.

```erb
<%= render Shadcn::AlertDialogComponent.new do |dialog| %>
  <% dialog.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :destructive) { "Delete Account" } %>
  <% end %>
  <% dialog.with_body do |body| %>
    <% body.with_header do |header| %>
      <% header.with_title { "Are you absolutely sure?" } %>
      <% header.with_description { "This action cannot be undone." } %>
    <% end %>
    <% body.with_footer do %>
      <%= render Shadcn::ButtonComponent.new(variant: :outline, data: { action: "click->shadcn--alert-dialog#close" }) { "Cancel" } %>
      <%= render Shadcn::ButtonComponent.new(variant: :destructive) { "Delete" } %>
    <% end %>
  <% end %>
<% end %>
```

#### Sheet

Extends the Dialog component to display content that complements the main content.

```erb
<%= render Shadcn::SheetComponent.new(side: :right) do |sheet| %>
  <% sheet.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Sheet" } %>
  <% end %>
  <% sheet.with_body do |body| %>
    <% body.with_header do |header| %>
      <% header.with_title { "Settings" } %>
      <% header.with_description { "Configure your preferences." } %>
    <% end %>
    <div class="py-4">
      <%# Sheet content %>
    </div>
  <% end %>
<% end %>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `side` | Symbol | `:right` | `:top`, `:right`, `:bottom`, `:left` |

#### Drawer

A drawer component for mobile interfaces.

```erb
<%= render Shadcn::DrawerComponent.new do |drawer| %>
  <% drawer.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Drawer" } %>
  <% end %>
  <% drawer.with_body do |body| %>
    <% body.with_header do |header| %>
      <% header.with_title { "Drawer Title" } %>
      <% header.with_description { "Drawer description" } %>
    <% end %>
    <div class="p-4">
      <%# Drawer content %>
    </div>
    <% body.with_footer do %>
      <%= render Shadcn::ButtonComponent.new(class_name: "w-full") { "Submit" } %>
    <% end %>
  <% end %>
<% end %>
```

#### Popover

Displays rich content in a portal, triggered by a button.

```erb
<%= render Shadcn::PopoverComponent.new do |popover| %>
  <% popover.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Popover" } %>
  <% end %>
  <% popover.with_content do %>
    <div class="grid gap-4">
      <h4 class="font-medium">Dimensions</h4>
      <p class="text-sm text-muted-foreground">Set the dimensions for the layer.</p>
    </div>
  <% end %>
<% end %>
```

#### Hover Card

For sighted users to preview content available behind a link.

```erb
<%= render Shadcn::HoverCardComponent.new do |card| %>
  <% card.with_trigger do %>
    <a href="#" class="underline">@shadcn</a>
  <% end %>
  <% card.with_card_content do %>
    <div class="flex space-x-4">
      <%= render Shadcn::AvatarComponent.new(src: "avatar.jpg", fallback: "SC") %>
      <div>
        <h4 class="text-sm font-semibold">@shadcn</h4>
        <p class="text-sm">Creator of shadcn/ui</p>
      </div>
    </div>
  <% end %>
<% end %>
```

#### Dropdown Menu

Displays a menu of actions or functions triggered by a button.

```erb
<%= render Shadcn::DropdownMenuComponent.new do |menu| %>
  <% menu.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Menu" } %>
  <% end %>
  <% menu.with_content do |content| %>
    <% content.with_label { "My Account" } %>
    <% content.with_separator %>
    <% content.with_item { "Profile" } %>
    <% content.with_item { "Settings" } %>
    <% content.with_separator %>
    <% content.with_item { "Log out" } %>
  <% end %>
<% end %>
```

### Navigation

#### Tabs

A set of layered sections of content that are displayed one at a time.

```erb
<%= render Shadcn::TabsComponent.new(default_value: "account") do |tabs| %>
  <% tabs.with_list do |list| %>
    <% list.with_trigger(value: "account") { "Account" } %>
    <% list.with_trigger(value: "password") { "Password" } %>
    <% list.with_trigger(value: "settings", disabled: true) { "Settings" } %>
  <% end %>
  <% tabs.with_panel(value: "account") do %>
    <p>Account settings here.</p>
  <% end %>
  <% tabs.with_panel(value: "password") do %>
    <p>Password settings here.</p>
  <% end %>
<% end %>
```

##### URL Synchronization

Sync the active tab state with the URL query parameter for shareable links and browser history support:

```erb
<%# Tab state syncs to URL: /settings?tab=billing %>
<%= render Shadcn::TabsComponent.new(default_value: "general", url_param: "tab") do |tabs| %>
  <% tabs.with_list do |list| %>
    <% list.with_trigger(value: "general") { "General" } %>
    <% list.with_trigger(value: "billing") { "Billing" } %>
    <% list.with_trigger(value: "security") { "Security" } %>
  <% end %>
  <% tabs.with_panel(value: "general") do %>
    <p>General settings</p>
  <% end %>
  <% tabs.with_panel(value: "billing") do %>
    <p>Billing settings</p>
  <% end %>
  <% tabs.with_panel(value: "security") do %>
    <p>Security settings</p>
  <% end %>
<% end %>
```

When `url_param` is set:
- The URL updates when tabs are clicked (e.g., `?tab=billing`)
- Direct navigation to URLs with the parameter selects the correct tab
- Browser back/forward navigation works as expected

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `default_value` | String | `nil` | Initially active tab value |
| `url_param` | String | `nil` | URL query parameter name for state sync |

#### Accordion

A vertically stacked set of interactive headings that reveal sections of content.

```erb
<%= render Shadcn::AccordionComponent.new(type: :single, collapsible: true) do |accordion| %>
  <% accordion.with_item(value: "item-1") do |item| %>
    <% item.with_trigger { "Is it accessible?" } %>
    <% item.with_body { "Yes. It adheres to WAI-ARIA design patterns." } %>
  <% end %>
  <% accordion.with_item(value: "item-2") do |item| %>
    <% item.with_trigger { "Is it styled?" } %>
    <% item.with_body { "Yes. It comes with default styles." } %>
  <% end %>
<% end %>
```

**Props:**
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `type` | Symbol | `:single` | `:single` (one open), `:multiple` (many open) |
| `collapsible` | Boolean | `false` | Allow closing all items |
| `default_value` | String | `nil` | Initially open item(s) |

#### Breadcrumb

Displays the path to the current resource using a hierarchy of links.

```erb
<%= render Shadcn::BreadcrumbComponent.new do |breadcrumb| %>
  <% breadcrumb.with_item(href: "/") { "Home" } %>
  <% breadcrumb.with_item(href: "/products") { "Products" } %>
  <% breadcrumb.with_item(current: true) { "Widget" } %>
<% end %>
```

#### Pagination

Pagination with page navigation, next and previous links. Supports three usage patterns:

**1. Auto-generated from Kaminari collection:**

```erb
<%# Works with Kaminari paginated collections %>
<%= render Shadcn::PaginationComponent.new(collection: @posts) %>
```

**2. Auto-generated from will_paginate collection:**

```erb
<%# Works with will_paginate collections %>
<%= render Shadcn::PaginationComponent.new(collection: @users) %>
```

**3. Auto-generated from Pagy object:**

```erb
<%# Works with Pagy pagination objects %>
<%= render Shadcn::PaginationComponent.new(pagy: @pagy) %>
```

**4. Custom URL builder:**

```erb
<%# Use a custom URL builder for complex routes %>
<%= render Shadcn::PaginationComponent.new(
  collection: @posts,
  url_builder: ->(page) { posts_path(page: page, sort: params[:sort]) }
) %>
```

**5. Full slot-based control:**

```erb
<%= render Shadcn::PaginationComponent.new do |pagination| %>
  <% pagination.with_pagination_content do |content| %>
    <% content.with_previous(href: "?page=1") %>
    <% content.with_item(href: "?page=1") { "1" } %>
    <% content.with_item(href: "?page=2", active: true) { "2" } %>
    <% content.with_item(href: "?page=3") { "3" } %>
    <% content.with_ellipse %>
    <% content.with_item(href: "?page=10") { "10" } %>
    <% content.with_next_page(href: "?page=3") %>
  <% end %>
<% end %>
```

**6. Using the `shadcn_paginate` helper:**

```erb
<%# Simple one-liner that auto-detects your pagination gem %>
<%= shadcn_paginate @posts %>

<%# With Pagy %>
<%= shadcn_paginate @pagy %>

<%# Custom URL builder and window size %>
<%= shadcn_paginate @posts,
    url_builder: ->(page) { posts_path(page: page) },
    window: 3 %>
```

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `collection` | Object | `nil` | Kaminari or will_paginate collection |
| `pagy` | Object | `nil` | Pagy pagination object |
| `url_builder` | Proc | `"?page=N"` | Lambda to generate page URLs |
| `window` | Integer | `2` | Pages to show around current page |

**Supported Pagination Gems:**

| Gem | Usage |
|-----|-------|
| [Kaminari](https://github.com/kaminari/kaminari) | `collection: @posts.page(1).per(10)` |
| [will_paginate](https://github.com/mislav/will_paginate) | `collection: @posts.paginate(page: 1)` |
| [Pagy](https://github.com/ddnexus/pagy) | `pagy: @pagy` (from `pagy(@posts)`) |

#### Collapsible

An interactive component which expands/collapses a panel.

```erb
<%= render Shadcn::CollapsibleComponent.new do |collapsible| %>
  <% collapsible.with_trigger do %>
    <div class="flex items-center justify-between px-4 py-2 border rounded-md">
      <span>Click to expand</span>
      <svg><!-- chevron icon --></svg>
    </div>
  <% end %>
  <% collapsible.with_content do %>
    <div class="mt-2 p-4 border rounded-md">
      Collapsible content here
    </div>
  <% end %>
<% end %>
```

### Layout

#### Separator

Visually or semantically separates content.

```erb
<%# Horizontal separator %>
<%= render Shadcn::SeparatorComponent.new %>

<%# Vertical separator %>
<div class="flex h-5 items-center space-x-4">
  <span>Blog</span>
  <%= render Shadcn::SeparatorComponent.new(orientation: :vertical) %>
  <span>Docs</span>
</div>
```

#### Scroll Area

Augments native scroll functionality for custom, cross-browser styling.

```erb
<%= render Shadcn::ScrollAreaComponent.new(class_name: "h-[200px] w-[350px] rounded-md border p-4") do %>
  <div class="space-y-4">
    <% 20.times do |i| %>
      <div>Item <%= i + 1 %></div>
    <% end %>
  </div>
<% end %>
```

## Theming

### Available Themes

shadcn-rails includes 5 built-in color themes:

| Theme | Description |
|-------|-------------|
| `neutral` | Clean grayscale palette (default) |
| `slate` | Cool blue-gray tones |
| `stone` | Warm brown-gray tones |
| `gray` | Standard gray palette |
| `zinc` | Cool gray with slight purple tint |

### Switching Themes

```ruby
# config/initializers/shadcn.rb
Shadcn::Rails.configure do |config|
  config.base_color = "slate"  # neutral, slate, stone, gray, zinc
end
```

Or use the generator:

```bash
rails generate shadcn:theme slate
```

### CSS Variables

shadcn-rails uses CSS variables for theming, matching the shadcn/ui approach:

```css
:root {
  --background: 0 0% 100%;
  --foreground: 0 0% 3.9%;
  --card: 0 0% 100%;
  --card-foreground: 0 0% 3.9%;
  --popover: 0 0% 100%;
  --popover-foreground: 0 0% 3.9%;
  --primary: 0 0% 9%;
  --primary-foreground: 0 0% 98%;
  --secondary: 0 0% 96.1%;
  --secondary-foreground: 0 0% 9%;
  --muted: 0 0% 96.1%;
  --muted-foreground: 0 0% 45.1%;
  --accent: 0 0% 96.1%;
  --accent-foreground: 0 0% 9%;
  --destructive: 0 84.2% 60.2%;
  --destructive-foreground: 0 0% 98%;
  --border: 0 0% 89.8%;
  --input: 0 0% 89.8%;
  --ring: 0 0% 3.9%;
  --radius: 0.5rem;
}

.dark {
  --background: 0 0% 3.9%;
  --foreground: 0 0% 98%;
  /* ... dark mode overrides */
}
```

### Custom Themes

Register custom themes in your initializer:

```ruby
Shadcn::Rails.configure do |config|
  config.register_theme(:brand, {
    primary: "220 90% 56%",
    primary_foreground: "0 0% 100%",
    # ... other variables
  })
end
```

## Dark Mode

### Class Strategy (Recommended)

Add the `dark` class to your `<html>` element:

```html
<html class="dark">
```

Toggle with JavaScript:

```javascript
// Toggle dark mode
document.documentElement.classList.toggle('dark')

// Check system preference
if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
  document.documentElement.classList.add('dark')
}
```

### Media Strategy

Use the system preference automatically:

```ruby
Shadcn::Rails.configure do |config|
  config.dark_mode = :media
end
```

## Configuration

Full configuration options:

```ruby
# config/initializers/shadcn.rb
Shadcn::Rails.configure do |config|
  # Base color theme: neutral, stone, zinc, gray, slate
  config.base_color = "neutral"

  # Use CSS variables for theming
  config.css_variables = true

  # Dark mode strategy: :class, :media, or :selector
  config.dark_mode = :class

  # Default border radius
  config.radius = "0.5rem"

  # Tailwind class prefix (if using one)
  config.tailwind_prefix = ""

  # Icon library: :lucide (default), :heroicons
  config.icon_library = :lucide
end
```

## Stimulus Controllers

Interactive components require Stimulus controllers. Setup depends on your JavaScript bundler.

### Importmap-rails (Rails Default)

Add to your `config/importmap.rb`:

```ruby
pin "shadcn-rails", to: "shadcn/index.js"
```

Then in `app/javascript/controllers/index.js`:

```javascript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails"

const application = Application.start()
registerShadcnControllers(application)
```

### esbuild

Install the npm package:

```bash
npm install shadcn-rails
# or
yarn add shadcn-rails
```

Then in `app/javascript/controllers/index.js`:

```javascript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails"

const application = Application.start()
registerShadcnControllers(application)
```

### Webpack

Install the npm package:

```bash
npm install shadcn-rails
# or
yarn add shadcn-rails
```

In `app/javascript/controllers/index.js`:

```javascript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails"

const application = Application.start()
registerShadcnControllers(application)
```

### Vite (vite-ruby)

Install the npm package:

```bash
npm install shadcn-rails
# or
yarn add shadcn-rails
```

In your entrypoint (e.g., `app/frontend/entrypoints/application.js`):

```javascript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails"

const application = Application.start()
registerShadcnControllers(application)
```

### Registering Individual Controllers

If you prefer to only load specific controllers (tree-shaking):

```javascript
import { Application } from "@hotwired/stimulus"
import DialogController from "shadcn-rails/controllers/dialog_controller"
import TabsController from "shadcn-rails/controllers/tabs_controller"

const application = Application.start()
application.register("shadcn--dialog", DialogController)
application.register("shadcn--tabs", TabsController)
```

### Available Controllers

| Controller | Components |
|------------|------------|
| `shadcn--accordion` | Accordion |
| `shadcn--alert-dialog` | AlertDialog |
| `shadcn--avatar` | Avatar |
| `shadcn--checkbox` | Checkbox |
| `shadcn--collapsible` | Collapsible |
| `shadcn--context-menu` | ContextMenu |
| `shadcn--dialog` | Dialog |
| `shadcn--drawer` | Drawer |
| `shadcn--dropdown-menu` | DropdownMenu |
| `shadcn--hover-card` | HoverCard |
| `shadcn--input-otp` | InputOtp |
| `shadcn--menubar` | Menubar |
| `shadcn--navigation-menu` | NavigationMenu |
| `shadcn--popover` | Popover |
| `shadcn--radio-group` | RadioGroup |
| `shadcn--resizable` | Resizable |
| `shadcn--scroll-area` | ScrollArea |
| `shadcn--select` | Select |
| `shadcn--sheet` | Sheet |
| `shadcn--slider` | Slider |
| `shadcn--switch` | Switch |
| `shadcn--tabs` | Tabs |
| `shadcn--toast` | Toast |
| `shadcn--toggle` | Toggle |
| `shadcn--toggle-group` | ToggleGroup |
| `shadcn--tooltip` | Tooltip |

### TypeScript Support

shadcn-rails includes comprehensive TypeScript type definitions (`.d.ts` files) for all 20 Stimulus controllers. Types are provided without requiring TypeScript compilation - your JavaScript remains the source of truth.

**Using Types in TypeScript Projects:**

```typescript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails"

// Full IDE autocomplete and type checking
const application = Application.start()
registerShadcnControllers(application)
```

**Importing Individual Controllers with Types:**

```typescript
import DialogController from "shadcn-rails/controllers/dialog_controller"
import TabsController from "shadcn-rails/controllers/tabs_controller"

// Full type information available
const dialog = new DialogController()
dialog.open()  // ✓ TypeScript knows this method exists
dialog.openValue  // ✓ Type: boolean
```

**Available Type Definitions:**

Each controller includes typed definitions for:
- Static `targets` and `values` declarations
- Target accessors (`*Target`, `*Targets`, `has*Target`)
- Value accessors (`*Value`, `has*Value`)
- All public methods
- Custom properties and getters

**Example Type Definition (DialogController):**

```typescript
import { Controller } from "@hotwired/stimulus"

export default class DialogController extends Controller {
  static targets: ["trigger", "template", "overlay", "content"]
  static values: {
    open: { type: "Boolean"; default: false }
    modal: { type: "Boolean"; default: true }
  }

  // Target accessors
  readonly triggerTarget: HTMLElement
  readonly hasTemplateTarget: boolean

  // Value accessors
  openValue: boolean
  modalValue: boolean

  // Methods
  open(): void
  close(): void
  toggle(): void
}
```

**For Importmap Users:**

If using TypeScript with importmaps, add a type declaration file at `types/shadcn-rails.d.ts`:

```typescript
declare module "shadcn-rails" {
  import { Application } from "@hotwired/stimulus"
  export function registerShadcnControllers(application: Application): void
  export const controllers: Record<string, typeof import("@hotwired/stimulus").Controller>
}
```

## Helper Methods

shadcn-rails provides helper methods for your views:

```erb
<%# Class name merging (like cn() in shadcn/ui) %>
<div class="<%= Shadcn::Rails.cn("base-class", conditional && "conditional-class", @class_name) %>">
```

## Testing

Run the full test suite:

```bash
bundle exec rake test
```

Run component tests only:

```bash
bundle exec rake test_components
```

## Development

After checking out the repo:

```bash
bundle install
cd test/dummy
rails server
```

Visit `http://localhost:3000` to see the demo app with:
- `/docs` - Full documentation with examples
- `/showcase` - Full component showcase
- `/themes` - Theme preview and comparison
- `/lookbook` - Component previews with Lookbook

### Deploying the Documentation Site

The documentation site in `test/dummy/` can be deployed as a standalone Rails application. Recommended platforms:

**Render (Free tier available)**
```bash
# In test/dummy/ directory
render.yaml # Already configured for deployment
```

**Railway**
```bash
cd test/dummy
railway init
railway up
```

**Fly.io**
```bash
cd test/dummy
fly launch
fly deploy
```

**Heroku**
```bash
cd test/dummy
heroku create your-shadcn-rails-docs
git subtree push --prefix test/dummy heroku main
```

## Security Considerations

shadcn-rails follows Rails security best practices. Here are important security guidelines:

### CSRF Protection

Always use Rails form helpers to automatically include CSRF tokens:

```erb
<%= form_with url: "/submit" do |f| %>
  <%= render Shadcn::InputComponent.new(name: "email") %>
  <%= render Shadcn::ButtonComponent.new(type: "submit") { "Submit" } %>
<% end %>
```

### XSS Prevention

ViewComponent auto-escapes all content by default. Never call `html_safe` on user-provided content:

```erb
<%# SAFE - auto-escaped %>
<%= render Shadcn::BadgeComponent.new { user.name } %>

<%# DANGEROUS - never do this with user input! %>
<%= render Shadcn::BadgeComponent.new { user.name.html_safe } %>
```

### Input Validation

Form components (Input, Textarea, Select) pass through values without validation. Always implement:

- Server-side input validation
- Strong parameters in controllers
- Model validations

```ruby
# In your controller
def user_params
  params.require(:user).permit(:name, :email)
end

# In your model
validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
```

### Content Security Policy

If using CSP headers, ensure your policy allows inline styles for theming:

```ruby
# config/initializers/content_security_policy.rb
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.style_src :self, :unsafe_inline  # Required for CSS variables
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iheanyi/shadcn-rails.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

- [shadcn/ui](https://ui.shadcn.com) - The original React component library
- [ViewComponent](https://viewcomponent.org) - Ruby component framework
- [Stimulus](https://stimulus.hotwired.dev) - JavaScript framework
- [Tailwind CSS](https://tailwindcss.com) - Utility-first CSS framework
