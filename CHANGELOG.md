# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] - 2025-11-27

### Added

- **Clipboard controller** for documentation site - Copy buttons now work with "Copied!" feedback
- **Jest tests for ClipboardController** - Comprehensive test suite for copy functionality
- **Sidecar templates** for all 47 components - Each component now has its own `.html.erb` template file
- **Components page** in documentation - New `/docs/components` listing page
- **Flexible class name support** - Components now accept both `class` and `class_name` attributes

### Changed

- **Floating UI migration started** - Begun work on migrating popover/dropdown positioning to Floating UI
- **Tooltip animation polish** - Smoother entrance/exit animations
- **Generator improvements** - Updated component generators with better defaults
- **Field component updates** - Improved form field wrapper component

### Fixed

- **Copy button styling** - Fixed code block padding to prevent text overlap with Copy button
- **Select dropdown clipping** - Fixed overflow issue causing white line through dropdown borders
- **Sidebar component** - Fixed layout issues in sidebar navigation
- **OTPSeparatorComponent** - Fixed rendering issues with OTP input separators
- **Tooltip component styling** - Fixed visual styling issues
- **Dashboard layout** - Fixed layout issues in example dashboard
- **HTML escaping** - Use `escape_once` instead of `escape` to prevent double-escaping

### Documentation

- Added consistent widths to Select component examples
- Fixed Form Integration example spacing between label and select
- Updated links throughout docs to point to correct demo app URLs
- Simplified homepage navigation structure
- README updates with improved installation instructions

## [0.2.0] - 2025-11-27

### Added

- **Context Menu component** - Right-click context menus with full keyboard navigation
- **stimulus-use integration** - Added `useClickOutside` for better click-outside detection across menu components
- **BaseMenuController** - Shared base controller for menu components (DropdownMenu, ContextMenu, Menubar)
- **Polymorphic menu items** - Menu items can render as buttons, links, or custom elements
- **Two-way slider binding** - Sliders can now sync bidirectionally with input fields via `data-input-target`

### Changed

- Refactored menu controllers to use shared `BaseMenuController`
- Improved click-outside handling using stimulus-use library
- Better keyboard navigation across all menu components

### Fixed

- Combobox debouncing now works correctly
- Context menu positioning and click handling
- Radio group label click behavior
- Interleaved content rendering in menus

### Developer Experience

- New `bin/bump` script for unified version bumping (replaces `bin/bump-version`)
- New `bin/test` script to run both Ruby and JavaScript tests
- Improved gemspec to exclude development files from published gem
- Added comprehensive Jest test suite for Stimulus controllers

## [0.1.0] - 2025-11-27

### Added

- Initial release of shadcn-rails
- **40+ ViewComponents** ported from shadcn/ui:
  - Accordion, Alert, AlertDialog, AspectRatio, Avatar, Badge
  - Breadcrumb, Button, Calendar, Card, Carousel, Checkbox
  - Collapsible, Combobox, Command, ContextMenu, DatePicker
  - Dialog, Drawer, DropdownMenu, HoverCard, Input, Label
  - Menubar, Pagination, Popover, Progress, RadioGroup
  - ScrollArea, Select, Separator, Sheet, Sidebar, Skeleton
  - Slider, Switch, Tabs, Textarea, Toast, Toggle, ToggleGroup, Tooltip
- **Stimulus Controllers** for interactive components:
  - Accordion, AlertDialog, Calendar, Carousel, Checkbox, Collapsible
  - Combobox, Command, ContextMenu, Dialog, Drawer, DropdownMenu
  - HoverCard, Menubar, Popover, RadioGroup, ScrollArea, Select
  - Sheet, Sidebar, Slider, Switch, Tabs, Toast, Toggle, ToggleGroup, Tooltip
- **CSS Theming** with HSL color variables and dark mode support
- **Theme presets**: neutral, slate, stone, zinc, gray
- **Rails generators**:
  - `rails g shadcn:install` - Initial setup
  - `rails g shadcn:component [name]` - Add individual components
  - `rails g shadcn:theme [name]` - Switch color themes
- **Tailwind CSS integration** with class merging utility
- **Accessibility features** following WAI-ARIA patterns
- **npm package** (`shadcn-rails-stimulus`) for Stimulus controllers
- **Comprehensive test suite** with 500+ Ruby tests and 1100+ JavaScript tests

### Slider Controller Features

- One-way output sync via `data-output-target` and `data-output-format`
- Two-way input binding via `data-input-target` for slider/input synchronization
- CSS custom property `--slider-fill` for visual fill styling
- Support for controller attached directly to `<input type="range">` elements

### Documentation

- Full documentation site with live examples
- API reference for all components
- Accessibility guidelines
- Installation instructions for various JavaScript bundlers

[Unreleased]: https://github.com/iheanyi/shadcn-rails/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/iheanyi/shadcn-rails/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/iheanyi/shadcn-rails/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/iheanyi/shadcn-rails/releases/tag/v0.1.0
