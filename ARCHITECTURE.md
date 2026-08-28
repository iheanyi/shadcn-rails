# Architecture

ViewComponent + Stimulus. No Inertia in this gem. The noun is a **component unit**, not a file.

## Usage

```bash
bundle add shadcn-rails
bin/rails generate shadcn:install
```

Unejected components render from the gem:

```erb
<%= render Shadcn::ButtonComponent.new(variant: :default) { "Click me" } %>
```

```bash
bin/rails generate shadcn:add dialog
```

That copies the whole dialog unit into the app (root, content, header, title, description, footer, ERB, Stimulus). `Shadcn::DialogContentComponent` then loads from the app. `Shadcn::ButtonComponent` still loads from the gem until someone adds `button`.

## Shape

`ComponentUnit` is the domain type. Fields: name, ruby files, templates, controllers, css sidecars, depends_on.

One table (`lib/shadcn/rails/registry.yml`) keyed by add name. `AddGenerator` and `Shadcn::Rails::Engine` both `Registry.fetch("dialog")`. There is no second list. `available_components` is `Registry.keys`, not a glob of 198 files.

`shadcn:add NAME` copies every path on that row. Skip existing files unless `--force`. A second add of a half-copied husk fills missing members.

The engine still autoloads gem components. For an ejected unit it `ignore`s those gem ruby paths so Zeitwerk does not define the constant twice. Zeitwerk does not do precedence. Ignore is the rule.

`BaseComponent`, helpers, and theme CSS stay gem kernel. Subcomponents (`dialog_content`) are not add keys.

Rails 8 with Tailwind v4 is the supported install path. Install on Rails 8 must inject the shadcn Tailwind engine bundle, which includes Tailwind v4 `@theme` (ship `tailwind-v4.css` in the gem), and pin JS deps importmap actually needs (`@floating-ui/dom`, `stimulus-use`). Tailwind v3 injection remains a fallback for existing apps. Tailwind content globs must include the gem component path so unejected classes exist in the CSS build.

LICENSE is a file, not gemspec metadata.

## Synthesis

Base is candidate C (unit registry, hybrid kept).

Grafted from B: add is a complete file graph or it has failed. Acceptance: after `add dialog`, `Shadcn::DialogContentComponent.source_location` is under the app. Stimulus utils used by a unit are listed on that unit and copied.

Grafted from A: npm `shadcn-rails-stimulus` is a version-locked republish of gem JS, not a second source of truth. Apps that need a structural fork subclass into `Ui::`, they do not leave a colliding file at `app/components/shadcn/` unless they ejected via add. Tailwind content must see gem components.

Rejected A (runtime only, delete add). The owner chose to make `shadcn:add` true.

Rejected B (eject-only, NameError until add). That kills `bundle add` then render, dummy, Lookbook, and every host that installed and never added.

Rejected keeping the Hash and adding more filenames. The engine would still not know what a unit is.

## What this slice does not do

No Inertia/React. No public shadcn registry CLI. No OKLCH migration. No a11y rewrite. No 90-day professionalize.

## Prove it

In a host app:

1. Never ran add: `render Shadcn::DialogComponent` works from the gem. Compiled CSS contains `bg-primary`.
2. `rails g shadcn:add dialog` writes the full dialog file set. `DialogContentComponent.source_location` is the app. `ButtonComponent.source_location` is still the gem.
3. LICENSE exists at the gem root. README describes this hybrid and does not claim `variant: :primary` or generators that do not exist.
