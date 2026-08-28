# shadcn-rails

Rails components inspired by [shadcn/ui](https://ui.shadcn.com), implemented with
[ViewComponent](https://viewcomponent.org), [Stimulus](https://stimulus.hotwired.dev),
Hotwire-friendly server-rendered markup, and Tailwind CSS.

[![CI](https://github.com/iheanyi/shadcn-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/iheanyi/shadcn-rails/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/shadcn-rails.svg)](https://rubygems.org/gems/shadcn-rails)
[![npm version](https://badge.fury.io/js/shadcn-rails-stimulus.svg)](https://www.npmjs.com/package/shadcn-rails-stimulus)

## What this is

- A Ruby gem, `shadcn-rails`, that ships ViewComponent components for Rails apps.
- An npm package, `shadcn-rails-stimulus`, that ships the matching Stimulus controllers and CSS assets.
- 55 documented component families, including buttons, forms, dialogs, menus, command, empty states, items, sidebar, and resizable panels.
- A Rails generator that can copy component source into your app so local files take precedence over the gem.

This is not a React component library and does not aim for full parity with upstream
shadcn/ui. It is a Rails/ViewComponent port for server-rendered Rails applications.

## If you use Inertia or React

Use the official shadcn/ui tooling instead:

```bash
npx shadcn init
npx shadcn add button dialog
```

For Rails + Inertia apps, start with `inertia_rails` and follow the official
Inertia Rails cookbook for integrating shadcn/ui. This gem does not add Inertia
or React support.

## Name disambiguation

This repository is `iheanyi/shadcn-rails` and publishes the `shadcn-rails` Ruby
gem plus the `shadcn-rails-stimulus` npm package. It is unrelated to the
`aviflombaum/shadcn-rails` GitHub repository and the `shadcn-ui` Ruby gem.

## Installation

Add the gem and run the installer:

```bash
bundle add shadcn-rails
rails generate shadcn:install
```

For importmap apps, the installer pins the local `shadcn` entrypoint plus its
external dependencies (`@floating-ui/dom` and `stimulus-use`) in
`config/importmap.rb`.

If your app bundles JavaScript or CSS through npm, add the Stimulus package:

```bash
npm install shadcn-rails-stimulus
# or
yarn add shadcn-rails-stimulus
```

Then register all controllers:

```javascript
import { Application } from "@hotwired/stimulus"
import { registerShadcnControllers } from "shadcn-rails-stimulus"

const application = Application.start()
registerShadcnControllers(application)
```

You can also register individual controllers:

```javascript
import DialogController from "shadcn-rails-stimulus/controllers/dialog_controller"

application.register("shadcn--dialog", DialogController)
```

## Adding components to your app

The gem ships components that can be rendered directly. When you want to own and
customize the source, copy component units into your application:

```bash
# List available components
rails generate shadcn:add --list

# Add specific components
rails generate shadcn:add button dialog tabs

# Hyphenated names are accepted too
rails generate shadcn:add dropdown-menu radio-group

# Add all available components
rails generate shadcn:add --all

# Add Ruby components without Stimulus controllers
rails generate shadcn:add dialog --exclude-controllers
```

Components are copied to `app/components/shadcn/`. Stimulus controllers are
copied to `app/javascript/controllers/shadcn/`. Compound components copy their
full unit, including subcomponent Ruby files, sidecar templates, controller
dependencies, and local JavaScript utilities needed by the copied controllers.
For example, `rails generate shadcn:add dialog` copies
`dialog_component.rb`, `dialog_content_component.rb`, `dialog_header_component.rb`,
`dialog_title_component.rb`, and the rest of the dialog unit.

Rails autoloading will prefer the local files in your application over the gem's
built-in components.

## Quick start

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
| **Actions** | Button, Button Group, Toggle, Toggle Group |
| **Forms** | Checkbox, Field, Input, Input Group, Input OTP, Label, Native Select, Radio Group, Select, Slider, Switch, Textarea |
| **Data Display** | Aspect Ratio, Avatar, Badge, Card, Empty, Item, Kbd, Progress, Skeleton, Spinner, Table, Typography |
| **Feedback** | Alert, Toast, Tooltip |
| **Overlays** | Alert Dialog, Dialog, Drawer, Dropdown Menu, Hover Card, Popover, Sheet, Context Menu |
| **Navigation** | Accordion, Breadcrumb, Collapsible, Menubar, Navigation Menu, Pagination, Separator, Tabs, Resizable |
| **Advanced** | Calendar, Carousel, Combobox, Command, Date Picker, Sidebar |

## Theming

shadcn-rails uses CSS custom properties for theming. Values use the HSL triplet
format used by earlier shadcn/ui themes:

```css
:root {
  --radius: 0.75rem;
  --primary: 221.2 83.2% 53.3%;
  --destructive: 0 84% 60%;
}

.dark {
  --primary: 217.2 91.2% 59.8%;
}
```

Configure base colors in your initializer:

```ruby
# config/initializers/shadcn.rb
Shadcn::Rails.configure do |config|
  config.base_color = "slate"  # neutral, slate, stone, gray, zinc
  config.dark_mode = :class    # :class, :media, :both
end
```

For Tailwind CSS v4, import the theme bridge:

```css
@import "tailwindcss";
@import "shadcn/base";
@import "shadcn/components";
@import "shadcn/tailwind-v4";
```

Rails 8 with Tailwind CSS v4 is the supported install path. `rails generate
shadcn:install` adds these imports to `app/assets/tailwind/application.css`.
The installer still keeps a Tailwind v3 injection path for existing Rails apps
that use `app/assets/stylesheets/application.tailwind.css`.

With npm-based CSS bundling, import from the npm package:

```css
@import "shadcn-rails-stimulus/styles/base";
@import "shadcn-rails-stimulus/styles/components";
@import "shadcn-rails-stimulus/styles/tailwind-v4";
```

## Requirements

- Ruby >= 3.1
- Rails >= 7.0
- Tailwind CSS v4 for the supported Rails 8 install path; v3 remains an
  installer fallback for existing apps
- Stimulus >= 3.0
- ViewComponent >= 3.0

## Development

```bash
bundle install
cd test/dummy && bin/dev
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
