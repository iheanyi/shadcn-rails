# PARITY: verified audit vs upstream shadcn/ui, and implementation-ready specs to close the gaps

*Written August 2026 against `main` at `8df2d41` ("Make advertised shadcn-rails API true") and against current upstream shadcn/ui (`shadcn-ui/ui` `apps/v4/lib/components.ts` `UI_COMPONENTS`, 60 entries, plus the live docs at ui.shadcn.com). Every claim was checked against the tree or against upstream; where PROGRESS.md or EVALUATION.md disagree with the code, the code wins and the discrepancy is noted. This is a plan: no component implementations ship in this PR.*

**Scope guardrails (locked):** ViewComponent + Stimulus only. No Inertia, no React, no Radix. This document does not staff EVALUATION.md's 30/60/90-day professionalization plan.

**Locked product decisions this plan implements:**

- **Ship Chart, Data Table, and Direction** as real, working units — tests, dummy docs, keyboard/a11y. Not stubs. (§P5, §P4, §P6)
- **Do not skip Form.** The Field + Rails form helpers path must be genuinely good; the evidence supports shipping a `Shadcn::FormBuilder`. (§P3b)
- **Sonner ships only if it is a real UX upgrade over the existing Toast.** Verdict: the upgrade is real but belongs *inside* Toast; no second toast unit. (§P3a)
- **Every shipped component must appear in the docs/component library**, backed by a showcase abstraction so each example is defined once. (§P0)
- Feel-test consumer is [iheanyi/shadcn-rails-phonebook PR #1](https://github.com/iheanyi/shadcn-rails-phonebook/pull/1). Read-only evidence; we do not change that repo.

**Repo conventions every spec below follows** (so "files to add" is unambiguous):

- Components: `app/components/shadcn/{name}_component.rb`, sidecar template `{name}_component.html.erb` when markup is non-trivial. All inherit `Shadcn::BaseComponent` (`cn`, `merge_classes`, `html_options`, `build_data`).
- Stimulus: `app/assets/javascripts/shadcn/controllers/{name}_controller.js`, imported/exported in `app/assets/javascripts/shadcn/index.js`, registered as `shadcn--{name}` in the `controllers` map. Shared JS in `app/assets/javascripts/shadcn/utils/`.
- Generator unit: one row per family in `lib/shadcn/rails/registry.yml` (`ruby_files`, `templates`, `controllers`, `css_sidecars`, `depends_on`). `rails g shadcn:add {name}` copies every listed path and rewrites `../utils/` imports (`add_generator.rb:132-181`).
- Tests: `test/components/{name}_component_test.rb` (ViewComponent::TestCase), `__tests__/controllers/{name}_controller.test.js` (Jest + jsdom harness).
- Docs: `test/dummy/app/views/docs/{name}.html.erb`, entry in `DocsController::COMPONENTS`, sidebar link in `layouts/docs.html.erb`, preview in `test/components/previews/{name}_component_preview.rb`.

---

## 1. Verified inventory vs upstream `UI_COMPONENTS` (60 names)

Method: diffed the 60 upstream names against `app/components/shadcn/` (198 component files, 55 families), `lib/shadcn/rails/registry.yml` (55 unit keys), and `test/dummy/app/views/docs/` (55 component pages). The three in-repo lists agree exactly.

**Present: 55/60** — accordion, alert, alert-dialog, aspect-ratio, avatar, badge, breadcrumb, button, button-group, calendar, card, carousel, checkbox, collapsible, combobox, command, context-menu, date-picker, dialog, drawer, dropdown-menu, empty, field, hover-card, input, input-group, input-otp, item, kbd, label, menubar, native-select, navigation-menu, pagination, popover, progress, radio-group, resizable, scroll-area, select, separator, sheet, sidebar, skeleton, slider, spinner, switch, table, tabs, textarea, toast, toggle, toggle-group, tooltip, typography.

**Missing: 5/60** — `chart` (§P5), `data-table` (§P4), `direction` (§P6), `form` (§P3b), `sonner` (§P3a — capability ships inside Toast, no new unit).

**Sub-unit gaps inside "present" families:** `dropdown_menu` and `context_menu` have no `*_sub*` components or controller submenu behavior; `menubar` has all three sub components and working hover submenus — the pattern needs extraction, not invention (§P2).

**Stale-doc corrections:**

- PROGRESS.md says "57/59" and lists dropdown checkbox/radio/shortcut items as TODO — they exist (`dropdown_menu_checkbox_item_component.rb`, `dropdown_menu_radio_item_component.rb`, `dropdown_menu_shortcut_component.rb`, implemented in `dropdown_controller.js`). The real dropdown gap is submenus only.
- PROGRESS.md justifies Toast-over-Sonner via "upstream deprecated Toast." Upstream reversed that: current upstream Toast is Base UI-backed with imperative `toast.add()`, type/promise states, stacking, and swipe dismissal, and upstream lists **both** toast and sonner. Our Toast matches neither's UX today.
- EVALUATION.md's headline distribution gaps were fixed by `8df2d41`: unit registry with full-unit `shadcn:add` + import rewriting + Zeitwerk `ignore` for ejected units (`engine.rb:62-75`), `--list`/`--all`, MIT LICENSE, Tailwind v4 CSS-first install with gem-CSS symlink and importmap pins (`install_generator.rb:121-147`, `217-234`). Remaining gaps are behavioral, not distributional.

---

## 2. Consumer evidence: what the phonebook had to work around

[shadcn-rails-phonebook PR #1](https://github.com/iheanyi/shadcn-rails-phonebook/pull/1) is a Rails 8 Hotwire app consuming this gem. Each workaround marks a library gap, and each is named as an acceptance criterion in the spec that fixes it:

1. **`dialog_autoshow_controller.js`** — renders an `sr-only` trigger and `.click()`s it in `requestAnimationFrame` to open a dialog from a Turbo Frame. No programmatic/server-driven open API. → §P1
2. **`dialog_deferred_clear_controller.js`** — closes a dialog from a Turbo Stream by DOM-querying the open dialog's close button, clicking it, then `setTimeout(220)` before clearing the frame so the close animation finishes. No `close()` API, no lifecycle events, animation duration is load-bearing consumer knowledge. → §P1
3. **Manual tooltip event forwarding** — `data-action="mouseover->shadcn--tooltip#show ... focusin->shadcn--tooltip#show ..."` added on the consumer's own form, because the gem trigger listens for non-bubbling `focus`/`blur` (`tooltip_component.html.erb:9`): keyboard focus on a wrapped control never opens the tooltip. Same forwarding was needed for HoverCard. → §P1
4. **Toasts with `duration: 0`**, one viewport per Turbo Stream render — no toaster, no stacking. → §P3a
5. **Global Turbo Streams for dialog forms** — dialog content is portaled via `innerHTML` copy to `document.body`, so forms inside dialogs escape their Turbo Frame. → §P1

**The feel-test:** when P1 and P3a land, the phonebook can delete both workaround controllers, all manual event forwarding, and the `duration: 0` hack, and its recorded flows (create/edit dialog, delete confirm, toasts, tooltips, hover cards, dropdown actions) feel the same or better. When P3b/P4 land, its `_form.html.erb` and `_contacts.html.erb` shrink materially. Verification happens as a follow-up PR on that repo — not in this plan's PRs.

---

## 3. Implementation specs, in build order

Ordering rationale: docs infrastructure first (every later phase must prove itself there), then the overlay/menu primitives that later units build on, then the locked ships in dependency order (Forms before Data Table because the table's filter toolbar composes form controls; Chart and Direction are self-contained; Direction last because it touches most class strings and should not race the phases that churn them). Complexity is blast radius, not calendar time.

---

### P0 — Docs/showcase abstraction

**Missing today:** three drifting sources of truth. Docs pages (55/55) hand-duplicate demos and `.txt` code samples (`test/dummy/app/code_examples/`, ~53 dirs, loaded by `docs_helper.rb#code_example_file`); Lookbook previews cover only ~43/55 families (missing: calendar, carousel, combobox, command, context_menu, date_picker, empty, item, menubar, navigation_menu, resizable, sidebar); the preview layout (`component_preview.html.erb`) hand-inlines copies of Stimulus controllers instead of loading the gem bundle, so previews don't exercise shipped JS. Nothing enforces coverage — which is how PROGRESS.md went stale.

**Implementation:**

- *Files:* `test/dummy/app/helpers/showcase_helper.rb` (new); edits to `test/dummy/app/views/layouts/component_preview.html.erb`, docs pages (incremental migration), `test/components/previews/*` (12 new preview classes); `test/docs_parity_test.rb` (new).
- *Showcase helper:* `showcase("dialog", :default)` renders the named preview example live (ViewComponent `render_preview` / Lookbook embed) inside the existing `_demo_card` chrome, and displays that example's source extracted from the preview method (Lookbook exposes preview source; fallback is a file/AST slice). One method in one preview class per example; docs pages and Lookbook both render it. `.txt` examples are deleted per page as it migrates; `docs_helper.rb` keeps `bash_example` for CLI snippets only.
- *Preview layout:* replace inline controllers + CDN Tailwind with the same esbuild bundle and gem CSS the docs layout already uses (`docs.html.erb:115` pattern). This retires the CLAUDE.md-documented "inline controllers for previews" convention.
- *Parity gate:* `test/docs_parity_test.rb` iterates `Shadcn::Rails::Registry.keys` and asserts per key: docs page exists, `DocsController::COMPONENTS` entry exists, preview class exists, and (when the unit lists controllers) a matching `__tests__/controllers/*_controller.test.js` exists. Runs in the normal Ruby suite, so CI enforces it.
- *Generator unit:* none (dummy-app only).
- *Tests:* the gate itself, plus a smoke test that renders every preview example (`ViewComponent::Preview.all` loop) so previews can't silently break.

**Dependencies & order:** first — everything after must land with a showcase entry, and the gate is what enforces "every shipped component shows up in the docs."

**How we know it works:** gate fails when a registry key lacks docs/preview/Jest (verify by deleting one temporarily in a branch); the dialog preview opens/closes in Lookbook with no inline JS in the layout; a migrated docs page renders the identical example Lookbook does, with source shown from the same file.

---

### P1 — Overlay engine: Dialog, Alert Dialog, Sheet, Drawer (+ Tooltip/Hover Card fixes)

**Missing vs upstream (Radix Dialog/AlertDialog + Vaul-minus-gestures):**

- *API:* no programmatic `open()`/`close()` contract, no lifecycle events (`phonebook` items 1–2). Radix exposes controlled open state and `onOpenChange`.
- *Behavior:* portal copies `template.innerHTML` to `document.body` (`dialog_controller.js:39`, `sheet_controller.js`, `drawer_controller.js:33`) — nested Stimulus controllers inside overlay content never connect in the portal; only close buttons are re-bound; sheet's overlay-click close is dead after portaling (`sheet_controller.js:47-50` re-binds close buttons only). Alert Dialog closes on overlay click (Radix AlertDialog does not). Zero `turbo:` lifecycle handling in library JS — open portals and `body.style.overflow` locks leak into Turbo's page cache.
- *A11y:* no `aria-labelledby`/`aria-describedby` anywhere (grep is empty; `DialogTitleComponent` renders a bare `<h2>`, no id); focus trap doesn't filter disabled/hidden nodes (`dialog_controller.js:148-150`); no `inert`/`aria-hidden` on background; drawer has no trap or focus restore at all.
- *Motion:* close animations exist (`components.css:372-387` `data-state` keyframes) but removal is a hardcoded `setTimeout(200)` — consumers must know the duration (phonebook item 2).

**Implementation:**

- *Approach — native `<dialog>` top layer instead of portals.* Content components (`dialog_content_component.rb`, `alert_dialog_content_component.rb`, `sheet_content_component.rb`, `drawer_content_component.rb`) render a `<dialog>` element instead of a `<template>` + portal. `showModal()` gives: top-layer stacking (the entire reason portals exist — with **no DOM moves, so nested Stimulus controllers just work**, killing phonebook items 1/2/5 at the root), background inertness for free, and native Escape semantics. The overlay `<div>` is replaced by `::backdrop` styling. Fallback if `<dialog>` proves too constraining for a case (none anticipated; drawers/sheets are fine in top layer): a moved-node portal util (`utils/portal.js`) that relocates real nodes with a placeholder comment and restores on close — never `innerHTML`.
- *Files:* rewrite `dialog_controller.js`, `sheet_controller.js`, `drawer_controller.js`; new `app/assets/javascripts/shadcn/utils/overlay.js` (shared show/hide/animation/event logic used by all three); template + content-component edits per family; `components.css` gains `::backdrop` rules mirroring `.shadcn-overlay` and keeps `data-state` keyframes.
- *Controller contract (all overlays):* values `open`, `dismissible` (Alert Dialog renders `dismissible: false` from `alert_dialog_component.rb`, disabling backdrop-click and Escape-cancel-through); methods `open()`/`close()` public and idempotent; events `shadcn--dialog:open`, `:opened`, `:close`, `:closed` (the `*ed` pair fires after animation, detected via `animationend`/`transitionend` with a duration-parse fallback — no magic 200ms). Backdrop click = `click` where `event.target === dialogEl` when dismissible. Focus: filter trap/initial-focus queries with `:not(:disabled)`, `[hidden]`, `aria-hidden`, and visibility checks (shared helper in `utils/overlay.js`); restore `previousActiveElement` on close (extend to drawer, which lacks it).
- *A11y wiring (Ruby side):* content components accept/generate a stable `@id`; slot lambdas pass derived ids down — `renders_one :title, ->(**o) { DialogTitleComponent.new(id: "#{@id}-title", **o) }`, same for description; content sets `aria-labelledby`/`aria-describedby` to those ids (omitting absent slots). Mirror in alert dialog, sheet, drawer header components.
- *Server-driven open:* document (and test) the two idioms the phonebook needed: render with `open: true` (already a value; now works because `openValueChanged` → `showModal()` on connect) for Turbo Frame responses, and `dialog.close()` reachable via a rendered `<button data-action="shadcn--dialog#close">` or a one-line Stimulus call — plus the `:closed` event to sequence frame clearing.
- *Turbo lifecycle:* `registerShadcnControllers` installs a single `turbo:before-cache` listener; overlay controllers register open instances in a module-level `Set`; the listener closes them instantly (skip animation), clears scroll locks, and cancels toaster timers (§P3a hooks in here too).
- *Tooltip/Hover Card fixes (small, same review area):* template swaps `focus->`/`blur->` for `focusin->`/`focusout->` (the phonebook bug); Escape-to-dismiss while open (WCAG 1.4.13); implement `skipDelay` (module-level `lastHideAt`; show instantly if within `skipDelayValue`); `pointerenter` on tooltip content cancels the pending hide (hover bridging). Hover Card gets Escape close.
- *Generator unit:* no registry changes — same file paths per unit (dialog/alert_dialog/sheet/drawer/tooltip/hover_card rows already list them).
- *Tests:* Jest — rewrite dialog/sheet/drawer suites for: open/close events (incl. `*ed` after animation), nested-controller survival (register a dummy controller inside content, assert `connect()` fires while open), backdrop-click matrix (dialog yes / alert-dialog no), Escape matrix, focus filtering (disabled button skipped), focus restore, `turbo:before-cache` teardown, `open: true` on connect. Ruby — id/aria wiring for all four families' title/description slots.
- *Docs/showcase:* dialog/alert-dialog/sheet/drawer pages gain "Open from the server (Turbo)" examples and updated Accessibility sections (name/description wiring); tooltip page documents keyboard behavior and skip-delay.

**Dependencies & order:** after P0 (docs demos are the regression harness). Everything later builds on this engine — do it before menus and toaster.

**How we know it works:** the four Jest suites above pass; a docs demo places a live Stimulus controller (e.g. a character counter) inside a dialog and it works; axe-core on the dialog docs page reports an accessible name and description for the dialog; **feel:** phonebook deletes `dialog_autoshow_controller.js` and `dialog_deferred_clear_controller.js`, drops global-stream routing for dialog forms, removes all tooltip/hover-card event forwarding — flows unchanged or smoother.

---

### P2 — Menu completion: Dropdown/Context submenus + typeahead

**Missing vs upstream (Radix DropdownMenu/ContextMenu):**

- *API:* no `DropdownMenuSub`/`SubTrigger`/`SubContent` or `ContextMenuSub*` components. Menubar has the trio (`menubar_sub_component.rb` etc.) with hover-open/close-timer/positioning in `menubar_controller.js:158-175` — proof of pattern.
- *Behavior:* no submenu open on hover or ArrowRight, no close on ArrowLeft; menubar's ArrowLeft/Right moves between *top-level* menus only. No typeahead in any menu (`base_menu_controller.js` handles arrows/Home/End/Enter/Escape only; roving focus + disabled-skip already work, `base_menu_controller.js:140-212`).
- *A11y:* sub triggers need `aria-haspopup="menu"`/`aria-expanded` (menubar's sub trigger already models this, `menubar_sub_trigger_component.rb:44-52`).
- *Motion:* submenu `data-state` open/close animations — CSS already covers menu content states; submenus reuse it.

**Implementation:**

- *Files:* new `app/components/shadcn/dropdown_menu_sub_component.rb`, `dropdown_menu_sub_trigger_component.rb`, `dropdown_menu_sub_content_component.rb`; same trio for `context_menu_*`; edits to `base_menu_controller.js` (submenu + typeahead), `menubar_controller.js` (refactor to shared logic + keyboard submenu nav), `dropdown_menu_content_component.rb`/`context_menu_content_component.rb` (register `with_sub` slot).
- *Slot shape (mirrors menubar's existing API exactly):* `MenubarSubComponent`'s shape is the template — `renders_one :trigger` (SubTrigger with chevron, `role="menuitem"`, `aria-haspopup="menu"`, `aria-expanded`, `data-state`), `renders_one :content_slot` aliased `with_content` (SubContent, `role="menu"`, hidden, `data-state="closed"`). Content components add `renders_many`-compatible polymorphic registration alongside existing `with_item`/`with_checkbox_item`/etc. so authoring reads: `content.with_sub do |sub| sub.with_trigger { "Share" }; sub.with_content do |c| c.with_item { "Email" } end end`.
- *Stimulus:* move menubar's `openSub`/`closeSub`/close-timer/positioning into `base_menu_controller.js` with targets `sub`, `subTrigger`, `subContent` (dropdown and context menu controllers extend base and inherit it; menubar keeps its own top-level strip logic but delegates sub behavior to the shared code). Positioning via existing `positionFloating` with `placement: right-start` + `flip` (RTL-aware after §P6). Keyboard: ArrowRight on a focused sub trigger opens and focuses first enabled item; ArrowLeft inside sub content closes and refocuses the trigger; Escape closes the whole tree. Typeahead in base menu: 500ms rolling buffer, prefix-match on `textContent` of `enabledItems`, wrap-around search from the focused item — shared by dropdown/context/menubar (extract `utils/typeahead.js`; Select reuses it in §P8).
- *Generator unit:* append the six new ruby files to the `dropdown_menu` and `context_menu` rows in `registry.yml`.
- *Tests:* Jest — new `dropdown_controller.test.js` (currently missing entirely — the most complex controller has no suite) + base-menu submenu suite (hover open, timer close, ArrowRight/ArrowLeft/Escape, focus placement) + typeahead suite. Ruby — sub trio components: roles, aria, data-state, chevron, slot composition.
- *Docs/showcase:* dropdown-menu and context-menu pages gain a submenu example (upstream's "Share → Email/Message" shape) and a long-menu typeahead demo; previews updated (context_menu preview is one of the 12 new ones from P0).

**Dependencies & order:** after P1 (menus inherit the Turbo cleanup and shouldn't be rebuilt on the old base twice). Before P4 (Data Table row-action menus may want submenus).

**How we know it works:** Jest suites above; docs demo with a two-level dropdown and context menu fully keyboard-operable (recorded once for the PR); typeahead jumps focus in the long-menu demo; **feel:** phonebook's row-actions dropdown gains nothing it must change — regression check only.

---

### P3a — Toast → managed toaster (the Sonner answer)

**Missing vs upstream (current upstream Toast has absorbed Sonner's UX; both exist upstream):**

- *API:* no imperative JS `toast()` — upstream has `toast.add({title, description, type, actionProps})`, `toast.close(id)`, `toast.promise(...)`. Ours is server-rendered-only.
- *Behavior:* no toaster manager — no stacking/queue/visible-limit, no position config; `data-shadcn--toaster-target="viewport"` exists in `toast_viewport_component.rb:9` but **no toaster controller is registered** in `index.js`; `pause`/`resume` exist on the controller but no template wires them; each Turbo Stream render replaces rather than appends (phonebook item 4).
- *Motion:* swipe-to-dismiss exists only as copied Radix CSS class names — zero swipe JS.
- *A11y:* viewport should be `role="region"` + `aria-label`, toasts `role="status"`/`aria-live="polite"` (destructive: `assertive`).

**Verdict against the locked criteria:** a separate `SonnerComponent` would duplicate this exact work under a second name — **keep Toast as the single unit, ship the toaster inside it.** The Toast docs page gets an explicit "Sonner equivalence" note.

**Implementation:**

- *Files:* new `app/components/shadcn/toaster_component.rb` (+ sidecar template), new `app/assets/javascripts/shadcn/controllers/toaster_controller.js` (registered `shadcn--toaster`), new export `toast` in `index.js`; edits to `toast_component.html.erb` (wire `mouseenter->shadcn--toast#pause mouseleave->shadcn--toast#resume`, add swipe targets/actions, `role="status"`), `toast_viewport_component.rb` (region role/label), optional `lib/shadcn/rails/helpers/toast_helper.rb`.
- *`ToasterComponent`:* rendered once in the layout (documented like upstream's `<Toaster />`): wraps `ToastViewportComponent` with stable `id: "shadcn-toaster"`, `data-controller="shadcn--toaster"`, `position:` param (`:bottom_right` default; class map for the six positions), `limit:` value (default 3), and a `<template data-shadcn--toaster-target="template">` containing blank toast markup (title/description/action slots) for client-side clones.
- *JS API:* `toast({ title, description, variant, duration, action: {label, onClick} })` exported from `shadcn-rails-stimulus`; resolves the toaster controller via `document.getElementById("shadcn-toaster")` + Stimulus `getControllerForElementAndIdentifier`; returns an id; `toast.dismiss(id)` closes. Stacking: append to viewport, enforce `limit` by queueing overflow; existing per-toast `shadcn--toast` controller keeps ownership of timers/close animation.
- *Server API (the Rails differentiator):* documented Turbo Stream idiom — `turbo_stream.append "shadcn-toaster-viewport"` rendering `Shadcn::ToastComponent` — plus a flash-integration example (layout snippet turning `flash` into toasts). Appending into a persistent viewport is what makes server toasts stack instead of replace.
- *Swipe:* pointerdown/move/up on the toast root driving the already-shipped `--radix-toast-swipe-move-x` CSS vars and `data-swipe` states; dismiss past 50% width or velocity threshold, else snap back.
- *Stretch (not the bar):* `toast.promise(promise, {loading, success, error})` updating one toast element through states.
- *Generator unit:* `toast` row in `registry.yml` gains `toaster_component.rb` (+ template) and `toaster_controller.js`.
- *Tests:* Jest — new `toaster_controller.test.js` (add/stack/limit/queue/position/dismiss-by-id) and `toast_controller.test.js` (currently missing: timer, pause/resume, close animation, swipe threshold). Ruby — ToasterComponent markup (id, role, position classes, template presence).
- *Docs/showcase:* Toast page rewritten: JS API, Turbo Stream recipe, flash integration, positions, the Sonner note. Showcase entries for stacking and action toasts.

**Dependencies & order:** after P1 (shares the `turbo:before-cache` registry for timer cleanup). Parallel with P3b — no shared files.

**How we know it works:** Jest suites above; docs demo fires 5 toasts and shows limit/queue behavior; **feel:** phonebook deletes `duration: 0` and its per-render viewport partial — create/edit/delete each produce stacking, auto-dismissing, hover-pausable toasts from plain `turbo_stream.append`.

---

### P3b — Form UX: Field hardening + `Shadcn::FormBuilder`

**Missing vs upstream (`form` — RHF glue that auto-wires label/description/error/aria):**

- *A11y:* `FieldComponent` never emits `aria-describedby` (input → description/error), never sets `aria-invalid`, and `required:` only styles the label — nothing reaches the control (`field_component.rb:39-58` passes only id/name/class to `InputComponent`).
- *API:* only Input is a typed slot; Select/Checkbox/Radio Group/Textarea/Native Select go through the untyped `control` slot with no id/name/error plumbing. No model integration anywhere in the gem (no `FormBuilder`, no `form_with` references under `app/`) — the phonebook hand-wrote `contact_error` and per-field conditionals.
- *Behavior:* no error auto-detection from an ActiveModel object; no required inference from validators.

**Form-builder recommendation (evidence-based, per the locked ask):** the builder is justified — without it every consumer re-implements error extraction (§2), and it is the exact Rails analogue of the job upstream's `<Form>` does for React Hook Form. Ship both layers below; the builder is additive, the Field hardening benefits non-builder users too.

**Implementation:**

- *Files:* edit `app/components/shadcn/field_component.rb`; new `lib/shadcn/rails/form_builder.rb` (+ `lib/shadcn/rails/helpers/form_helper.rb` for `shadcn_form_with`); require from `lib/shadcn/rails.rb`.
- *Field hardening (slot shape):* keep `with_label`/`with_description`/`with_error`/`with_control`; add typed slots mirroring `with_input`'s lambda pattern — `with_textarea`, `with_select` (→ `SelectComponent`), `with_native_select`, `with_checkbox`, `with_radio_group` — each receiving derived `id`/`name`, error state, and `required`. Auto-ids: description renders with `id="#{@input_id}-description"`, error with `id="#{@input_id}-error"`; every typed control gets `aria-describedby` (space-joined present ids), `aria-invalid: "true"` when error present, and `required` when flagged. Error keeps `role="alert"`.
- *`Shadcn::FormBuilder < ActionView::Helpers::FormBuilder`:* one core method — `field(attribute, as: :input, label: nil, hint: nil, required: nil, **control_options)` — rendering `FieldComponent` with: label from `object.class.human_attribute_name(attribute)`, error from `object.errors[attribute].first`, hint via `hint:`, required inferred from `validators_on(attribute).any?(PresenceValidator)` unless overridden, id/name from Rails conventions (`field_id`/`field_name`). `as:` selects the typed slot (`:input`, `:textarea`, `:select`, `:native_select`, `:checkbox`, `:radio_group`); per-type conveniences (`f.field :role, as: :select, options: [...]`) delegate to the components' existing option APIs. `shadcn_form_with(model:, **)` = `form_with(model:, builder: Shadcn::FormBuilder, **)`.
- *Generator unit:* `field` row unchanged (same files). The builder is gem kernel (like `BaseComponent`) — not an add key; ARCHITECTURE.md's kernel note extends to it. `registry.yml` untouched except a docs cross-link.
- *Tests:* Ruby — Field aria matrix (describedby joins, invalid, required, per typed slot); FormBuilder against an ActiveModel test class: all six `as:` types round-trip label/error/hint/required; error styling propagates; ids match Rails conventions.
- *Docs/showcase:* new `docs/forms.html.erb` page (+ sidebar + `COMPONENTS` entry) — the missing upstream name gets a page: model-backed form, validation errors, every control type, `shadcn_form_with`. Field page updated for typed slots. Showcase preview `form_preview.rb` with an in-memory ActiveModel.

**Dependencies & order:** after P0; independent of P1/P2/P3a (parallel-safe). Before P4 (Data Table's filter toolbar composes these controls).

**How we know it works:** the Ruby matrices above; axe-core on the forms docs page (every control labeled, errors announced); **feel:** phonebook `_form.html.erb` re-expressed as `shadcn_form_with` + `f.field` calls with zero hand-written error extraction, submitting inside the P1 dialog.

---

### P4 — Data Table

**Missing vs upstream:** upstream `data-table` is explicitly a recipe (TanStack Table + their Table primitives — sorting, filtering, column visibility, pagination, row selection), not a packaged component; its docs say every data table is bespoke. We ship the Rails translation: a **server-first** unit where sort/filter/pagination are URL params over Turbo — more idiomatic and honest than porting a client grid.

**Implementation:**

- *Files:* new `app/components/shadcn/data_table_component.rb` (+ sidecar template), `data_table_column_component.rb`; new `lib/shadcn/rails/helpers/data_table_helper.rb` (sort-URL building, direction cycling asc → desc → none, param preservation); optional new `data_table_controller.js` (client-side sort for small static tables — progressive enhancement, explicitly secondary).
- *Slot shape:*

  ```erb
  <%= render Shadcn::DataTableComponent.new(rows: @contacts, sort: params[:sort], dir: params[:dir]) do |table| %>
    <% table.with_toolbar do %>   <%# filter form: Input, Select, etc. (P3b controls) %>
    <% table.with_column(:name, sortable: true) do |contact| %> ... <% end %>
    <% table.with_column(:email, sortable: true) %>
    <% table.with_column(:actions, align: :end) do |contact| %> ... row dropdown ... <% end %>
    <% table.with_empty_state do %> <%# composes EmptyComponent %> <% end %>
    <% table.with_footer do %> <%= render Shadcn::PaginationComponent.new(pagy: @pagy) %> <% end %>
  <% end %>
  ```

  Internally composes the existing Table family (`TableComponent`, `TableHeadComponent`, rows/cells) — no new table CSS. Sortable headers render as links preserving other query params, with `aria-sort` (`ascending`/`descending`/`none`) and a direction indicator; column blocks receive the row object; default cell renders `row.public_send(key)`.
- *Behavior:* sorting/filtering happen in the host controller (documented recipe: safe-list sortable keys, `order(...)`, `where(...)`, paginate with Kaminari/Pagy — the Pagination component already has those adapters, `pagination_component.rb:21-38`). Empty state renders when `rows.empty?`. Turbo handles the round-trip; no JS required on the primary path.
- *A11y/keyboard:* by construction — headers are real links, toolbar is a real form, actions are the existing menu components; `aria-sort` is the only custom attribute. No custom key handling to test or break.
- *Generator unit:* new `data_table` row (2 ruby files + template + helper note; controller listed only if the optional client-sort ships). Add-time dependency on the `table` unit: extend `depends_on` semantics so a unit may reference another unit key and `AddGenerator` recursively copies it (small, tested generator change — today `depends_on` only lists JS utils).
- *Tests:* Ruby — column DSL rendering, `aria-sort` tri-state, sort-URL cycling + param preservation, block cells, empty state, footer slot; generator test for recursive `depends_on`. Jest only if the optional controller ships.
- *Docs/showcase:* `docs/data-table.html.erb` with a live seeded demo (search + sort + paginate + empty state, fully server-driven), the host-controller recipe as a code example, and Kaminari/Pagy variants.

**Dependencies & order:** after P3b (toolbar composes hardened form controls) and P2 (row-action menus); after P0's gate so it cannot land undocumented.

**How we know it works:** Ruby suite above; docs demo round-trips sort/filter/pagination over Turbo with correct `aria-sort` at each state; **feel:** phonebook's `_contacts.html.erb` (search + sort + row actions + empty state) is re-expressible as a DataTable with materially less markup.

---

### P5 — Chart

**Missing vs upstream:** the entire family. Upstream Chart is not an engine — it's `ChartContainer`/`ChartTooltip`/`ChartLegend` theming over Recharts, driven by a config that maps series → label/color and injects `--color-{series}` CSS vars. The portable part is that theming contract; the repo already ships its half: `--chart-1..5` in `base.css:87-91`, mapped to Tailwind in `tailwind-v4.css:91-95` — currently unused.

**Engine decision:** wrap **Chart.js** (canvas) via Stimulus. Over Chartkick because we need the external-tooltip/legend hooks to bind our own shadcn-styled HTML (Chartkick abstracts away exactly that layer); over hand-rolled SVG because resize/hover/stacking are not worth rebuilding ("must actually work" includes them). Chart.js is an optional peer: importmap-pinnable, no build step, dynamic-imported so apps without charts pay nothing.

**Implementation:**

- *Files:* new `app/components/shadcn/chart_component.rb` (+ sidecar), `chart_tooltip_component.rb`, `chart_legend_component.rb`; new `chart_controller.js` (registered `shadcn--chart`) + `app/assets/javascripts/shadcn/utils/chart_config.js` (pure config-building functions, extracted for Jest); `components.css` gains `.shadcn-chart` sizing/tooltip rules.
- *Slot/API shape:*

  ```erb
  <%= render Shadcn::ChartComponent.new(
        type: :bar, data: @monthly,                     # rows: [{month: "Jan", desktop: 186, mobile: 80}, ...]
        config: { desktop: { label: "Desktop", color: "var(--chart-1)" },
                  mobile:  { label: "Mobile",  color: "var(--chart-2)" } }) do |chart| %>
    <% chart.with_fallback do %> <%# visually-hidden data table for AT %> <% end %>
  <% end %>
  ```

  Container renders a `role="img"` + `aria-label` div with inline `--color-{series}` vars (upstream's convention), a `<canvas>`, tooltip/legend targets, and serialized `type`/`data`/`config` as Stimulus values. `renders_one :fallback` (encouraged in docs; the a11y answer).
- *Stimulus:* `connect()` dynamic-imports `chart.js/auto` (actionable console error naming the pin command if absent); builds config via `chart_config.js` — colors resolved from CSS vars with `getComputedStyle` so theme/dark-mode tokens apply; Chart.js's built-in legend/tooltip disabled; external-tooltip handler writes into `ChartTooltipComponent`'s target (shadcn-styled: indicator dot per series, label, value); legend rendered from config into the legend target. Re-render on dark-mode class flips (MutationObserver on `<html>`) and destroy on `disconnect`/`turbo:before-cache`.
- *Scope:* bar, line, area, pie/donut (upstream's lead types). Radar/radial deferred and said so in docs.
- *Generator unit:* new `chart` row (3 ruby files + template + controller + `utils/chart_config.js` in `depends_on`); `AddGenerator`'s post-install message prints the Chart.js pin/npm instruction.
- *Tests:* Ruby — container serialization, per-series CSS var injection, aria-label, fallback slot. Jest — `chart_config.js` pure functions per chart type, CSS-var color resolution (mocked `getComputedStyle`), tooltip-model → HTML mapping.
- *Docs/showcase:* `docs/chart.html.erb` with the four types on live data, a theming section (tokens + dark mode), the a11y fallback pattern, and install instructions per bundler; theme-playground link so re-theming is demonstrable.

**Dependencies & order:** after P0 only — self-contained. Sequenced after P4 because Data Table has a consumer waiting (phonebook) and Chart doesn't.

**How we know it works:** Jest + Ruby suites above; docs page re-themes all four charts when toggling dark mode / theme playground values; screen reader gets the label + fallback table; **feel:** n/a for phonebook (no charts) — the docs demo is the feel-test, per the showcase gate.

---

### P6 — Direction / RTL

**Missing vs upstream:** upstream `direction` is a React context provider (`DirectionProvider` + `useDirection`) over the `dir` attribute, and upstream component pages show RTL sections. A context provider is not portable; what it *enables* — components that actually render and position correctly in RTL — is. A `DirectionComponent` alone would be a stub, which the locked decision forbids; the real deliverable is the RTL hardening pass.

**Implementation:**

- *Files:* new `app/components/shadcn/direction_provider_component.rb`; edits to `app/assets/javascripts/shadcn/utils/floating.js` (RTL-aware placement); class-string edits across the first-pass component list (below); docs page + RTL examples.
- *Provider shape:* `Shadcn::DirectionProviderComponent.new(direction: :rtl)` renders a `dir`-attributed wrapper; README documents putting `dir` on `<html>` as the primary idiom. JS reads direction per-element: `utils/floating.js` gains `resolveDir(el) = el.closest("[dir]")?.dir || document.documentElement.dir || "ltr"`.
- *Positioning:* `positionFloating`/`positionAtPoint` flip physical placements (`left`↔`right`, and `-start`/`-end` alignment on top/bottom placements) when `resolveDir(reference) === "rtl"` before calling `computePosition`. Submenus (P2) and selects inherit it because they share the util.
- *Class migration (wide but mechanical):* physical → logical utilities in component `BASE_CLASSES`/variant strings — `ml-`→`ms-`, `mr-`→`me-`, `pl-`→`ps-`, `pr-`→`pe-`, `left-`→`start-`, `right-`→`end-`, `text-left`→`text-start`, `rounded-l*`→`rounded-s*`; directional chevrons/arrows get `rtl:rotate-180` (or logical icon swap) where they encode direction. Sheet/drawer `side:` params keep physical names (they mean physical screen edges) — documented explicitly.
- *First pass scope (matches upstream's RTL demo surface):* button, input, textarea, label, field, card, checkbox, radio group, switch, select, dropdown/context/menubar (chevrons + `ms-auto` shortcuts), dialog/sheet (close-button corner), sidebar. Remaining families migrate in follow-up passes behind the same tests.
- *Generator unit:* new `direction` row (1 ruby file; no controller, no template). Registry `css_sidecars` stays empty.
- *Tests:* Ruby — provider renders `dir`; migrated components assert logical classes (regression-lock the migration). Jest — floating placement flip matrix under `dir="rtl"`.
- *Docs/showcase:* `docs/direction.html.erb` with a `dir` toggle rendering the upstream-style login block, a dropdown, and a dialog in RTL; RTL notes added to migrated components' pages (showcase entries render both directions).

**Dependencies & order:** last of the numbered phases, deliberately — it touches most component class strings and must not race P1/P2's churn of those same strings; depends on P2's shared floating util for submenu flipping.

**How we know it works:** the class-assertion suite + placement-flip Jest matrix; the RTL docs page renders mirrored layouts with dropdowns opening to the correct side under `dir="rtl"`; **feel:** docs-based (phonebook is LTR) — the RTL login-block demo is the acceptance artifact.

---

### P7 — Mobile/pointer UX: Drawer gestures + Sidebar mobile sheet

**Missing vs upstream (Vaul; shadcn Sidebar):**

- *Drawer:* `drawer_controller.js`'s docstring claims "with swipe support" — **false**: zero `touch*`/`pointer*` handlers; open/close is click/Escape + a 200ms timeout; the handle bar is decorative (`drawer_content_component.rb:70-74`). Vaul provides drag-to-dismiss with velocity, overlay fade proportional to drag, scroll coordination, and snap points. *Fix the docstring lie immediately — a one-line honesty edit that should not wait for this phase.*
- *Sidebar:* desktop parity is decent (cookie `sidebar:state`, Cmd/Ctrl+B, `offcanvas`/`icon` modes — `sidebar_controller.js:4-9,63-71`, `sidebar_component.rb:50-54`) but there is **no mobile rendering at all** (`hidden md:block`); upstream renders the sidebar in a Sheet below the breakpoint. `clickOutside` is defined but never wired; `SIDEBAR_WIDTH*` JS constants are dead.

**Implementation:**

- *Drawer files/behavior:* edit `drawer_controller.js` + `drawer_content_component.rb`. Handle becomes `data-shadcn--drawer-target="handle"` with `touch-action: none`; content gets `pointerdown` (on handle always; on body only when content `scrollTop === 0` for bottom drawers — the scroll-coordination rule) → track `pointermove` displacement along the drawer axis, apply inline `transform` with transitions suppressed via a `data-dragging` attribute (CSS: `.shadcn-drawer-content[data-dragging] { transition: none }`), fade overlay proportionally; `pointerup` dismisses when displacement > 25% of the panel or velocity > ~0.5 px/ms, else snaps back by clearing the transform with transitions restored. Also add the P1 focus trap/restore drawer never had. `snap_points:` (array-of-fractions value) is specced as the follow-up flag, not v1.
- *Sidebar files/behavior:* edit `sidebar_component.rb` (+ template) to render a mobile branch — the sidebar content inside sheet-style top-layer markup (reuses P1's `<dialog>` overlay engine; side from the sidebar's `side` param; width `--sidebar-width-mobile: 18rem`) shown below the `md` breakpoint; `sidebar_controller.js`'s existing `openMobile` value drives it (`toggle()` already branches on `isMobileValue`). Wire `useClickOutside` for offcanvas desktop mode or delete the dead method; delete or use the dead width constants.
- *Generator unit:* no registry changes (same files per unit).
- *Tests:* Jest — new `sidebar_controller.test.js` (currently missing: cookie, shortcut, mobile toggle) and drawer drag suite (synthetic PointerEvents: below-threshold snap-back, past-threshold dismiss, velocity dismiss, scroll-coordination guard). Ruby — sidebar mobile branch markup; drawer handle target.
- *Docs/showcase:* drawer page gains a gesture note + mobile-viewport demo instructions; sidebar page gains a mobile section; both preview classes (sidebar is among P0's 12 new ones) get mobile examples.

**Dependencies & order:** after P1 (sidebar's mobile sheet is built on the new overlay engine; drawer inherits its focus/lifecycle work). Independent of P3–P6; can interleave.

**How we know it works:** the two Jest suites; device-emulation check on docs (drawer drags and dismisses with velocity; sidebar opens as a sheet on a small viewport); **feel:** the phonebook demo's skipped mobile pass (PR #1 skipped it as optional) becomes viable.

---

### P8 — Selection & date polish + coverage backfill

**Missing vs upstream (Radix Select/Combobox/cmdk; react-day-picker):**

- *Select:* no typeahead; highlighted option not scrolled into view; roving focus without `aria-activedescendant`. (Hidden input, combobox/listbox/option roles, arrows/Home/End, disabled-skip already work.)
- *Combobox:* highlight is CSS-class-only — no `aria-activedescendant`/`aria-selected`; no Home/End.
- *Command:* list lacks `role="listbox"`; input lacks `aria-controls`/`aria-activedescendant`.
- *Calendar/Date Picker:* Calendar has real grid keyboard nav but English-only hardcoded month/weekday names (Ruby and JS) and plain-button day cells (no `row`/`gridcell`); **Date Picker doesn't reuse Calendar's keyboard nav** — days are click-only (`date_picker_controller.js:258-263`).
- *Coverage:* controllers with no Jest suite after P2/P3a/P7 close their share: avatar, command, command_dialog, hover_card, input_otp, scroll_area, toggle; plus the orphan `clipboard_controller.test.js` (tests a controller that doesn't exist — delete it or ship the controller; decide by whether copy-to-clipboard docs examples want it).

**Implementation:**

- *Files:* edits to `select_controller.js` (+`utils/typeahead.js` from P2, `scrollIntoView({block:"nearest"})` on highlight, optional `aria-activedescendant` mode), `combobox_controller.js` (activedescendant + `aria-selected` + Home/End), `command_controller.js` + `command_list_component.rb`/`command_input_component.rb` (listbox role, `aria-controls`, activedescendant), `date_picker_controller.js` + `date_picker_component.rb` (embed `CalendarComponent`/controller instead of duplicating a private grid — the refactor that makes keyboard nav free), `calendar_component.rb` + `calendar_controller.js` (`locale:` param; names via `I18n.l`/`Date::MONTHNAMES` in Ruby, `Intl.DateTimeFormat` in JS; add `role="row"`/`gridcell` to the grid markup).
- *Generator unit:* date_picker row adds a `depends_on` unit reference to calendar (uses P4's recursive `depends_on`).
- *Tests:* Jest — select typeahead/scroll suite; combobox and command a11y suites; date-picker keyboard suite (arrows/PageUp/Home inside the popover); calendar locale rendering. Plus the seven backfill suites (behavioral basics: connect, primary interaction, cleanup). Ruby — calendar grid roles + locale; command roles.
- *Docs/showcase:* a11y sections on the four pages updated to state the implemented ARIA pattern (the "scope honesty" EVALUATION.md called for); date-picker page adds a keyboard demo; calendar page adds a locale example.

**Dependencies & order:** last — polish on stable primitives; typeahead util arrives in P2; the P0 gate's Jest requirement is what drives the backfill list to zero.

**How we know it works:** all listed suites green and the P0 parity gate's controller→Jest assertion passes repo-wide (no exemptions left); keyboard-only walkthrough on the four docs pages (select/combobox/command/date-picker) recorded once; **feel:** phonebook search/select interactions regress nothing.

---

## 4. What NOT to build

- **No Inertia, React, or Radix anything** — settled direction; out of scope here.
- **No `SonnerComponent`** — the capability ships inside Toast (§P3a); two toast systems is the failure mode the locked criteria exist to prevent.
- **No client-side data grid** (virtual scrolling, client filtering of large sets, row selection state machines). Server-first is the Rails answer; revisit only with a concrete consumer need.
- **No chart engine of our own** — no hand-rolled SVG axis/scale/interpolation; we theme and wrap Chart.js.
- **No `FormComponent` that duplicates the FormBuilder** — one form abstraction, the Rails-idiomatic one (§P3b).
- **No full-tree RTL migration in one shot** — scoped passes behind class-assertion tests (§P6), or it becomes an unreviewable diff.
- **No OKLCH/theming migration, `data-slot` adoption, registry server, or community/staffing work in this plan** — EVALUATION.md territory, explicitly not staffed here.
- **No drawer snap points in v1** of gestures (§P7) — drag-to-dismiss first; snap points behind a flag when a consumer needs them.
- **No rewriting EVALUATION.md or PROGRESS.md into new plans** — PROGRESS.md's stale parity sections get a pointer to this document; history stays.

## 5. Definition of done for the whole plan

1. **Inventory:** all 60 upstream names resolve to a shipped unit (58) or a documented equivalence with its own docs page (form → Forms/FormBuilder page, sonner → Toast page note) — with `registry.yml`, docs pages, previews, and Jest suites in lockstep, enforced by the P0 parity gate rather than by a table that can go stale.
2. **Feel test:** the phonebook runs against the upgraded gem with both workaround controllers deleted, no manual overlay event forwarding, no `duration: 0`, and its form/table partials materially smaller — verified by a follow-up PR on that repo (separate work; that repo is not touched by this plan's PRs).
3. **Behavior evidence:** every phase lands with the Jest/Ruby suites named in its spec (no controller ships or remains without a suite), and each phase's docs/showcase entry doubles as its manual regression script.
