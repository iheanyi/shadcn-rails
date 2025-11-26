# CLAUDE.md - Development Guide for shadcn-rails

This document contains learnings, patterns, and guidelines for future development sessions on this project.

## Project Overview

shadcn-rails is a Ruby port of [shadcn/ui](https://ui.shadcn.com) for Rails applications. It uses:
- **ViewComponent** for Ruby-based component architecture
- **Stimulus** for JavaScript interactivity
- **Tailwind CSS** for styling
- **CSS Custom Properties** for theming

## Architecture Patterns

### Component Structure

All components inherit from `Shadcn::BaseComponent` which provides:
- `cn(*classes)` - Class name merging utility (like clsx + tailwind-merge)
- `stimulus_data(controller, values, actions)` - Stimulus data attribute builder
- `build_html_attributes(**attrs)` - HTML attribute builder with class merging

```ruby
# app/components/shadcn/base_component.rb
class Shadcn::BaseComponent < ViewComponent::Base
  include Shadcn::Rails::Helpers::ClassNameHelper

  def cn(*classes)
    Shadcn::Rails.cn(*classes)
  end
end
```

### Component Location

Components are located in `app/components/shadcn/`:
- Each component is a single Ruby file (e.g., `button_component.rb`)
- Complex components use ViewComponent slots for composition
- ERB templates are inline using `erb_template` when simple, or separate `.html.erb` files when complex

### Stimulus Controllers

Controllers are in `app/assets/javascripts/shadcn/controllers/`:
- Named `{component}_controller.js`
- Use Stimulus naming convention: `shadcn--{component}`
- Handle interactivity: open/close states, keyboard navigation, focus management

```javascript
// Example controller pattern
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { open: Boolean }

  toggle() {
    this.openValue = !this.openValue
  }

  openValueChanged() {
    // React to state changes
  }
}
```

### CSS Theming

CSS variables are defined in `app/assets/stylesheets/shadcn/base.css`:
- All colors use HSL format without `hsl()` wrapper: `--primary: 0 0% 9%;`
- Components use: `hsl(var(--primary))`
- Dark mode uses `.dark` class on `<html>` element

Theme presets are in `lib/shadcn/rails/configuration.rb` with full HSL values for:
- neutral, slate, stone, zinc, gray

## Key Files

### Core Library
- `lib/shadcn/rails.rb` - Main module, configuration, `cn()` helper
- `lib/shadcn/rails/engine.rb` - Rails engine setup
- `lib/shadcn/rails/configuration.rb` - Theme configuration with CSS variables
- `lib/shadcn/rails/class_merger.rb` - Tailwind class conflict resolution

### Components (app/components/shadcn/)
| File | Description |
|------|-------------|
| `base_component.rb` | Base class all components inherit from |
| `alert_component.rb` | Callout/notification with variants (default, destructive) |
| `alert_dialog_component.rb` | Confirmation dialog with cancel/confirm actions |
| `aspect_ratio_component.rb` | Maintains aspect ratio for media content |
| `badge_component.rb` | Labels with variants (default, secondary, destructive, outline) |
| `button_component.rb` | 6 variants, 6 sizes |
| `card_component.rb` | Header, content, footer slots |
| `dialog_component.rb` | Modal with portal, focus trap |
| `drawer_component.rb` | Slide-out panel from any direction (top, right, bottom, left) |
| `hover_card_component.rb` | Card that appears on hover |
| `input_component.rb` | Text input with various types |
| `pagination_component.rb` | Page navigation with prev/next and page numbers |
| `tabs_component.rb` | Tabbed interface |
| `toggle_group_component.rb` | Group of toggle buttons (single/multiple selection) |

### Generators (lib/generators/shadcn/)
- `install/` - Initial setup generator
- `component/` - Add individual components
- `theme/` - Switch color themes

### Tests
- `test/components/` - Component unit tests
- `test/components/previews/` - Lookbook previews
- `test/dummy/` - Rails dummy app for integration testing

## Development Commands

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rake test

# Run component tests only
bundle exec rake test_components

# Start dummy app
cd test/dummy && rails server

# Start Lookbook previews
cd test/dummy && rails lookbook:preview
```

## Patterns to Follow

### 1. Component Variants

Use symbols for variant options and define them as constants:

```ruby
VARIANTS = {
  default: "bg-primary text-primary-foreground",
  destructive: "bg-destructive text-destructive-foreground",
  outline: "border border-input bg-background",
  secondary: "bg-secondary text-secondary-foreground",
  ghost: "hover:bg-accent hover:text-accent-foreground",
  link: "text-primary underline-offset-4 hover:underline"
}

def initialize(variant: :default, **attrs)
  @variant = variant.to_sym
end
```

### 2. Compound Components with Slots

Use ViewComponent's `renders_one` and `renders_many` for composition:

```ruby
renders_one :header, "HeaderComponent"
renders_many :items, "ItemComponent"

class HeaderComponent < ViewComponent::Base
  renders_one :title
  renders_one :description
end
```

### 3. Stimulus Integration

Components that need JavaScript should:
1. Define a Stimulus controller
2. Use `stimulus_data()` helper in the component
3. Follow the `shadcn--{name}` naming convention

```ruby
def stimulus_attributes
  stimulus_data(
    "shadcn--dialog",
    { open: @open },
    { "trigger->click": "toggle" }
  )
end
```

### 4. Accessibility (ARIA)

All interactive components must include proper ARIA attributes:
- `role` attributes where needed
- `aria-expanded`, `aria-hidden`, `aria-controls`
- `aria-labelledby`, `aria-describedby` for relationships
- Keyboard navigation support

### 5. CSS Class Merging

Always use `cn()` for class composition to handle Tailwind conflicts:

```ruby
def classes
  cn(
    "base-classes here",
    VARIANTS[@variant],
    SIZES[@size],
    @class_name
  )
end
```

### 6. Test Coverage

For each component, create tests in `test/components/`:
- Test default rendering
- Test all variants
- Test all sizes (if applicable)
- Test slot rendering
- Test accessibility attributes

```ruby
class ButtonComponentTest < ViewComponent::TestCase
  def test_renders_button
    render_inline(Shadcn::ButtonComponent.new) { "Click" }
    assert_selector "button", text: "Click"
  end

  def test_renders_variants
    Shadcn::ButtonComponent::VARIANTS.keys.each do |variant|
      render_inline(Shadcn::ButtonComponent.new(variant: variant)) { "Test" }
      assert_selector "button"
    end
  end
end
```

## Adding New Components

1. Create component file in `app/components/shadcn/{name}_component.rb`
2. Inherit from `Shadcn::BaseComponent`
3. If interactive, create Stimulus controller in `app/assets/javascripts/shadcn/controllers/{name}_controller.js`
4. Add controller export to `app/assets/javascripts/shadcn/index.js`
5. Create test in `test/components/{name}_component_test.rb`
6. Create Lookbook preview in `test/components/previews/{name}_component_preview.rb`
7. Add example to dummy app views

## Common Issues & Solutions

### ViewComponent Preview Nested Render Issue

**Problem**: When using nested `render()` calls inside ViewComponent preview slots, the output is a hash like `{args: {}, block: #<Proc:...>, component: #<...>}` instead of rendered HTML.

**Solution**: Use raw HTML strings instead of nested render calls in previews:

```ruby
# BAD - nested render returns hash, not HTML
def default
  render(Shadcn::DialogComponent.new) do |dialog|
    dialog.with_trigger do
      render(Shadcn::ButtonComponent.new(variant: :outline)) { "Open" }  # Returns hash!
    end
  end
end

# GOOD - use raw HTML strings or helper methods
def default
  render(Shadcn::DialogComponent.new) do |dialog|
    dialog.with_trigger do
      button_html(:outline, "Open")  # Returns HTML string
    end
  end
end

private

def button_html(variant, text, extra_class = nil)
  # Generate HTML string directly
  %(<button class="#{classes}">#{text}</button>).html_safe
end
```

### Superclass Mismatch Error

**Problem**: Rails throws "superclass mismatch for class X" error for nested component classes (e.g., `DialogContentComponent`).

**Cause**: Rails Zeitwerk autoloading gets confused when nested classes are reloaded and the parent class definition has changed.

**Solution**: Restart the Rails server to clear cached class definitions. This commonly happens when modifying component files with nested classes.

### Tailwind Class Conflicts

The `ClassMerger` utility handles conflicts like `p-2 p-4` (p-4 wins). If you encounter unresolved conflicts, add the pattern to `CLASS_GROUPS` in `lib/shadcn/rails/class_merger.rb`.

### Stimulus Controller Not Loading

Ensure:
1. Controller is exported in `index.js`
2. Controller name matches: `shadcn--{name}`
3. User has called `registerShadcnControllers(application)` or manually registered

### Preview Layout Requirements

The `component_preview.html.erb` layout must include:
1. **Tailwind CSS** via CDN with custom shadcn color tokens
2. **Stimulus application** initialized and connected
3. **Inline Stimulus controllers** for all interactive components (Dialog, Sheet, Tabs, Accordion, Checkbox, Switch, Popover, Tooltip)
4. **CSS animations** for transitions (dialog fade-in, sheet slide-in, etc.)

For previews, Stimulus controllers are inlined directly in the layout since the JavaScript bundling isn't available. This is different from production where controllers come from the npm package.

### Tabs Controller Method Names

The Tabs Stimulus controller uses `selectTab` for the click action, not `select`:

```javascript
// In tabs_controller.js
selectTab(event) {
  const trigger = event.currentTarget
  const value = trigger.dataset.value
  this.valueValue = value
}
```

Ensure your triggers use: `data-action="click->shadcn--tabs#selectTab"`

### Dark Mode Not Working

Check:
1. CSS variables are loaded
2. `.dark` class is on `<html>` element (not `<body>`)
3. Tailwind dark mode is configured as `class` strategy

## Future Improvements

- [ ] Add more complex components: Command, Combobox, Date Picker
- [ ] Form builder integration
- [ ] Hotwire/Turbo integration helpers
- [ ] Animation system (CSS transitions)
- [ ] RTL support
- [ ] TypeScript definitions for Stimulus controllers
- [ ] Visual regression tests with Percy or similar
- [ ] Storybook-like documentation site

## Resources

- [shadcn/ui Documentation](https://ui.shadcn.com)
- [ViewComponent Guide](https://viewcomponent.org)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
