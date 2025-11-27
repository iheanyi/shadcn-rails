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

The library includes 47 components organized by category:

**Buttons & Actions**
| File | Description |
|------|-------------|
| `button_component.rb` | 6 variants (default, secondary, destructive, outline, ghost, link), 6 sizes |
| `toggle_component.rb` | Two-state button with pressed/unpressed states |
| `toggle_group_component.rb` | Group of toggle buttons (single/multiple selection) |
| `button_group_component.rb` | Group of related buttons |

**Form Inputs**
| File | Description |
|------|-------------|
| `input_component.rb` | Text input with various types |
| `textarea_component.rb` | Multi-line text input |
| `label_component.rb` | Form label element |
| `checkbox_component.rb` | Checkbox with indeterminate state support |
| `switch_component.rb` | Toggle switch control |
| `slider_component.rb` | Range slider input |
| `select_component.rb` | Custom styled select dropdown |
| `native_select_component.rb` | Native HTML select with styling |
| `radio_group_component.rb` | Radio button group |
| `field_component.rb` | Form field wrapper with label/error slots |
| `input_group_component.rb` | Input with prefix/suffix addons |
| `input_otp_component.rb` | One-time password input |

**Data Display**
| File | Description |
|------|-------------|
| `badge_component.rb` | Labels with variants (default, secondary, destructive, outline) |
| `avatar_component.rb` | User avatar with image/fallback |
| `card_component.rb` | Header, content, footer slots |
| `table_component.rb` | Styled table with header/body/footer |
| `progress_component.rb` | Progress bar indicator |
| `skeleton_component.rb` | Loading placeholder |
| `spinner_component.rb` | Loading spinner animation |
| `kbd_component.rb` | Keyboard key display |
| `typography_component.rb` | Text styling utilities |
| `aspect_ratio_component.rb` | Maintains aspect ratio for media content |
| `scroll_area_component.rb` | Custom scrollbar container |

**Feedback**
| File | Description |
|------|-------------|
| `alert_component.rb` | Callout/notification with variants (default, destructive) |
| `tooltip_component.rb` | Hover tooltip popup |
| `toast_component.rb` | Temporary notification messages |

**Overlays**
| File | Description |
|------|-------------|
| `dialog_component.rb` | Modal with portal, focus trap |
| `alert_dialog_component.rb` | Confirmation dialog with cancel/confirm actions |
| `sheet_component.rb` | Slide-out panel from any edge |
| `drawer_component.rb` | Bottom sheet drawer |
| `popover_component.rb` | Floating content panel |
| `hover_card_component.rb` | Card that appears on hover |
| `dropdown_menu_component.rb` | Dropdown menu with items, separators, keyboard shortcuts |

**Navigation**
| File | Description |
|------|-------------|
| `tabs_component.rb` | Tabbed interface with URL sync support |
| `accordion_component.rb` | Collapsible sections (single/multiple mode) |
| `breadcrumb_component.rb` | Navigation breadcrumb trail |
| `pagination_component.rb` | Page navigation with Kaminari/Pagy/WillPaginate support |
| `collapsible_component.rb` | Show/hide content section |
| `separator_component.rb` | Visual divider line |
| `context_menu_component.rb` | Right-click context menu |
| `menubar_component.rb` | Horizontal menu bar with dropdowns |
| `navigation_menu_component.rb` | Navigation with dropdown content |
| `resizable_component.rb` | Resizable panel groups |

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

# Build JavaScript (from project root)
npm run build

# Start dummy app for local development (RECOMMENDED)
cd test/dummy && bin/dev

# Start Lookbook previews
cd test/dummy && rails lookbook:preview
```

## Local Testing with bin/dev

**IMPORTANT**: Always use `bin/dev` instead of `rails server` when testing locally. This ensures:
1. JavaScript is automatically rebuilt when files change (via esbuild watch mode)
2. CSS is automatically rebuilt when Tailwind classes change
3. Changes to Stimulus controllers are immediately available

```bash
# Start the development server (from test/dummy)
cd test/dummy && bin/dev

# If port 3000 is in use, kill existing processes first:
lsof -ti:3000 | xargs kill -9 2>/dev/null
rm -f tmp/pids/server.pid
bin/dev
```

The development server runs:
- Rails server on port 3000
- esbuild in watch mode for JavaScript bundling
- Tailwind CSS in watch mode

**Note**: After modifying Stimulus controllers in `app/assets/javascripts/shadcn/controllers/`, you must also run `npm run build` from the project root to update the npm package distribution files.

## Regression Testing

When making changes to interactive components, always verify:

### Context Menu
1. **Open/Close**: Right-click to open, click outside or press Escape to close
2. **Double right-click**: Right-clicking twice in quick succession should reposition the menu
3. **Keyboard navigation**: Arrow keys, Home/End, Enter/Space for selection
4. **Scroll lock**: Background should not scroll when menu is open
5. **Animation**: Smooth fade-in/out animation (100ms)
6. **Positioning**: Menu stays within viewport bounds

### Radio Group
1. **Labels are clickable**: Clicking the label should select the radio
2. **Descriptions render**: Items with descriptions show them below the label
3. **Keyboard navigation**: Tab to focus, arrow keys to move between items
4. **Single selection**: Only one item can be selected at a time

### Dropdown Menu
1. **All item types**: Test items, checkboxes, radio groups, separators, labels
2. **Keyboard shortcuts**: Display correctly with proper styling
3. **Submenus**: Open on hover, close when moving away

### Dialog/Sheet/Drawer
1. **Focus trap**: Tab should cycle within the modal
2. **Escape closes**: Pressing Escape should close the modal
3. **Overlay click**: Clicking the overlay should close (unless modal)
4. **Body scroll lock**: Background should not scroll when open

### Testing with Playwright

Use the MCP Playwright tools for automated testing:

```javascript
// Navigate to docs page
mcp__playwright__browser_navigate({ url: "http://localhost:3000/docs/context-menu" })

// Take a snapshot to see the page state
mcp__playwright__browser_snapshot()

// Right-click to open context menu (use browser_run_code for context menu)
mcp__playwright__browser_run_code({
  code: `await page.locator('[data-shadcn--context-menu-target="trigger"]').click({ button: 'right' })`
})

// Press Escape to close
mcp__playwright__browser_press_key({ key: "Escape" })
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

The `ClassMerger` utility handles conflicts like `p-2 p-4` (p-4 wins). If you encounter unresolved conflicts, add the pattern to `CLASS_GROUPS` or `CONFLICT_PATTERNS` in `lib/shadcn/rails/class_merger.rb`.

**Pattern Ordering Issue**: When adding regex patterns to `CONFLICT_PATTERNS`, be careful of pattern matching order. The `find_conflict_group` method returns on the first match, so patterns must use negative lookaheads to exclude overlapping cases.

Example fix for border classes:
```ruby
# PROBLEM: border-0 was matching border_color before border_width
/^border-(?!solid|dashed|dotted|double|none)/ => :border_color,

# SOLUTION: Add [0-9] to the negative lookahead to exclude border widths
/^border-(?!solid|dashed|dotted|double|none|[0-9])/ => :border_color,
```

This ensures `border-0`, `border-2`, etc. are categorized as `:border_width` (not `:border_color`) so they properly conflict with and override `border`.

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

## Documentation Site

The `test/dummy` app serves as both a testing environment and documentation site. It includes:
- Full documentation for all 47 components at `/docs`
- Live interactive examples that demonstrate each component
- Code examples stored in `app/code_examples/{component}/` as `.txt` files
- `erb_example` helper to display code examples with syntax highlighting
- Showcase page at `/showcase`

### Documentation Structure

```
test/dummy/
├── app/
│   ├── views/docs/           # Component documentation pages
│   │   ├── button.html.erb
│   │   ├── dialog.html.erb
│   │   └── ...
│   ├── code_examples/        # Code examples displayed in docs
│   │   ├── button/
│   │   │   └── default.txt
│   │   └── pagination/
│   │       ├── kaminari_view.txt
│   │       └── pagy_view.txt
│   └── helpers/
│       └── docs_helper.rb    # erb_example helper method
```

## Future Improvements

**Missing Components** (from shadcn/ui):
- [ ] Command palette
- [ ] Combobox
- [ ] Date Picker
- [ ] Calendar
- [ ] Sonner (toast alternative)
- [ ] Carousel
- [ ] Chart
- [ ] Data Table
- [ ] Sidebar

**Enhancements**:
- [ ] Form builder integration (Rails form helpers)
- [ ] Hotwire/Turbo Stream integration helpers
- [ ] RTL support
- [ ] Visual regression tests with Percy or similar
- [ ] Dropdown Menu submenus and checkbox/radio items
- [ ] Drawer gesture support (touch drag to dismiss)

**Completed**:
- [x] 47 core components implemented
- [x] Full documentation site with live examples
- [x] Stimulus controllers for all interactive components
- [x] Pagination with Kaminari/Pagy/WillPaginate adapters
- [x] CSS animations for dialogs, sheets, toasts, accordions
- [x] Context Menu component
- [x] Menubar component
- [x] Navigation Menu component
- [x] Resizable panels component
- [x] Input OTP with group separators

## Resources

- [shadcn/ui Documentation](https://ui.shadcn.com)
- [ViewComponent Guide](https://viewcomponent.org)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
