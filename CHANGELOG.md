# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2025-11-27

## [0.1.0] - 2024-11-27

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

[Unreleased]: https://github.com/iheanyi/shadcn-rails/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/iheanyi/shadcn-rails/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/iheanyi/shadcn-rails/releases/tag/v0.1.0
