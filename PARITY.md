# PARITY: verified audit vs upstream shadcn/ui, and the plan to close the gaps

*Written August 2026 against `main` at `8df2d41` ("Make advertised shadcn-rails API true") and against current upstream shadcn/ui (`shadcn-ui/ui` `apps/v4/lib/components.ts` `UI_COMPONENTS`, 60 entries, plus the live docs at ui.shadcn.com). Every claim below was checked against the tree or against upstream; where PROGRESS.md or EVALUATION.md disagree with the code, the code wins and the discrepancy is noted.*

**Scope guardrails (locked):** ViewComponent + Stimulus only. No Inertia, no React, no Radix. This document does not staff EVALUATION.md's 30/60/90-day professionalization plan; it is a component-parity and UX plan.

**Locked product decisions folded into this plan:**

- **Ship Chart, Data Table, and Direction** as real, working units — tests, dummy docs, keyboard/a11y. Not stubs.
- **Do not skip Form.** The Field + Rails form helpers path must be genuinely good (errors, hint, required, composition with Input/Select/Checkbox/Radio/Textarea/Native Select). The evidence below supports shipping a `Shadcn::FormBuilder`; see Decision 4.
- **Sonner ships only if it is a real UX upgrade over the existing Toast.** It isn't a separate thing — the upgrade is real but belongs *inside* Toast; see Decision 5.
- **Every shipped component must appear in the docs/component library**, backed by a small showcase abstraction so examples are defined once; see §5.
- Feel-test consumer is [iheanyi/shadcn-rails-phonebook PR #1](https://github.com/iheanyi/shadcn-rails-phonebook/pull/1). That repo is read-only evidence for this plan; we do not change it.

---

## 1. Verified inventory vs upstream `UI_COMPONENTS` (60 names)

Method: diffed the 60 names in upstream `UI_COMPONENTS` against `app/components/shadcn/` (198 component files, 55 families), `lib/shadcn/rails/registry.yml` (55 unit keys), and `test/dummy/app/views/docs/` (55 component pages). The three lists agree with each other exactly.

**Present: 55 of 60** — accordion, alert, alert-dialog, aspect-ratio, avatar, badge, breadcrumb, button, button-group, calendar, card, carousel, checkbox, collapsible, combobox, command, context-menu, date-picker, dialog, drawer, dropdown-menu, empty, field, hover-card, input, input-group, input-otp, item, kbd, label, menubar, native-select, navigation-menu, pagination, popover, progress, radio-group, resizable, scroll-area, select, separator, sheet, sidebar, skeleton, slider, spinner, switch, table, tabs, textarea, toast, toggle, toggle-group, tooltip, typography.

**Missing: 5 of 60** — all now have a decision (§4):

| Upstream name | Status | Decision (§4) |
|---|---|---|
| `chart` | Missing | **Ship** — Rails-native chart unit on the existing `--chart-1..5` tokens |
| `data-table` | Missing | **Ship** — server-first sortable/filterable unit on Table + Pagination |
| `direction` | Missing | **Ship** — direction component + RTL hardening pass |
| `form` | Missing | **Ship as `Shadcn::FormBuilder` + Field hardening** (the Rails translation of upstream's Form) |
| `sonner` | Missing as a named unit | **Skip the name, ship the capability** — upgrade Toast to a managed toaster (imperative API, stacking, position, swipe). No second toast component. |

**Sub-unit gaps inside "present" families (names verified against the tree):**

- `dropdown_menu` has checkbox/radio/shortcut/group items but **no `dropdown_menu_sub*` files**, and `dropdown_controller.js` has no submenu targets or behavior.
- `context_menu` likewise has **no `context_menu_sub*` files** (upstream ContextMenu has Sub/SubTrigger/SubContent).
- `menubar` is the only menu family with sub components (`menubar_sub_component.rb`, `menubar_sub_trigger_component.rb`, `menubar_sub_content_component.rb`) and working hover-open submenu logic in `menubar_controller.js` — proof the pattern is portable; it needs extraction, not invention.

**Stale-doc corrections (so nobody plans against them again):**

- PROGRESS.md says "57/59 implemented" and lists dropdown checkbox/radio items and keyboard shortcuts as TODO — they exist (`dropdown_menu_checkbox_item_component.rb`, `dropdown_menu_radio_item_component.rb`, `dropdown_menu_shortcut_component.rb`, and the controller implements them). The real dropdown gap is submenus only.
- PROGRESS.md says Toast-over-Sonner is fine because "shadcn/ui deprecated Toast in favor of Sonner." Upstream reversed this: the current Toast is Base UI-backed with an imperative `toast.add()` API, type/promise states, stacking, and swipe dismissal, and upstream lists **both** toast and sonner. Our Toast matches neither's UX today (§3.5).
- EVALUATION.md's headline code gaps (broken `shadcn:add` for compound units, missing LICENSE, no Tailwind v4 install path) were **fixed by `8df2d41`**: the unit registry (`lib/shadcn/rails/registry.yml`, 55 units with `ruby_files`/`templates`/`controllers`/`depends_on`), full-unit copy with import-path rewrite (`add_generator.rb:132-181`), Zeitwerk `ignore` for ejected units (`engine.rb:62-75`), `--list`/`--all`, MIT LICENSE, and a Tailwind v4 CSS-first install that symlinks gem CSS and pins `@floating-ui/dom`/`stimulus-use` for importmap (`install_generator.rb:121-147`, `217-234`). The remaining gaps are behavioral, not distributional.

---

## 2. Consumer evidence: what the phonebook had to work around

[shadcn-rails-phonebook PR #1](https://github.com/iheanyi/shadcn-rails-phonebook/pull/1) is a small Rails 8 Hotwire app consuming this gem. Every workaround it contains is a library UX gap:

1. **`dialog_autoshow_controller.js`** — renders an `sr-only` trigger and programmatically `.click()`s it inside `requestAnimationFrame` to open a dialog from a Turbo Frame response. There is no server-driven or programmatic open API.
2. **`dialog_deferred_clear_controller.js`** — to close a dialog from a Turbo Stream, it queries the DOM for the open dialog's close button, clicks it, then `setTimeout(220)` before clearing the frame so the close animation can finish. There is no `close()` API, no close event to await, and the animation duration is load-bearing knowledge the consumer had to discover.
3. **Manual tooltip event forwarding** — `_favorite_button.html.erb` adds `data-action="mouseover->shadcn--tooltip#show mouseout->shadcn--tooltip#hide focusin->shadcn--tooltip#show focusout->shadcn--tooltip#hide"` onto its own form. Root cause verified in the gem: the trigger wrapper listens for `focus`/`blur` (`tooltip_component.html.erb:9`), which do not bubble — so keyboard-focusing a button inside the trigger never opens the tooltip. The PR description says the same forwarding was needed for HoverCard.
4. **Toasts with `duration: 0`** — each Turbo Stream renders its own `ToastViewportComponent` + persistent toast. There is no toaster/stacking/queue, so server-driven toasts are single-shot DOM replacements.
5. **"Global Turbo Streams" for portal-rendered forms** — because dialog content is portaled by copying `template.innerHTML` to `document.body`, forms inside dialogs live outside their Turbo Frame, and the app had to route responses as global streams.

The feel-test for this plan is concrete: **when the relevant phases land, the phonebook should be able to delete both workaround controllers, all manual tooltip/hover-card event forwarding, and the `duration: 0` toast hack** — and the flows in its demo recording (dialog create/edit, delete confirm, toasts, tooltips, hover cards, dropdown actions) should feel the same or better.

---

## 3. Feature-level UX gaps on shipped components (verified in code)

Severity reflects how quickly a real app hits the gap. File references are current as of `8df2d41`.

### 3.1 Overlay engine (Dialog, Alert Dialog, Sheet, Drawer) — High

- **Portals copy `innerHTML` instead of moving nodes** (`dialog_controller.js:39`, `sheet_controller.js`, `drawer_controller.js:33`). Any Stimulus controller inside overlay content is silently disconnected in the portal; only close buttons are manually re-bound. This is the root cause of phonebook items 1, 2, and 5.
- **Sheet overlay click is dead after portaling**: the template wires `click->shadcn--sheet#close` on the overlay, but the controller re-binds only close buttons (`sheet_controller.js:47-50`).
- **No `aria-labelledby`/`aria-describedby` anywhere** (`grep` over `app/components/shadcn` is empty). `DialogTitleComponent` renders a bare `<h2>` with no id; content is never labeled by its title. Radix does this automatically; screen-reader users get an unnamed dialog.
- **Focus trap doesn't filter** disabled/hidden elements (`dialog_controller.js:148-150` matches raw `button, [href], input, ...`), and there's no `inert`/`aria-hidden` on background content.
- **Drawer has no focus trap or focus restore** (only `content.focus()` on open).
- **Alert Dialog dismisses on overlay click** (inherits dialog behavior); upstream AlertDialog deliberately does not.
- **No programmatic open/close API or lifecycle events** consumers can rely on (phonebook items 1–2).

### 3.2 Menus (Dropdown, Context Menu, Menubar) — High

- No submenus in dropdown/context menu (§1). Menubar's implementation is hover-only; ArrowRight/ArrowLeft moves between top-level menus (`menubar_controller.js` `openNextMenu`/`openPreviousMenu`), not into/out of submenus.
- No typeahead in any menu (`base_menu_controller.js` handles arrows/Home/End/Enter/Escape only). Roving focus with disabled-skip exists and works (`base_menu_controller.js:140-212`).

### 3.3 Drawer gestures — High on mobile

`drawer_controller.js`'s docstring says "with swipe support" but the file contains zero `touch*`/`pointer*` handlers — the claim is false. Open/close is click/Escape plus a 200ms CSS animation; the handle bar is decorative (`drawer_content_component.rb:70-74`). No drag-to-dismiss, no velocity, no snap points (PROGRESS.md is accurate here).

### 3.4 Sidebar mobile — High on mobile

Desktop parity is decent: cookie persistence (`sidebar:state`), Cmd/Ctrl+B shortcut, collapsible `offcanvas`/`icon` modes as data attributes (`sidebar_controller.js:4-9`, `63-71`; `sidebar_component.rb:50-54`). But there is **no mobile Sheet rendering** — the sidebar is `hidden md:block` on small screens, where upstream renders it inside a Sheet. `clickOutside` is defined but never hooked up.

### 3.5 Toast — High if you want client-side toasts, Medium otherwise

`toast_controller.js` is per-element only: auto-dismiss timer, close with 200ms animation, `pause`/`resume` methods that **no template wires up** (no mouseenter/leave actions in `toast_component.html.erb`). There is no toaster manager: no JS `toast()` API, no stacking/queue, no position config, no promise/loading states; the viewport references a `data-shadcn--toaster-target` that no registered controller consumes, and swipe-dismiss exists only as copied Radix CSS class names with no JS behind them.

### 3.6 Tooltip / Popover / Hover Card — Medium

- Tooltip: `focus`/`blur` don't bubble from inner controls (§2 item 3 — an a11y bug, keyboard users never see tooltips on wrapped controls); no Escape-to-dismiss (WCAG 1.4.13); `skipDelay` value is declared and never read (`tooltip_controller.js:14`); leaving the trigger immediately schedules hide with no grace path onto the content.
- Popover: solid (click toggle, outside click, Escape, Floating UI), but `modal: true` is a pointer-events hack with no focus trap.
- Hover Card: good delays (700/300) and content-enter cancels close; missing Escape close.

### 3.7 Select / Combobox / Command — Medium

Select is the strongest (hidden input for form submission, `role="combobox"`/listbox/option, arrows/Home/End, disabled skip) but has no typeahead and doesn't `scrollIntoView` the highlighted option. Combobox has filtering + `scrollIntoView` but highlight is CSS-class-only with no `aria-activedescendant`, and no Home/End. Command's input has no `aria-controls`/`aria-activedescendant` and the list lacks `role="listbox"` wiring.

### 3.8 Calendar / Date Picker — Medium

Calendar has real keyboard grid navigation (arrows, PageUp/Down ± Shift for year, Home/End) and `role="grid"`, but month/weekday names are hardcoded English arrays in both Ruby and JS, and day cells are plain buttons without `row`/`gridcell` semantics. **Date Picker does not reuse Calendar's keyboard navigation** — its days only get click actions (`date_picker_controller.js:258-263`), so the popover calendar is mouse-only.

### 3.9 Turbo lifecycle — High for the target audience

Zero `turbo:` handling in library JS (`grep` for `turbo` over `app/assets/javascripts/shadcn` is empty). Open portals, `body.style.overflow = "hidden"` scroll locks, and open menu state can leak into Turbo's page cache and across navigations. For a Hotwire-first library this is a defining gap, and it compounds the portal problem (§3.1).

### 3.10 Test and doc coverage on shipped behavior — Medium

- 11 controllers have no Jest suite: avatar, base_menu (indirect only), command, command_dialog, dropdown, hover_card, input_otp, scroll_area, sidebar, toast, toggle. One orphan test exists for a controller that doesn't (`clipboard_controller.test.js`).
- Dummy docs pages exist for all 55 families, but Lookbook previews cover only ~43 — missing calendar, carousel, combobox, command, context-menu, date-picker, empty, item, menubar, navigation-menu, resizable, sidebar.
- The docs layout runs the real gem JS bundle via esbuild, but the Lookbook preview layout still inlines hand-copied Stimulus controllers — a permanent drift risk and the reason previews can't be trusted as behavior evidence.
- `data-slot` attributes (upstream's per-primitive styling hooks) appear nowhere in the tree.

---

## 4. Decisions on the five missing names

### 4.1 Chart — ship (locked)

Upstream Chart is not a chart engine; it's a themed container + tooltip + legend over Recharts, and its portable value is the theming contract. The `--chart-1..5` tokens **already exist** in this repo (`base.css:87-91`, mapped in `tailwind-v4.css:91-95`) — the foundation is laid and unused.

**Shape:** `Shadcn::ChartComponent` (container that scopes chart color variables and sizing) + `ChartTooltipComponent`/`ChartLegendComponent` rendered as shadcn-styled HTML, with a `shadcn--chart` Stimulus controller wrapping **Chart.js** (canvas) configured from data attributes and using Chart.js's external-tooltip hook to drive the HTML tooltip. Chart.js over Chartkick because we need per-element control to bind our tooltip/legend markup and theme tokens (Chartkick's abstraction hides exactly the layer we're theming), and over hand-rolled SVG because "must actually work" includes resize, hover interpolation, and stacked series that are not worth rebuilding. Chart.js is an optional npm/importmap peer (pinnable, no build required), consistent with how `@floating-ui/dom` is handled. Initial scope: bar, line, area, pie/donut — the types upstream's docs lead with. Radar/radial deferred.

**Definition of working:** Ruby tests for markup/config serialization, Jest for config building + tooltip driving, docs page with the four chart types on live data, keyboard/a11y = accessible fallback (`role="img"` + label, data table fallback slot).

### 4.2 Data Table — ship (locked)

Upstream's own docs say every data table is different and hand you a TanStack recipe rather than a component. The honest Rails translation is **server-first**: sorting/filtering/pagination as URL params over Turbo, which is both more idiomatic and better UX for server-rendered data than porting a client-side grid.

**Shape:** `Shadcn::DataTableComponent` built on the existing Table family + Pagination (which already has Kaminari/will_paginate/Pagy adapters — `pagination_component.rb:21-38`): a column DSL (`with_column :name, sortable: true`), sort-link header rendering with `aria-sort` and direction indicators, a filter slot composing Input, current-sort/direction params helpers, and an empty-state slot composing Empty. A small optional Stimulus controller can provide client-side sorting for small static tables, but the primary path is params + Turbo. Ship with a full CRUD-ish docs recipe (the phonebook's contacts table is exactly the shape it must handle: search + sort + row actions + empty state).

**Definition of working:** Ruby tests for column DSL/sort-state rendering/aria-sort, docs page with a live sortable+filterable demo against seeded data, keyboard = links/buttons all natively focusable (no custom key handling needed by design).

### 4.3 Direction — ship (locked)

Upstream `direction` is a React context provider over the `dir` attribute; a context provider is not portable, but what it *enables* — components that actually work in RTL — is. Shipping a `DirectionComponent` alone would be a stub, which is exactly what the locked decision forbids.

**Shape:** three parts. (1) `Shadcn::DirectionProviderComponent` (or `shadcn_direction` helper) that sets `dir` on a wrapper + exposes the value to Stimulus controllers, with README guidance to put `dir` on `<html>`. (2) The real work: an RTL hardening pass replacing physical utilities (`ml-`/`mr-`/`left-`/`right-`/`pl-`/`pr-`) with logical ones (`ms-`/`me-`/`start-`/`end-`) across component class strings, flipping Floating UI placements when `dir="rtl"` (Floating UI supports this via the `placement` axis; our `utils/floating.js` needs to read direction), and mirroring directional icons/chevrons. (3) RTL examples in docs (upstream shows RTL sections on component pages). Scope the first pass to the components upstream demos in RTL (form controls, card/login block, dropdown, dialog, sheet, sidebar) and extend from there.

**Definition of working:** an RTL docs page rendering the login-block demo `dir="rtl"`, Ruby tests asserting logical classes on the migrated components, Jest coverage for RTL-aware Floating UI placement.

### 4.4 Form — ship the Rails-native win (locked: do not skip)

Upstream's Form component is glue: it wires labels, descriptions, error messages, and aria attributes to fields automatically (via React Hook Form). The evidence says the current Field-only path does **not** deliver that UX in Rails:

- `FieldComponent` never wires `aria-describedby` from the input to its description/error, never sets `aria-invalid`, and its `required:` flag is label-only (`field_component.rb:39-58` passes only id/name/class to the input).
- There is **zero form-builder integration in the gem** (no `FormBuilder`/`form_with` references under `app/`), so model errors are hand-extracted by every consumer — the phonebook wrote its own `contact_error` helper and per-field conditionals to do what Rails should do once.

**Shape:** two layers, both needed. (1) **Field hardening** — auto-ids on description/error, `aria-describedby`/`aria-invalid` wiring, required propagated to the control, and first-class composition for Select/Checkbox/Radio Group/Textarea/Native Select through typed slots (today only Input is typed; everything else goes through the generic `control` slot). (2) **`Shadcn::FormBuilder`** (`ActionView::Helpers::FormBuilder` subclass) so `form_with model: @contact, builder: Shadcn::FormBuilder` gives `f.field :email`, `f.select :role, ...`, `f.checkbox :favorite`, etc. — each rendering the hardened Field with label/hint/error pulled from the model (`object.errors[attr]`), required inferred from presence validators, and ids/names from Rails conventions. This is the same job upstream's `<Form>` does for RHF, translated to the idiomatic Rails abstraction. The evidence threshold for "a real form-builder win" is met: without it, every consumer re-implements error extraction (§2), and with it the phonebook's `_form.html.erb` collapses to a handful of `f.field` calls.

**Definition of working:** builder methods for all six control types with model-error/hint/required round-trips under test, a "Forms" docs page (new — the missing upstream name gets a page), and the phonebook form partial demonstrably shrinking in the feel-test.

### 4.5 Sonner — skip the name, ship the capability inside Toast (locked criteria applied)

The test was: add Sonner only if it's a real UX upgrade over the existing Toast; if it's Toast with a new name, keep Toast and say so. Verified facts: upstream now ships **both** — and its *Toast* has absorbed the Sonner-style UX (imperative `toast.add()`, success/info/warning/error/loading types, `toast.promise`, stacking, swipe dismissal, action buttons). Meanwhile our Toast has none of that (§3.5), so a "Sonner port" and a "Toast upgrade" would be the same work shipped under two names — the situation the locked criteria exist to prevent.

**Call: keep Toast as the single toast unit and upgrade it into a managed toaster.** Ship a `shadcn--toaster` controller owning the viewport (the `data-shadcn--toaster-target` hook already in the markup finally gets a consumer): a JS `toast()` API (exported from `shadcn-rails-stimulus`), stacking with a visible-count limit, position config on the viewport, wiring the existing-but-dead `pause`/`resume` on hover, swipe-to-dismiss JS behind the already-shipped Radix swipe CSS classes, action-button support (component exists), and — the Rails differentiator — a documented **Turbo Stream server API** (`turbo_stream.append` into the viewport, plus a flash-message integration example) so server-driven toasts stack instead of replacing each other. `toast.promise`-style loading states are the stretch goal, not the bar. No `SonnerComponent` will exist; the docs page for Toast gains an "upstream Sonner equivalence" note.

---

## 5. Docs and showcase abstraction (locked: every component visible, defined once)

Current state (verified): docs pages exist for all 55 families and run the real gem JS bundle; Lookbook previews cover only ~43 families and run on a layout with **hand-inlined copies of the Stimulus controllers**; code samples live in ~53 directories of `.txt` files under `test/dummy/app/code_examples/` maintained by hand alongside the demos they duplicate. Three sources of truth, drifting independently — PROGRESS.md's staleness is the predictable output of this structure.

**Proposal — one showcase source, three renderers:**

1. **Examples live in ViewComponent/Lookbook previews** (`test/components/previews/`), one preview class per family, one method per named example. Lookbook already supports this shape and the repo already has 43 of them.
2. **Docs pages embed previews instead of duplicating them.** The dummy docs render each example through the preview (ViewComponent's `render_preview` / Lookbook embeds) and display its source via extraction from the preview file — retiring the parallel `.txt` code-example tree. A small `showcase` helper (`showcase "button", :variants`) replaces today's hand-built `_demo_card` + `_code_example` pairs.
3. **The preview layout drops inline controllers** and loads the same esbuild bundle the docs layout already uses, so previews exercise the shipped JS instead of a drifting copy. (This also unblocks the CLAUDE.md-documented nested-render preview problems from being papered over with raw HTML strings.)
4. **A registry-driven parity gate in CI**: for every key in `registry.yml`, assert a docs page, a preview class, and (where a controller exists) a Jest suite. New components physically cannot ship undocumented — which operationalizes the "every shipped component shows up in the library" decision for Chart/Data Table/Direction/Forms.

This is deliberately small: no new site, no Bridgetown, no registry server. It converts existing assets into a single pipeline.

---

## 6. Sequenced plan

Ordering rationale: fix the primitives every other phase builds on first (portal/a11y/Turbo), make docs cheap to extend second (everything after must prove itself there), then land the locked ships in the order that lets each build on the previous (Forms before Data Table because the table's filter UX composes form controls; Chart and Direction last because they're self-contained). Complexity is expressed as blast radius, not calendar time. Each phase names its "UX is actually better" check — dummy docs demo plus, where applicable, a phonebook workaround that becomes deletable.

### Phase 0 — Docs/showcase foundation (§5)

- **Work:** preview layout onto the real JS bundle; previews for the 12 missing families; docs pages embed previews; retire `.txt` examples as pages migrate; registry parity gate in CI. Mark PROGRESS.md's parity sections as superseded by this document (do not rewrite EVALUATION.md).
- **Complexity:** low-risk, wide but mechanical (dummy app + previews only; zero library runtime changes).
- **Depends on:** nothing.
- **Better-UX check:** previews demonstrably run gem JS (an interactive preview like dialog works in Lookbook without inline controllers); CI fails on an undocumented registry key.

### Phase 1 — Overlay engine correctness (§3.1, §3.9)

- **Work:** moved-node portal (preserve Stimulus connections; return nodes on close) for dialog/alert-dialog/sheet/drawer; programmatic `open()`/`close()` API + dispatched lifecycle events with animation-completion semantics; auto-id `aria-labelledby`/`aria-describedby` wiring; focus-trap filtering (disabled/hidden), `inert` background; alert-dialog stops closing on overlay click; fix sheet overlay rebinding; `turbo:before-cache` cleanup across all stateful controllers (overlays, menus, tooltips, scroll locks).
- **Complexity:** highest of the plan — invasive rewrites of the four overlay controllers plus new Jest suites; behavior-compatible for existing markup.
- **Depends on:** Phase 0 (docs demos are the regression harness).
- **Better-UX check:** phonebook deletes `dialog_autoshow_controller.js` and `dialog_deferred_clear_controller.js` and stops routing dialog forms as global streams; a nested Stimulus controller (e.g. a form validation controller) works inside a portaled dialog in the docs demo; navigating away with an open dialog leaves no scroll-lock residue.

### Phase 2 — Menu completion (§3.2)

- **Work:** extract menubar's submenu behavior into shared base-menu logic; add `dropdown_menu_sub*` and `context_menu_sub*` component units (+ registry rows); keyboard submenu navigation (ArrowRight open / ArrowLeft close, Escape ancestry) for all three menu families; typeahead in `base_menu_controller`; Jest for dropdown/base_menu/command (closing the §3.10 gaps for menu surfaces).
- **Complexity:** medium-high; concentrated in base_menu + one new controller concern; new components are thin.
- **Depends on:** Phase 1 (menus inherit portal/Turbo fixes; don't build submenus on the old foundation twice).
- **Better-UX check:** docs demo with two-level dropdown and context menus fully keyboard-operable; typeahead works on the long menu demo.

### Phase 3 — Toast → managed toaster (§4.5) and Forms (§4.4)

Two independent tracks, parallelizable:

- **Toaster:** `shadcn--toaster` viewport controller, JS `toast()` API, stacking/limit, position, hover pause wiring, swipe-to-dismiss, Turbo Stream server API + flash integration docs. Keep the `Toast` name; no Sonner unit.
- **Forms:** Field a11y hardening + typed slots for the six control types; `Shadcn::FormBuilder` with model-derived errors/hints/required; "Forms" docs page.
- **Complexity:** both medium; toaster is new JS with real interaction testing needs; FormBuilder is new Ruby surface with a big test matrix but no JS.
- **Depends on:** Phase 0; Forms benefits from Phase 1's dialog fixes for the modal-form docs demo but doesn't require them.
- **Better-UX check:** phonebook drops `duration: 0` and per-render viewports — create/delete flows produce stacking, auto-dismissing, hover-pausable toasts from Turbo Streams; phonebook `_form.html.erb` rewritten as `f.field` calls with model errors appearing without helper code.

### Phase 4 — Data Table (§4.2)

- **Work:** `DataTableComponent` with column DSL, `aria-sort` sortable headers, params helpers, filter/empty slots, Pagination adapter reuse; optional client-sort Stimulus controller; full docs recipe with seeded data.
- **Complexity:** medium; composition of existing units plus a params contract worth designing carefully.
- **Depends on:** Phase 3 Forms (filter toolbar composes the hardened form controls); Phase 0 gate.
- **Better-UX check:** docs demo covers sort + filter + paginate + empty state entirely server-driven over Turbo; the phonebook contacts table is re-expressible as a DataTable with less markup than its hand-built `_contacts.html.erb`.

### Phase 5 — Chart (§4.1)

- **Work:** ChartComponent container + tooltip/legend components on the existing `--chart-1..5` tokens; `shadcn--chart` controller over Chart.js (optional peer, importmap-pinnable); bar/line/area/pie; a11y fallback slot; docs page.
- **Complexity:** medium-high; the new-dependency decision and canvas-to-HTML tooltip bridge are the risky parts, both isolated from the rest of the library.
- **Depends on:** Phase 0 only.
- **Better-UX check:** four live themed charts in docs that re-theme correctly when switching theme/dark mode in the theme playground.

### Phase 6 — Direction / RTL (§4.3)

- **Work:** DirectionProvider component/helper; logical-property migration of component class strings (scoped first pass per §4.3); RTL-aware Floating UI in `utils/floating.js`; icon mirroring; RTL docs section.
- **Complexity:** wide but shallow in Ruby class strings; subtle in JS positioning. Sequenced last deliberately: it touches most components' classes, so it lands after Phases 1–5 stop churning those same strings, and the showcase gate ensures every migrated component has a place to verify RTL rendering.
- **Depends on:** Phases 1–2 (don't migrate overlay/menu classes twice); Phase 0.
- **Better-UX check:** the RTL docs page renders the login-block and menu demos correctly in `dir="rtl"`, including dropdown placement flipping.

### Deliberately in-plan but unscheduled (next after Phase 6, order by demand)

- **Drawer gestures** (§3.3): pointer-based drag-to-dismiss with velocity; snap points only if a consumer needs them. Also delete the false "with swipe support" docstring *now* — that's a one-line honesty fix that shouldn't wait for the feature.
- **Sidebar mobile Sheet** (§3.4): render the sidebar in a Sheet below the breakpoint; depends on Phase 1's sheet fixes.
- **Tooltip/Select polish** (§3.6–3.7): focusin/focusout fix (small and high-value — could justifiably ride along with Phase 1), Escape-to-dismiss, `skipDelay`, select typeahead + scrollIntoView, `aria-activedescendant` for combobox/command.
- **Date Picker keyboard reuse of Calendar navigation**; Calendar i18n via `Intl`/locale props (§3.8).

## 7. What NOT to build

- **No Inertia, React, or Radix anything** — settled by EVALUATION.md and out of scope here.
- **No `SonnerComponent`** — the capability ships inside Toast (§4.5); two toast systems is the failure mode.
- **No client-side data grid** (TanStack-equivalent virtual scrolling, client filtering of large sets). Server-first is the Rails answer; revisit only with a concrete consumer need.
- **No chart engine of our own** — no hand-rolled SVG axis/scale/interpolation code; we theme and wrap.
- **No `Form` component that duplicates the FormBuilder** — one form abstraction, the Rails-idiomatic one.
- **No full-tree RTL migration in one shot** — scoped passes behind demos, or it becomes an unreviewable diff.
- **No OKLCH/theming migration, registry server, or community/staffing work in this plan** — EVALUATION.md territory, explicitly not staffed here.
- **No rewriting EVALUATION.md or PROGRESS.md into new plans** — PROGRESS.md's stale parity sections get a pointer to this document; history stays.

## 8. How we'll know the plan worked

1. **Inventory:** all 60 upstream names resolve to either a shipped unit (58) or a documented equivalence (form → FormBuilder page, sonner → Toast page note) — with `registry.yml`, docs, previews, and tests in lockstep via the Phase 0 CI gate.
2. **Feel test:** the phonebook runs against the upgraded gem with both workaround controllers deleted, no manual overlay event forwarding, no `duration: 0`, and its form/table partials materially smaller — verified by a follow-up PR on that repo (separate work, not part of this plan's PRs).
3. **Behavior evidence:** every phase adds Jest/Ruby tests for the behaviors it claims (no controller shipped without a suite going forward), and the docs demo for each phase is the manual regression script.
