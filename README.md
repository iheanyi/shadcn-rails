# shadcn-rails

Beautiful, accessible UI components for Rails built with ViewComponents, Stimulus, and Tailwind CSS. A Ruby port of [shadcn/ui](https://ui.shadcn.com).

[![CI](https://github.com/iheanyi/shadcn-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/iheanyi/shadcn-rails/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/shadcn-rails.svg)](https://rubygems.org/gems/shadcn-rails)
[![npm version](https://badge.fury.io/js/shadcn-rails-stimulus.svg)](https://www.npmjs.com/package/shadcn-rails-stimulus)

## Features

- **47 Components** - Buttons, forms, dialogs, menus, and more
- **Accessible** - Built with WAI-ARIA patterns
- **Dark Mode** - Built-in light/dark theme support
- **Customizable** - CSS variables for easy theming
- **Rails-first** - ViewComponents + Stimulus + Tailwind CSS

## Installation

### Ruby Gem

```bash
bundle add shadcn-rails
rails generate shadcn:install
```

### Stimulus Controllers (npm)

```bash
npm install shadcn-rails-stimulus
# or
yarn add shadcn-rails-stimulus
```

Then register the controllers:

```javascript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails-stimulus"

const application = Application.start()
registerShadcnControllers(application)
```

## Adding Components

Copy components into your app for customization:

```bash
# List all available components
rails generate shadcn:add --list

# Add specific components
rails generate shadcn:add button dialog tabs

# Add all components
rails generate shadcn:add --all

# Add without Stimulus controllers
rails generate shadcn:add dialog --exclude-controllers
```

Components are copied to `app/components/shadcn/` and controllers to `app/javascript/controllers/shadcn/`. Local files take precedence over the gem's built-in components.

## Quick Start

```erb
<%# Button %>
<%= render Shadcn::ButtonComponent.new(variant: :default) { "Click me" } %>

<%# Card %>
<%= render Shadcn::CardComponent.new do |card| %>
  <% card.with_header do |header| %>
    <% header.with_title { "Welcome" } %>
  <% end %>
  <% card.with_content_slot do %>
    <p>Your content here</p>
  <% end %>
<% end %>

<%# Dialog %>
<%= render Shadcn::DialogComponent.new do |dialog| %>
  <% dialog.with_trigger do %>
    <%= render Shadcn::ButtonComponent.new { "Open" } %>
  <% end %>
  <% dialog.with_body do |body| %>
    <% body.with_header do |header| %>
      <% header.with_title { "Edit Profile" } %>
    <% end %>
    <p>Dialog content here</p>
  <% end %>
<% end %>
```

## Components

| Category | Components |
|----------|------------|
| **Actions** | Button, Toggle, Toggle Group |
| **Forms** | Input, Textarea, Label, Checkbox, Switch, Radio Group, Select, Slider |
| **Data Display** | Badge, Avatar, Card, Table, Progress, Skeleton, Aspect Ratio |
| **Feedback** | Alert, Tooltip, Toast |
| **Overlays** | Dialog, Alert Dialog, Sheet, Drawer, Popover, Hover Card, Dropdown Menu, Context Menu |
| **Navigation** | Tabs, Accordion, Breadcrumb, Pagination, Collapsible, Navigation Menu, Menubar |
| **Layout** | Separator, Scroll Area, Resizable |

## Theming

### CSS Variables

shadcn-rails uses CSS custom properties for theming. Override any variable to customize:

```css
:root {
  --radius: 0.75rem;           /* Larger corners */
  --primary: 221.2 83.2% 53.3%; /* Blue primary (HSL without hsl()) */
  --destructive: 0 84% 60%;    /* Custom red */
}

.dark {
  --primary: 217.2 91.2% 59.8%; /* Lighter blue for dark mode */
}
```

Key variables:
- `--radius` - Base border radius (all `rounded-*` classes derive from this)
- `--primary`, `--secondary`, `--accent`, `--destructive` - Semantic colors
- `--background`, `--foreground` - Base page colors
- `--muted`, `--card`, `--popover` - Surface colors

### Tailwind CSS v4

For Tailwind CSS v4, import the theme file to map CSS variables to utility classes:

```css
@import "tailwindcss";
@import "shadcn/base";
@import "shadcn/tailwind-v4";
```

This enables:
- `rounded-sm` through `rounded-3xl` derived from `--radius`
- Color classes (`bg-primary`, `text-muted-foreground`) using theme variables
- Hot-reloadable theme changes without rebuilding CSS

### Initializer Configuration

Configure base colors in your initializer:

```ruby
# config/initializers/shadcn.rb
Shadcn::Rails.configure do |config|
  config.base_color = "slate"  # neutral, slate, stone, gray, zinc
  config.dark_mode = :class    # :class, :media, :both
end
```

## Stimulus Controllers

All interactive components have corresponding Stimulus controllers:

| Controller | Components |
|------------|------------|
| `shadcn--dialog` | Dialog |
| `shadcn--sheet` | Sheet |
| `shadcn--tabs` | Tabs |
| `shadcn--accordion` | Accordion |
| `shadcn--popover` | Popover |
| `shadcn--dropdown-menu` | DropdownMenu |
| `shadcn--select` | Select |
| `shadcn--switch` | Switch |
| `shadcn--slider` | Slider |
| `shadcn--tooltip` | Tooltip |
| `shadcn--toast` | Toast |

Register individual controllers for tree-shaking:

```javascript
import DialogController from "shadcn-rails-stimulus/controllers/dialog_controller"
application.register("shadcn--dialog", DialogController)
```

## TypeScript Support

Full TypeScript definitions included for all controllers:

```typescript
import { registerShadcnControllers } from "shadcn-rails-stimulus"
import DialogController from "shadcn-rails-stimulus/controllers/dialog_controller"

// Full autocomplete and type checking
const dialog = new DialogController()
dialog.open()      // Methods are typed
dialog.openValue   // Values are typed (boolean)
```

## Requirements

- Ruby >= 3.1
- Rails >= 7.0
- Tailwind CSS >= 3.0
- Stimulus >= 3.0
- ViewComponent >= 3.0

## Development

```bash
bundle install
cd test/dummy && rails server
```

Visit http://localhost:3000/docs for the component documentation.

## Contributing

Bug reports and pull requests are welcome at https://github.com/iheanyi/shadcn-rails.

## License

MIT License - see [LICENSE](LICENSE) for details.

## Credits

- [shadcn/ui](https://ui.shadcn.com) - Original React component library
- [ViewComponent](https://viewcomponent.org) - Ruby component framework
- [Stimulus](https://stimulus.hotwired.dev) - JavaScript framework
- [Tailwind CSS](https://tailwindcss.com) - Utility-first CSS
