# shadcn-rails

Beautiful, accessible UI components for Rails built with ViewComponents, Stimulus, and Tailwind CSS. A Ruby port of [shadcn/ui](https://ui.shadcn.com).

## Features

- 🎨 **Beautiful by default** - Carefully crafted components that look great out of the box
- ♿ **Accessible** - Built with accessibility in mind, following WAI-ARIA patterns
- 🔧 **Customizable** - Use CSS variables to customize the look and feel
- 🌙 **Dark mode** - Built-in dark mode support
- 📦 **ViewComponents** - Leverages Rails' ViewComponent library for composable, testable components
- ⚡ **Stimulus** - Interactive components powered by Stimulus controllers
- 🎯 **Rails-first** - Designed specifically for Ruby on Rails applications

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
1. Create a configuration initializer
2. Add the required CSS imports
3. Configure your Stimulus controllers

## Requirements

- Ruby >= 3.1
- Rails >= 7.0
- Tailwind CSS
- Stimulus

## Usage

### Basic Components

```erb
<%# Button %>
<%= render Shadcn::ButtonComponent.new(variant: :primary) do %>
  Click me
<% end %>

<%# Button variants %>
<%= render Shadcn::ButtonComponent.new(variant: :destructive) { "Delete" } %>
<%= render Shadcn::ButtonComponent.new(variant: :outline) { "Outline" } %>
<%= render Shadcn::ButtonComponent.new(variant: :secondary) { "Secondary" } %>
<%= render Shadcn::ButtonComponent.new(variant: :ghost) { "Ghost" } %>
<%= render Shadcn::ButtonComponent.new(variant: :link) { "Link" } %>

<%# Input with Label %>
<%= render Shadcn::LabelComponent.new(for: "email") { "Email" } %>
<%= render Shadcn::InputComponent.new(
  type: "email",
  id: "email",
  name: "email",
  placeholder: "you@example.com"
) %>

<%# Card %>
<%= render Shadcn::CardComponent.new do |card| %>
  <% card.with_header do |header| %>
    <% header.with_title { "Card Title" } %>
    <% header.with_description { "Card description" } %>
  <% end %>
  <% card.with_content_slot do %>
    Your content here
  <% end %>
  <% card.with_footer do %>
    <%= render Shadcn::ButtonComponent.new { "Action" } %>
  <% end %>
<% end %>

<%# Badge %>
<%= render Shadcn::BadgeComponent.new { "New" } %>
<%= render Shadcn::BadgeComponent.new(variant: :secondary) { "Draft" } %>
<%= render Shadcn::BadgeComponent.new(variant: :destructive) { "Error" } %>

<%# Alert %>
<%= render Shadcn::AlertComponent.new do |alert| %>
  <% alert.with_title { "Heads up!" } %>
  <% alert.with_description { "Important information here." } %>
<% end %>
```

### Interactive Components

```erb
<%# Dialog %>
<%= render Shadcn::DialogComponent.new do |dialog| %>
  <% dialog.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new { "Open Dialog" } %>
  <% end %>
  <% dialog.with_content do |content| %>
    <% content.with_header do |header| %>
      <% header.with_title { "Dialog Title" } %>
      <% header.with_description { "Dialog description" } %>
    <% end %>
    <p>Dialog content here</p>
    <% content.with_footer do %>
      <%= render Shadcn::ButtonComponent.new { "Save" } %>
    <% end %>
  <% end %>
<% end %>

<%# Tabs %>
<%= render Shadcn::TabsComponent.new(default_value: "account") do |tabs| %>
  <% tabs.with_list do |list| %>
    <% list.with_trigger(value: "account") { "Account" } %>
    <% list.with_trigger(value: "password") { "Password" } %>
  <% end %>
  <% tabs.with_content(value: "account") do %>
    Account settings here
  <% end %>
  <% tabs.with_content(value: "password") do %>
    Password settings here
  <% end %>
<% end %>

<%# Accordion %>
<%= render Shadcn::AccordionComponent.new(type: :single, collapsible: true) do |accordion| %>
  <% accordion.with_item(value: "item-1") do |item| %>
    <% item.with_trigger { "Is it accessible?" } %>
    <% item.with_content { "Yes. It follows WAI-ARIA patterns." } %>
  <% end %>
<% end %>

<%# Dropdown Menu %>
<%= render Shadcn::DropdownMenuComponent.new do |menu| %>
  <% menu.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Menu" } %>
  <% end %>
  <% menu.with_content do |content| %>
    <% content.with_label { "My Account" } %>
    <% content.with_separator %>
    <% content.with_item(href: "/profile") { "Profile" } %>
    <% content.with_item(href: "/settings") { "Settings" } %>
  <% end %>
<% end %>

<%# Tooltip %>
<%= render Shadcn::TooltipComponent.new(content: "Add to library") do %>
  <%= render Shadcn::ButtonComponent.new(variant: :outline, size: :icon) { "+" } %>
<% end %>
```

## Available Components

### Layout & Structure
- **Card** - Container with header, content, and footer
- **Separator** - Visual divider between content
- **Table** - Responsive data tables
- **ScrollArea** - Custom scrollbar styling

### Forms & Input
- **Button** - Multiple variants and sizes
- **Input** - Text input fields
- **Textarea** - Multi-line text input
- **Label** - Form field labels
- **Checkbox** - Boolean input
- **Switch** - Toggle switch
- **Select** - Dropdown selection

### Feedback & Display
- **Badge** - Labels and status indicators
- **Alert** - Important messages
- **Progress** - Progress indicators
- **Skeleton** - Loading placeholders
- **Avatar** - User profile images
- **Tooltip** - Contextual information

### Overlays & Dialogs
- **Dialog** - Modal dialogs
- **Sheet** - Slide-out panels
- **Popover** - Rich content overlays
- **DropdownMenu** - Action menus

### Navigation
- **Tabs** - Tabbed interfaces
- **Accordion** - Collapsible sections
- **Collapsible** - Expandable content

### Notifications
- **Toast** - Temporary notifications

## Configuration

Configure shadcn-rails in `config/initializers/shadcn.rb`:

```ruby
Shadcn::Rails.configure do |config|
  # Base color theme: neutral, stone, zinc, gray, slate
  config.base_color = "neutral"

  # Use CSS variables for theming
  config.css_variables = true

  # Dark mode strategy: :class, :media, or :selector
  config.dark_mode = :class

  # Default border radius
  config.radius = "0.5rem"
end
```

## Theming

### CSS Variables

shadcn-rails uses CSS variables for theming, matching the shadcn/ui approach:

```css
:root {
  --background: 0 0% 100%;
  --foreground: 0 0% 3.9%;
  --primary: 0 0% 9%;
  --primary-foreground: 0 0% 98%;
  /* ... */
}

.dark {
  --background: 0 0% 3.9%;
  --foreground: 0 0% 98%;
  /* ... */
}
```

### Color Themes

Available themes: `neutral`, `slate`, `stone`, `zinc`, `gray`

Switch themes with the generator:

```bash
rails generate shadcn:theme slate
```

### Dark Mode

Enable dark mode by adding the `dark` class to your HTML element:

```html
<html class="dark">
```

Or use JavaScript to toggle based on user preference:

```javascript
// Check system preference
if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
  document.documentElement.classList.add('dark')
}
```

## Stimulus Controllers

Interactive components use Stimulus controllers. Register them in your application:

```javascript
// With importmaps
import { registerShadcnControllers } from "shadcn"
registerShadcnControllers(application)

// Or register individually
import DialogController from "shadcn/controllers/dialog_controller"
application.register("shadcn--dialog", DialogController)
```

## Helper Methods

shadcn-rails provides helper methods for your views:

```erb
<%# Class name merging (like cn() in shadcn/ui) %>
<div class="<%= cn("base-class", conditional && "conditional-class", class_name) %>">

<%# Shorthand component helpers %>
<%= shadcn_button(variant: :primary) { "Click" } %>
<%= shadcn_input(type: "email", placeholder: "Email") %>
<%= shadcn_card { "Content" } %>
```

## Testing

Run the test suite:

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

Visit `http://localhost:3000` to see the demo app.

For component previews with Lookbook:

```bash
cd test/dummy
rails lookbook:preview
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iheanyi/shadcn-rails.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

- [shadcn/ui](https://ui.shadcn.com) - The original React component library
- [ViewComponent](https://viewcomponent.org) - Ruby component framework
- [Stimulus](https://stimulus.hotwired.dev) - JavaScript framework
- [Tailwind CSS](https://tailwindcss.com) - Utility-first CSS framework
