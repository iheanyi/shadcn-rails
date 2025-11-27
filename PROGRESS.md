# shadcn-rails Documentation Progress

---

## Component Parity Audit (vs shadcn/ui)

Reference: https://ui.shadcn.com/docs/components

### ✅ Implemented Components (46/59)

| Component | shadcn/ui Docs | Status |
|-----------|----------------|--------|
| Accordion | [docs](https://ui.shadcn.com/docs/components/accordion) | ✅ Complete |
| Alert | [docs](https://ui.shadcn.com/docs/components/alert) | ✅ Complete |
| Alert Dialog | [docs](https://ui.shadcn.com/docs/components/alert-dialog) | ✅ Complete |
| Aspect Ratio | [docs](https://ui.shadcn.com/docs/components/aspect-ratio) | ✅ Complete |
| Avatar | [docs](https://ui.shadcn.com/docs/components/avatar) | ✅ Complete |
| Badge | [docs](https://ui.shadcn.com/docs/components/badge) | ✅ Complete |
| Breadcrumb | [docs](https://ui.shadcn.com/docs/components/breadcrumb) | ✅ Complete |
| Button | [docs](https://ui.shadcn.com/docs/components/button) | ✅ Complete |
| Button Group | N/A | ✅ Complete |
| Card | [docs](https://ui.shadcn.com/docs/components/card) | ✅ Complete |
| Command | [docs](https://ui.shadcn.com/docs/components/command) | ✅ Complete |
| Checkbox | [docs](https://ui.shadcn.com/docs/components/checkbox) | ✅ Complete |
| Collapsible | [docs](https://ui.shadcn.com/docs/components/collapsible) | ✅ Complete |
| Dialog | [docs](https://ui.shadcn.com/docs/components/dialog) | ✅ Complete |
| Drawer | [docs](https://ui.shadcn.com/docs/components/drawer) | ✅ Complete (animations added) |
| Dropdown Menu | [docs](https://ui.shadcn.com/docs/components/dropdown-menu) | ✅ Complete |
| Field | N/A | ✅ Complete |
| Hover Card | [docs](https://ui.shadcn.com/docs/components/hover-card) | ✅ Complete |
| Input | [docs](https://ui.shadcn.com/docs/components/input) | ✅ Complete |
| Input Group | N/A | ✅ Complete |
| Input OTP | [docs](https://ui.shadcn.com/docs/components/input-otp) | ✅ Complete |
| Kbd | N/A | ✅ Complete |
| Label | [docs](https://ui.shadcn.com/docs/components/label) | ✅ Complete |
| Native Select | N/A | ✅ Complete |
| Pagination | [docs](https://ui.shadcn.com/docs/components/pagination) | ✅ Complete |
| Popover | [docs](https://ui.shadcn.com/docs/components/popover) | ✅ Complete |
| Progress | [docs](https://ui.shadcn.com/docs/components/progress) | ✅ Complete |
| Radio Group | [docs](https://ui.shadcn.com/docs/components/radio-group) | ✅ Complete |
| Scroll Area | [docs](https://ui.shadcn.com/docs/components/scroll-area) | ✅ Complete |
| Select | [docs](https://ui.shadcn.com/docs/components/select) | ✅ Complete |
| Separator | [docs](https://ui.shadcn.com/docs/components/separator) | ✅ Complete |
| Sheet | [docs](https://ui.shadcn.com/docs/components/sheet) | ✅ Complete |
| Skeleton | [docs](https://ui.shadcn.com/docs/components/skeleton) | ✅ Complete |
| Slider | [docs](https://ui.shadcn.com/docs/components/slider) | ✅ Complete |
| Spinner | N/A | ✅ Complete |
| Switch | [docs](https://ui.shadcn.com/docs/components/switch) | ✅ Complete |
| Table | [docs](https://ui.shadcn.com/docs/components/table) | ✅ Complete |
| Tabs | [docs](https://ui.shadcn.com/docs/components/tabs) | ✅ Complete |
| Textarea | [docs](https://ui.shadcn.com/docs/components/textarea) | ✅ Complete |
| Toast | [docs](https://ui.shadcn.com/docs/components/toast) | ✅ Complete |
| Toggle | [docs](https://ui.shadcn.com/docs/components/toggle) | ✅ Complete |
| Toggle Group | [docs](https://ui.shadcn.com/docs/components/toggle-group) | ✅ Complete |
| Tooltip | [docs](https://ui.shadcn.com/docs/components/tooltip) | ✅ Complete |
| Typography | N/A | ✅ Complete |

### ❌ Missing Components (13/59)

| Component | shadcn/ui Docs | Priority | Complexity | Notes |
|-----------|----------------|----------|------------|-------|
| **High Priority** |
| Calendar | [docs](https://ui.shadcn.com/docs/components/calendar) | High | High | Date selection, requires date library integration |
| Combobox | [docs](https://ui.shadcn.com/docs/components/combobox) | High | High | Autocomplete select with search/filtering |
| Data Table | [docs](https://ui.shadcn.com/docs/components/data-table) | High | High | Sortable, filterable data grid |
| Date Picker | [docs](https://ui.shadcn.com/docs/components/date-picker) | High | High | Calendar + Popover composition |
| Form | [docs](https://ui.shadcn.com/docs/components/form) | High | Medium | Form builder integration with Rails |
| Navigation Menu | [docs](https://ui.shadcn.com/docs/components/navigation-menu) | High | Medium | Site navigation with dropdowns |
| Sidebar | [docs](https://ui.shadcn.com/docs/components/sidebar) | High | Medium | App sidebar layout pattern |
| **Medium Priority** |
| Carousel | [docs](https://ui.shadcn.com/docs/components/carousel) | Medium | Medium | Image/content slider |
| Context Menu | [docs](https://ui.shadcn.com/docs/components/context-menu) | Medium | Medium | Right-click menu |
| Menubar | [docs](https://ui.shadcn.com/docs/components/menubar) | Medium | Medium | Desktop menu bar |
| Resizable | [docs](https://ui.shadcn.com/docs/components/resizable) | Medium | Medium | Resizable panels |
| Sonner | [docs](https://ui.shadcn.com/docs/components/sonner) | Medium | Low | Toast alternative (we have Toast) |
| **Low Priority** |
| Chart | [docs](https://ui.shadcn.com/docs/components/chart) | Low | High | Requires charting library |

### ✅ Recently Implemented
| Component | Status | Notes |
|-----------|--------|-------|
| Empty | ✅ Complete | Empty state placeholder with media, title, description, and content slots |
| Item | ✅ Complete | Flexible flex container with variants and subcomponents |
| Command | ✅ Complete | Command palette with search, keyboard navigation, dialog variant |

### Priority Roadmap

#### Phase 1: Quick Wins (Low complexity, high value) ✅ COMPLETED
These can be implemented quickly and provide immediate value:
1. ~~**Button Group** - Simple wrapper component~~ ✅
2. ~~**Field** - Form field wrapper (label + input + error)~~ ✅
3. ~~**Input Group** - Input with prefix/suffix icons~~ ✅
4. ~~**Kbd** - Keyboard shortcut display~~ ✅
5. ~~**Spinner** - Loading animation~~ ✅
6. ~~**Typography** - Prose/text styles~~ ✅

#### Phase 2: Form Ecosystem ✅ COMPLETED
Build out form-related components:
1. ~~**Form** - Rails form builder integration~~ (using Field component)
2. ~~**Native Select** - Styled native select~~ ✅
3. ~~**Input OTP** - One-time password input~~ ✅

#### Phase 3: Navigation & Layout
Essential for app-like experiences:
1. **Navigation Menu** - Site navigation with dropdowns
2. **Sidebar** - App sidebar layout
3. **Menubar** - Desktop menu bar
4. **Context Menu** - Right-click menus

#### Phase 4: Advanced Interactive Components
Complex components requiring significant Stimulus work:
1. **Combobox** - Autocomplete/searchable select
2. **Command** - Command palette (cmd+k pattern)
3. **Calendar** - Date selection grid
4. **Date Picker** - Calendar + Popover composition
5. **Resizable** - Draggable panel resizing
6. **Carousel** - Image/content slider

#### Phase 5: Data & Visualization
Components for displaying data:
1. **Data Table** - Sortable, filterable tables
2. **Chart** - Data visualization (may skip, Rails apps often use Chartkick/etc)

#### Likely to Skip
- **Empty** - Easy to build custom, low standardization value
- **Item** - Very generic, apps will customize heavily
- **Sonner** - We already have Toast component

---

## Feature Parity Analysis (Implemented Components)

Detailed comparison of our implementations vs shadcn/ui features.

### ✅ Full Parity (No Action Needed)

| Component | Notes |
|-----------|-------|
| **Button** | All 6 variants, 6 sizes, loading state, href support ✅ |
| **Dialog** | All slots (trigger, content, header, title, description, footer, close) ✅ |
| **Accordion** | Single/multiple types, collapsible, default_value ✅ |
| **Tabs** | TabsList, TabsTrigger, TabsContent, defaultValue ✅ |
| **Alert** | default/destructive variants, title/description/icon slots ✅ |
| **Badge** | All 4 variants (default, secondary, destructive, outline) ✅ |
| **Toggle** | default/outline variants, sm/default/lg sizes, disabled ✅ |
| **Toggle Group** | Single/multiple types, variants, sizes ✅ |
| **Checkbox** | checked, disabled, indeterminate, form integration ✅ |
| **Switch** | Basic toggle with label support ✅ |
| **Slider** | value, min, max, step, disabled ✅ |
| **Progress** | value prop, styling ✅ |
| **Tooltip** | side, align, delay_duration, skip_delay_duration ✅ |
| **Sheet** | All 4 sides (top, right, bottom, left), all slots ✅ |
| **Card** | header, title, description, content, footer slots ✅ |
| **Input** | type, placeholder, disabled, required ✅ |
| **Textarea** | placeholder, disabled, rows ✅ |
| **Label** | for attribute, styling ✅ |
| **Separator** | horizontal/vertical orientation ✅ |
| **Skeleton** | Basic skeleton loading ✅ |
| **Avatar** | src, alt, fallback ✅ |
| **Aspect Ratio** | ratio prop ✅ |
| **Scroll Area** | Custom scrollbar styling ✅ |
| **Table** | header, body, footer, row, cell, caption ✅ |
| **Breadcrumb** | items, separator ✅ |
| **Collapsible** | open, trigger, content ✅ |
| **Alert Dialog** | All slots, cancel/action buttons ✅ |
| **Hover Card** | trigger, content, positioning ✅ |
| **Popover** | trigger, content, positioning ✅ |
| **Radio Group** | items, disabled, default value ✅ |
| **Select** | trigger, content, items, groups, separators ✅ |
| **Pagination** | items, previous, next, ellipsis ✅ |

### ⚠️ Partial Parity (Features Missing)

| Component | Our Implementation | Missing from shadcn/ui |
|-----------|-------------------|------------------------|
| **Dropdown Menu** | Basic items, labels, separators, groups | ❌ Checkbox items, ❌ Radio items, ❌ Submenus, ❌ Keyboard shortcut display |
| **Drawer** | Full drawer with 4 directions and CSS animations | ❌ Swipe/gesture support (like Vaul) - planned future enhancement |
| **Toast** | Basic toast with variants | Note: shadcn/ui deprecated Toast in favor of Sonner (React-specific). Our implementation is appropriate for Rails. |

### 📋 Feature Gap TODOs

**Dropdown Menu Enhancements:**
- [ ] Add `DropdownMenuCheckboxItem` - checkbox items within menu
- [ ] Add `DropdownMenuRadioGroup` and `DropdownMenuRadioItem` - radio selection
- [ ] Add `DropdownMenuSub`, `DropdownMenuSubTrigger`, `DropdownMenuSubContent` - nested submenus
- [ ] Add keyboard shortcut display in menu items
- Reference: https://ui.shadcn.com/docs/components/dropdown-menu

**Drawer Enhancements:**
- [ ] Add swipe/gesture support for mobile (slide to close)
- [ ] Add responsive pattern example (Drawer on mobile, Dialog on desktop using media queries)
- [ ] Consider snap points for partial drawer states
- Reference: https://ui.shadcn.com/docs/components/drawer

---

## Completed Phases

### Phase 1: Docs Layout & Partials ✅
- Created `docs_controller.rb` with component metadata
- Created docs layout with sidebar navigation
- Created reusable partials: `_code_example`, `_props_table`, `_demo_card`, `_stimulus_docs`

### Phase 2: Key Component Templates ✅
- Button, Dialog, Tabs, Pagination documentation pages

### Phase 2b: File-based Code Examples ✅
- Created `erb_example` helper for loading code examples from files
- Solved ERB escaping issues

### Phase 2c: Convert Pages to File-based Examples ✅
- All pages now use file-based code examples

### Phase 3: All Component Documentation Pages ✅
Generated 35 component documentation pages:
- Accordion, Alert, Alert Dialog, Aspect Ratio, Avatar
- Badge, Breadcrumb, Button, Card, Checkbox
- Collapsible, Dialog, Drawer, Dropdown Menu, Hover Card
- Input, Label, Pagination, Popover, Progress
- Radio Group, Scroll Area, Select, Separator, Sheet
- Skeleton, Slider, Switch, Table, Tabs
- Textarea, Toast, Toggle, Toggle Group, Tooltip

### Bug Fixes ✅
- Fixed Pagination component ordering bug (ellipses rendering after items)
- Added regression tests for pagination ordering
- Fixed CardComponent `with_content` method alias (was `with_content_slot`)

### Testing (Playwright) ✅
- Verified all 35 component documentation pages load correctly
- Tested interactive components:
  - Dialog: Opens with form fields, close button works
  - Accordion: Expands/collapses items correctly
  - Checkbox: Toggles checked state
  - All sidebar navigation links work

### Phase 5: Pagination Gem Integration ✅
- Added Kaminari integration examples with controller and view code
- Added will_paginate integration examples
- Added Pagy integration examples
- Added documentation for URL builder pattern
- Added examples for window sizes and disabled states

### Phase 6: README Updates ✅
- Documented JavaScript bundler setup (esbuild, importmap, webpack, Vite)
- Added TypeScript configuration guide
- Updated installation instructions
- Added comprehensive component documentation with API references

### Phase 7: Documentation Site Evaluation ✅
- Evaluated Bridgetown approach vs current Rails dummy app
- **Decision**: Continue with Rails dummy app approach
  - Already functional and deployed locally
  - Renders actual shadcn-rails components
  - No separate build/deployment pipeline needed
  - Can be deployed to any Rails hosting (Heroku, Render, Fly.io)
- Deferred Bridgetown as optional future enhancement for static SEO-friendly site

---

### Phase 4: Lookbook Previews ✅
All 35 components now have Lookbook previews:
- Accordion, Alert, Alert Dialog, Aspect Ratio, Avatar
- Badge, Breadcrumb, Button, Card, Checkbox
- Collapsible, Dialog, Drawer, Dropdown Menu, Hover Card
- Input, Label, Pagination, Popover, Progress
- Radio Group, Scroll Area, Select, Separator, Sheet
- Skeleton, Slider, Switch, Table, Tabs
- Textarea, Toast, Toggle, Toggle Group, Tooltip

---

## Pending Phases

### Phase 8: Documentation Website Deployment
- Deploy documentation site to production URL
- Set up CI/CD for docs
- Configure custom domain (optional)

---

## Known Issues & TODOs

### Dropdown Menu Component
- [ ] **TODO**: Add checkbox items (`DropdownMenuCheckboxItem`)
- [ ] **TODO**: Add radio items (`DropdownMenuRadioGroup`, `DropdownMenuRadioItem`)
- [ ] **TODO**: Add submenus (`DropdownMenuSub`, `DropdownMenuSubTrigger`, `DropdownMenuSubContent`)
- [ ] **TODO**: Add keyboard shortcut display in menu items
- Reference: https://ui.shadcn.com/docs/components/dropdown-menu

### Toast Component
- [x] **BUG FIXED**: Toasts are now auto-closing/dismissing
- [x] Close button functionality verified and working
- [x] Auto-dismiss timer working (default 5000ms)
- Note: Library exports ToastController in `index.js`. Docs layout uses inline controllers for CDN demo only.
- Reference: https://ui.shadcn.com/docs/components/toast

### Drawer Component
- [ ] **TODO**: Add mobile gesture support (slide/swipe to close)
- [ ] Add responsive drawer example (drawer on mobile, dialog on desktop)
- [ ] Consider snap points for partial drawer states
- Reference: https://ui.shadcn.com/docs/components/drawer

### Stimulus Controllers (Library)
**Status**: All 20 interactive components have controllers in `app/assets/javascripts/shadcn/controllers/`

| Controller | File | Exported in index.js |
|------------|------|---------------------|
| Accordion | accordion_controller.js | ✅ |
| Avatar | avatar_controller.js | ✅ |
| Checkbox | checkbox_controller.js | ✅ |
| Collapsible | collapsible_controller.js | ✅ |
| Dialog | dialog_controller.js | ✅ |
| Drawer | drawer_controller.js | ✅ |
| Dropdown | dropdown_controller.js | ✅ |
| HoverCard | hover_card_controller.js | ✅ |
| Popover | popover_controller.js | ✅ |
| RadioGroup | radio_group_controller.js | ✅ |
| ScrollArea | scroll_area_controller.js | ✅ |
| Select | select_controller.js | ✅ |
| Sheet | sheet_controller.js | ✅ |
| Slider | slider_controller.js | ✅ |
| Switch | switch_controller.js | ✅ |
| Tabs | tabs_controller.js | ✅ |
| Toast | toast_controller.js | ✅ |
| Toggle | toggle_controller.js | ✅ |
| ToggleGroup | toggle_group_controller.js | ✅ |
| Tooltip | tooltip_controller.js | ✅ |

**User Installation**: Users must call `registerShadcnControllers(application)` to register all controllers.

**Controller Verification (COMPLETED)**:
- [x] All 20 controllers exist and match their components
- [x] Targets, values, and actions verified for: accordion, checkbox, dialog, toast, tooltip
- [x] Engine exposes JavaScript assets via asset paths
- [x] Importmap configuration in gem (`config/importmap.rb`)
- [x] Install generator sets up both importmap and bundler approaches
- [ ] TODO: Create integration test that verifies all controllers load in fresh Rails app

### Testing Notes
- All interactive components use Stimulus controllers
- Test keyboard navigation for accessibility
- Test disabled states render correctly
- Test mobile responsiveness

---

## Lookbook Previews Status ✅

**All 35 Components Have Previews:**
- Accordion, Alert, Alert Dialog, Aspect Ratio, Avatar
- Badge, Breadcrumb, Button, Card, Checkbox
- Collapsible, Dialog, Drawer, Dropdown Menu, Hover Card
- Input, Label, Pagination, Popover, Progress
- Radio Group, Scroll Area, Select, Separator, Sheet
- Skeleton, Slider, Switch, Table, Tabs
- Textarea, Toast, Toggle, Toggle Group, Tooltip

---

## Documentation Site Research

**Recommendation**: Two-phase approach

**Phase 1 (Immediate)**: Expand Lookbook + dummy app
- Already installed, minimal effort
- Great for developer reference
- Deploy dummy app to accessible URL

**Phase 2 (Medium-term)**: Bridgetown static site
- Ruby-native, ViewComponent plugin available
- Static output, SEO-friendly
- Can render actual shadcn-rails components
- Better for public-facing documentation

---

## Component Testing Checklist

When testing documentation pages:
1. Page loads without errors
2. Demo cards render components correctly
3. Interactive components (buttons, toggles, etc.) work
4. Code examples display properly
5. Navigation links work
6. Responsive layout works

---

## File Locations

- Documentation pages: `test/dummy/app/views/docs/`
- Code examples: `test/dummy/app/code_examples/`
- Components: `app/components/shadcn/`
- Stimulus controllers: `app/assets/javascripts/shadcn/controllers/`
- Stylesheets: `app/assets/stylesheets/shadcn/`
  - `base.css` - CSS variables, theme colors, animations
  - `components.css` - Component-specific styles (data-state, sliders, etc.)
  - `index.css` - Combined import for both files
  - `themes/*.css` - Theme presets (slate, stone, zinc, gray)
- Lookbook previews: `test/components/previews/`

---

## TypeScript Discussion

### Current State
All Stimulus controllers are written in plain JavaScript. This matches the Rails ecosystem's general approach.

### Should We Port to TypeScript?

**Arguments FOR TypeScript:**
- Better IDE support with autocomplete for targets, values, actions
- Catch type errors at compile time
- Self-documenting code with explicit types
- Modern JS ecosystem trend
- Easier for TypeScript-heavy teams to contribute

**Arguments AGAINST TypeScript:**
- Rails ecosystem predominantly uses plain JavaScript
- Adds build complexity for consumers
- Stimulus controllers are small and well-tested
- Most Rails projects use importmaps (no build step) or simple bundlers
- Would require shipping both .ts source and compiled .js

**Recommendation: Provide TypeScript Definitions Only**
- Keep source in JavaScript for maximum compatibility
- Ship `.d.ts` type definition files alongside JavaScript
- Users get IDE support without requiring TypeScript compilation
- Follow the pattern of many npm packages

**Type Definition Locations:**
```
app/assets/javascripts/shadcn/
├── index.js
├── index.d.ts          # Main type definitions
├── controllers/
│   ├── dialog_controller.js
│   ├── dialog_controller.d.ts
│   ├── tabs_controller.js
│   ├── tabs_controller.d.ts
│   └── ...
```

**Example Type Definition (dialog_controller.d.ts):**
```typescript
import { Controller } from "@hotwired/stimulus"

export default class DialogController extends Controller {
  static targets: ["trigger", "overlay", "content", "close"]
  static values: { open: { type: "Boolean", default: false } }

  triggerTarget: HTMLElement
  overlayTarget: HTMLElement
  contentTarget: HTMLElement
  closeTarget: HTMLElement
  openValue: boolean

  open(): void
  close(): void
  toggle(): void
}
```

### TODO: Type Definitions ✅
- [x] Create index.d.ts with registerShadcnControllers type
- [x] Create .d.ts files for all 20 controllers
- [x] Document TypeScript setup in README

**Created type definition files:**
- `app/assets/javascripts/shadcn/index.d.ts` - Main entry point types
- `app/assets/javascripts/shadcn/controllers/*.d.ts` - Individual controller types (20 files)

---

## Future Improvements

- [ ] Add more complex components: Command, Combobox, Date Picker
- [ ] Form builder integration
- [ ] Hotwire/Turbo integration helpers
- [ ] Animation system (CSS transitions)
- [ ] RTL support
- [x] TypeScript definitions for Stimulus controllers (completed)
- [ ] Visual regression tests with Percy or similar
- [ ] Documentation site deployment (Fly.io in progress)
