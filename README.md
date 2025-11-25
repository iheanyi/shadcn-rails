# shadcn-rails

Beautiful, accessible UI components for Rails applications. Inspired by [shadcn/ui](https://ui.shadcn.com/), this gem provides ViewComponent-based components styled with Tailwind CSS.

## Features

- 🎨 **Beautiful Components** - Pre-styled with Tailwind CSS following shadcn/ui design
- ♿ **Accessible** - Built with accessibility in mind
- 🧩 **Copy-Paste Architecture** - Components are copied to your project for full customization
- 🚀 **Rails Native** - Uses ViewComponent for optimal Rails integration
- ⚡ **Stimulus Ready** - Interactive components include Stimulus controllers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shadcn-rails'
gem 'view_component', '>= 3.0'
gem 'tailwind_merge' # Optional but recommended for class merging
```

And then execute:

```bash
bundle install
```

## Setup

Run the install generator to set up your application:

```bash
rails generate shadcn:install
```

This will:
- Create the components directory (`app/components/ui`)
- Set up base component classes
- Configure Tailwind CSS with shadcn variables
- Add helper methods to your application

## Adding Components

Install individual components using the component generator:

```bash
# Install single component
rails generate shadcn:component button

# Install multiple components
rails generate shadcn:component button card input badge

# List all available components
rails generate shadcn:component --list
```

### Available Components

| Component | Description |
|-----------|-------------|
| `button` | Clickable button with multiple variants and sizes |
| `card` | Container with header, content, and footer slots |
| `input` | Text input field with styling and states |
| `textarea` | Multi-line text input |
| `select` | Dropdown select input |
| `checkbox` | Checkbox input with custom styling |
| `switch` | Toggle switch input |
| `label` | Form label with required indicator |
| `badge` | Small status indicator with variants |
| `alert` | Attention-grabbing message with icon support |
| `dialog` | Modal dialog/popup window |
| `dropdown_menu` | Dropdown menu with items and separators |
| `avatar` | User avatar with image and fallback support |
| `tabs` | Tabbed content navigation |
| `tooltip` | Hover tooltip with positioning |
| `separator` | Horizontal or vertical separator line |
| `skeleton` | Loading placeholder animation |
| `spinner` | Loading spinner indicator |
| `progress` | Progress bar indicator |

## Usage

### Basic Component Usage

```erb
<%# Button %>
<%= render Ui::ButtonComponent.new(variant: :default, size: :default) do %>
  Click me
<% end %>

<%# Card with slots %>
<%= render Ui::CardComponent.new do |card| %>
  <% card.with_header do %>
    <% card.with_title { "Card Title" } %>
    <% card.with_description { "Card description text" } %>
  <% end %>
  <% card.with_content do %>
    Card content goes here
  <% end %>
  <% card.with_footer do %>
    <button>Action</button>
  <% end %>
<% end %>

<%# Input %>
<%= render Ui::InputComponent.new(
  type: "email",
  name: "user[email]",
  placeholder: "Enter your email"
) %>

<%# Badge %>
<%= render Ui::BadgeComponent.new(variant: :secondary) do %>
  New
<% end %>
```

### Using Helper Methods

```erb
<%# Using the shadcn helper %>
<%= shadcn(:button, variant: :primary) { "Submit" } %>

<%# Using tag helpers %>
<%= shadcn_button "Click me", variant: :outline %>
<%= shadcn_input name: "email", type: "email" %>
<%= shadcn_badge "Status", variant: :secondary %>
<%= shadcn_spinner size: :lg %>
```

### Form Builder Integration

```erb
<%= form_with model: @user, builder: Shadcn::Rails::FormBuilder do |f| %>
  <%= f.shadcn_label :name %>
  <%= f.shadcn_text_field :name, placeholder: "Enter your name" %>

  <%= f.shadcn_label :email %>
  <%= f.shadcn_email_field :email, placeholder: "Enter your email" %>

  <%= f.shadcn_label :bio %>
  <%= f.shadcn_text_area :bio, rows: 4 %>

  <%= f.shadcn_check_box :terms %>
  <%= f.shadcn_label :terms, "I agree to the terms" %>

  <%= f.shadcn_submit "Create Account", variant: :default %>
<% end %>
```

### Button Variants

```erb
<%= render Ui::ButtonComponent.new(variant: :default) { "Default" } %>
<%= render Ui::ButtonComponent.new(variant: :destructive) { "Destructive" } %>
<%= render Ui::ButtonComponent.new(variant: :outline) { "Outline" } %>
<%= render Ui::ButtonComponent.new(variant: :secondary) { "Secondary" } %>
<%= render Ui::ButtonComponent.new(variant: :ghost) { "Ghost" } %>
<%= render Ui::ButtonComponent.new(variant: :link) { "Link" } %>
```

### Button Sizes

```erb
<%= render Ui::ButtonComponent.new(size: :sm) { "Small" } %>
<%= render Ui::ButtonComponent.new(size: :default) { "Default" } %>
<%= render Ui::ButtonComponent.new(size: :lg) { "Large" } %>
<%= render Ui::ButtonComponent.new(size: :icon) { "🔔" } %>
```

## JavaScript Controllers

For interactive components (Dialog, Dropdown, Tabs, Tooltip), install the Stimulus controllers:

```bash
rails generate shadcn:js
```

This installs controllers to `app/javascript/controllers/`. Make sure you have Stimulus set up in your Rails application.

## Configuration

Create an initializer to customize the gem:

```ruby
# config/initializers/shadcn.rb
Shadcn::Rails.configure do |config|
  # Path where components will be installed
  config.components_path = "app/components/ui"

  # Path to your Tailwind CSS configuration file
  config.tailwind_config_path = "config/tailwind.config.js"
end
```

## Customization

Since components are copied to your application, you have full control over customization:

1. **Modify styles** - Edit the component classes directly
2. **Add variants** - Extend the VARIANTS hash in components
3. **Change structure** - Modify the HTML structure as needed
4. **Add slots** - Use ViewComponent's slot API to add new slots

## Requirements

- Ruby >= 3.0
- Rails >= 7.0
- ViewComponent >= 3.0
- Tailwind CSS 3.x

## Development

### Setup

After checking out the repo, run `bin/setup` to install dependencies:

```bash
bin/setup
```

### Running Tests

Run the test suite with:

```bash
bundle exec rake test
```

### Running the Dummy App

The gem includes a Rails dummy app for testing components locally with Lookbook:

```bash
# Install dependencies
cd test/dummy && bin/setup

# Start the server
bundle exec rake dummy:server

# Or manually
cd test/dummy && bin/rails server
```

Then visit:
- **Home**: http://localhost:3000
- **Components**: http://localhost:3000/components
- **Lookbook**: http://localhost:3000/lookbook

### Component Previews with Lookbook

Lookbook provides an interactive UI for browsing and testing components. Component previews are located in `test/dummy/test/components/previews/`.

To add a new preview:

```ruby
# test/dummy/test/components/previews/my_component_preview.rb
class MyComponentPreview < ViewComponent::Preview
  def default
    render Ui::MyComponent.new
  end
end
```

## JavaScript Bundler Compatibility

shadcn-rails works with all Rails JavaScript bundling solutions:

### Importmap (Rails 7+ default)

```bash
rails g shadcn:js --bundler=importmap
```

Controllers are pinned automatically in your `config/importmap.rb`.

### esbuild

```bash
rails g shadcn:js --bundler=esbuild
```

Import in your `application.js`:

```javascript
import { registerControllers } from "./shadcn"
registerControllers(application)
```

### Webpack

```bash
rails g shadcn:js --bundler=webpack
```

Import in your entrypoint:

```javascript
import { registerControllers } from "./shadcn"
registerControllers(application)
```

### Vite (vite-rails)

```bash
rails g shadcn:js --bundler=vite
```

Controllers are installed to `app/frontend/controllers`. Import in your entrypoint:

```javascript
import { registerControllers } from "@/shadcn"
registerControllers(application)
```

### Auto-detection

By default, the generator auto-detects your bundler:

```bash
rails g shadcn:js  # Auto-detects importmap, esbuild, webpack, or vite
```

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
