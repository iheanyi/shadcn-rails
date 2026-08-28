# EVALUATION: shadcn-rails as a serious open-source library

*An outside architecture evaluation of this repository, written August 2026. It covers the codebase as of `main` (v0.2.1, last push November 2025), the current shadcn/ui ecosystem, and the Inertia Rails question. It recommends a direction; it does not change any library code.*

## Method

- **Repo:** full read of README, CHANGELOG, PROGRESS.md, CLAUDE.md, gemspec, package.json, generators, representative components (button, dialog, select, dropdown, card, table), Stimulus controllers, CI workflows, release tooling, theming layer, and the dummy docs app.
- **Tests were actually run:** `bundle exec rake test` → 709 runs, 1,256 assertions, 0 failures. `npx jest` → 23 suites, 1,161 tests, all passing.
- **Ecosystem checked against live sources (August 2026), not training data:** ui.shadcn.com docs/changelog (CLI v4, universal registry items, OKLCH/Tailwind v4), the `inertiajs/inertia-rails` repo and its official starter kits (cloned and inspected), RubyGems/npm APIs, and GitHub stats for the competing Rails ports.

## TL;DR verdict

This is a genuinely impressive four-day build (244 commits, Nov 24–28, 2025) that is much further along than "experiment" suggests in some places — 1,870 passing tests, a production-grade release pipeline, real Floating UI positioning — and clearly experiment-shaped in exactly the places that determine whether strangers adopt a library: the copy-into-app generator only half works, there is no LICENSE file, accessibility is a tier below Radix, theming has drifted from upstream, and public traction is near zero (10 stars, 1 fork; ~6.8k total gem downloads, a number inflated by mirrors and CI).

**The architecture recommendation is to keep this a ViewComponent + Stimulus library and explicitly *not* add Inertia/React support.** The starting hypothesis — "a Hotwire-era port may be the wrong default because Rails energy is moving to Inertia + React shadcn" — is **half right and should be half discarded**. Inertia momentum is real, but that lane is already fully served by `inertia_rails` plus the *official* shadcn CLI and starter kits; a Ruby gem has nothing to add there. The real competitive threat is not Inertia — it's `ruby_ui`, which occupies the same server-rendered lane with ~5x the traction. The decision this library faces is not "Hotwire vs Inertia" but "be the best *ViewComponent* shadcn or don't bother."

---

## 1. What is already strong vs still experiment-shaped

### Strong (production-grade, better than most young gems)

- **Test discipline.** 709 Ruby component tests covering variants, sizes, slots, and ARIA attributes for all 56 top-level components; 1,161 behavioral Jest tests (dialog focus trap, escape handling, portal cleanup, scroll lock) with a proper shared test harness. Both suites pass today.
- **Release engineering.** Version files in sync across gem and npm, tagged releases, Keep-a-Changelog CHANGELOG, a full-featured `bin/bump` (sync verification, dry-run, tagging), and a tag-triggered release workflow that verifies version match, runs both suites, and publishes to RubyGems and npm. Most 1.0 gems don't have this.
- **Component breadth and fidelity.** ~57 top-level components (the README undersells at 47). Tailwind class strings are near-verbatim from shadcn/ui; the slot-based composition (`card.with_header`, polymorphic ordered select items) is an idiomatic ViewComponent translation of the compound-component model. Select is notably well done: `role="combobox"`, `aria-expanded`, listbox/option roles, and a hidden input for Rails form submission.
- **Real positioning layer.** `dropdown_controller.js` uses `@floating-ui/dom` with offset/flip/shift/size middleware, `autoUpdate`, and cleanup on disconnect — the same foundation upstream primitives use, not a hand-rolled `getBoundingClientRect` hack.
- **CI is real.** Ruby 3.2/3.3/3.4 matrix, Jest, npm build, and a release-readiness job on every PR.
- **Docs content.** 55 documentation pages with live demos, 230 file-based code examples, Lookbook previews, a theme playground. The content exists; only deployment is missing.

### Experiment-shaped (the tells)

- **The headline feature is broken for compound components.** `rails g shadcn:add dialog` copies `dialog_component.rb` but none of the six subcomponent files (`DialogContentComponent` etc.) that contain the actual overlay/panel/close markup. The user gets a customizable shell whose real markup still lives in the gem — the shadcn/ui "own your code" promise only works for simple components. Two components (`empty`, `item`) aren't in the generator's file map at all, and copied controllers carry gem-relative imports (`../utils/floating`) that break in the destination directory.
- **No LICENSE file.** README says "see LICENSE," gemspec says MIT, package.json says MIT — the file does not exist. A legal blocker for something already published to two registries.
- **No known production consumer.** No visible dependents, 1 fork, 1 issue. Nothing in the repo demonstrates the gem installing cleanly into a fresh Rails app — PROGRESS.md itself lists that integration test as an unchecked TODO.
- **Accessibility is partial where it's hardest.** Dialog has `role="dialog"` and `aria-modal` but never wires `aria-labelledby`/`aria-describedby` to its title/description (Radix does this automatically); menus lack typeahead and `aria-activedescendant`; the dialog focus trap doesn't exclude disabled/hidden elements; no `inert` on background content. The dialog portal is implemented by copying `template.innerHTML` into `document.body` and manually re-binding close buttons — a workaround that silently breaks any nested Stimulus behavior inside dialog content.
- **Theming has drifted from upstream.** This repo uses the HSL-triplet convention (`--primary: 0 0% 9%` + `hsl(var(--primary))`) and a Tailwind v3-config-editing installer. Since February 2025, shadcn/ui ships OKLCH values with Tailwind v4 `@theme`, `data-slot` attributes on every primitive, and has deprecated the default style and the Toast component (this repo's PROGRESS.md still treats Toast-over-Sonner as the "appropriate" call). Anyone pasting a theme from ui.shadcn.com today gets incompatible variables. The `tailwind-v4.css` bridge exists but is a compatibility shim, not the native convention.
- **Doc/code drift in both directions.** `dialog_component.rb`'s own doc example calls a slot that doesn't exist (`with_content` vs the actual `with_body`); PROGRESS.md lists dropdown checkbox/radio items as TODO while the controller already implements them; `.d.ts` files cover only 21 of 33 controllers despite the TODO being marked complete; README says 47 components while 57 exist.
- **Dead weight.** `turbo-rails` is a hard dependency used nowhere; a ~230-line hand-rolled class merger guards a `LoadError` branch that can never trigger because `tailwind_merge` is a hard dependency; a leftover `--radix-select-trigger-width` CSS variable that nothing sets; the "lint" CI job is only `ruby -c` syntax checking.
- **Ten of 33 controllers have no Jest tests** — including `dropdown`, the most complex one.

The pattern is characteristic of an agent-driven sprint: extraordinary breadth and internal tooling, thin verification at the boundaries where the library meets a real consumer app.

---

## 2. Architecture recommendation: stay ViewComponent + Stimulus. Do not add Inertia. Do not dual-support.

### The ecosystem facts (verified August 2026)

1. **The Inertia + shadcn path is already solved — officially, with no gem required.** `inertia_rails` is at 3.22.0 with ~1.95M downloads and is part of the official Inertia.js org, with Evil Martians on the maintainer team. Its official React starter kit ships React 19, `@inertiajs/react` 3.6, `radix-ui`, a shadcn `components.json`, and ~23 shadcn/ui components pre-installed under `components/ui/`; Vue and Svelte kits ship shadcn-vue and shadcn-svelte. The inertia-rails docs include an official "Integrating shadcn/ui" cookbook: `rails g inertia:install`, then plain `npx shadcn init`. One claimed detail did *not* check out: there is no "INERTIA_SHADCN" generator anywhere in the inertia-rails codebase — but the substance holds, because the starter kits plus the official CLI cover that ground completely. **A Rails gem that vendored React shadcn components would be strictly worse than what `npx shadcn` already does in an Inertia app.** There is no product there, only duplication with a permanent staleness problem.

2. **The server-rendered lane is real but contested — and the incumbent is Phlex, not ViewComponent.** `ruby-ui/ruby_ui` (formerly PhlexUI): 1,032 stars, 30 contributors, v1.1.0 in February 2026, pushed as recently as this week, generator-only "own your code" model, Phlex 2 + Tailwind v4, importmap-tested, RTL support. `aviflombaum/shadcn-rails` — an *exact repo-name collision* with this project — has 892 stars but has not been pushed since November 2025. So the claim "the Hotwire-side winner is ruby_ui" checks out. There is no active, credible *ViewComponent* shadcn port — that is simultaneously this project's opening and a hint that the demand is unproven.

3. **The demand split is real but misread by the hypothesis.** The 2024 Rails Community Survey (latest with hard numbers) has Stimulus at 31% and React at 24% among Rails developers. Inertia's momentum since (official org adoption, starter kits, RailsConf visibility) is genuine, but it doesn't drain the server-rendered lane — Hotwire remains the Rails default and the omakase path. What Inertia's rise *does* do is cap the ceiling of any server-rendered shadcn port: the subset of teams who want shadcn's exact visual language *and* refuse React now have an officially blessed escape hatch.

### The recommendation

**Keep shadcn-rails as the ViewComponent + Stimulus library.** Sharpen that identity rather than hedging it:

- **Do not add Inertia/React support.** Anyone choosing Inertia should use `inertia_rails` + official `npx shadcn` — the correct move is a README paragraph saying exactly that, which builds trust rather than losing a user you were never going to keep.
- **Do not dual-support.** Two component trees (ERB/Stimulus and TSX) means every upstream shadcn change lands twice, every bug report needs stack triage, and the React half is redundant with official tooling from day one. Dual support is how a solo-maintained library dies.
- **Own the differentiators that Phlex-based ruby_ui can't take:** ViewComponent is the mainstream Rails component framework (GitHub-backed, huge installed base, familiar ERB templates); this gem's Stimulus controllers ship on npm with types; and the slot API reads like Rails, not like a DSL. "shadcn for ViewComponent shops" is a coherent, ownable position. The gem name `shadcn-rails` is an asset — keep it (while being upfront in the README about the unrelated `aviflombaum/shadcn-rails` repo and `shadcn-ui` gem, because every potential adopter will hit that confusion within one Google search).

### The hardest tradeoffs, named honestly

- **You are betting against the incumbent, from behind.** ruby_ui has ~100x the stars, 30 contributors, and current-week commits. The counter-position (ViewComponent + ERB vs Phlex DSL) is real, but it must be *earned* with a working own-your-code story and Radix-grade a11y — the two places this repo is currently weakest.
- **Chasing a moving upstream is a treadmill.** shadcn/ui now ships a bases matrix (Radix/Base UI/React Aria), OKLCH, `data-slot`, `registry:base` design-system payloads, and a CLI that inspects registries. A port maintained by effectively one person will always trail. The mitigation is to define a supported subset and track it deliberately (see roadmap) rather than claiming parity — the current "57/59 parity" framing sets an expectation that cannot be kept.
- **The ceiling is genuinely lower than the Inertia lane.** If the goal is maximum users of shadcn-styled Rails apps, the honest answer is that most of that growth will happen in Inertia apps using the official CLI, no matter what this gem does. The addressable market here is Hotwire/server-rendered teams — large, but not the whole pie, and shared with ruby_ui. This is worth accepting explicitly rather than fighting.
- **Stimulus cannot fully replicate Radix behavior.** Focus management, typeahead, collision-aware nesting, and composition through portals are hard-won in Radix/Base UI. Some gap is permanent. The mitigation is scope honesty (document which ARIA patterns each component implements) rather than implying equivalence.

### One future option worth keeping open (not starting now)

shadcn's **universal registry items** (July 2025) explicitly support distributing arbitrary files to any project — no React, no `components.json` required — and CLI v4 (March 2026) added `registry:base`, private registries, and payload inspection. That means a future `shadcn-rails` registry could serve ERB components + Stimulus controllers through the *official* `npx shadcn add <url>` flow, or a small Ruby CLI over the same JSON schema. That is the modern replacement for the Rails-generator distribution model, it is agent/MCP-friendly, and it would fix the copy-into-app gap at the architecture level. Two cautions: it must serve hand-maintained Ruby/ERB sources keyed by registry metadata — a TSX→ERB transpiler is not feasible and should not be attempted — and it only matters after the core own-your-code and a11y work is done. Sequence it accordingly (90-day horizon, behind the fundamentals).

---

## 3. Gaps for a public library people would actually adopt

Ordered roughly by how quickly each one loses a would-be adopter:

1. **Legal/publishing:** No LICENSE file, while README/gemspec/package.json all claim MIT. Blocker for corporate adoption; five-minute fix.
2. **The `shadcn:add` compound-component gap** (§1). Until `add dialog` copies the whole dialog unit and fixes controller import paths, the core promise is false advertising. This is the single most important code fix in the repo.
3. **No proof of clean install.** A CI job that creates a fresh Rails app (importmap and esbuild variants), runs `shadcn:install` + `shadcn:add`, and boots it would convert "probably works" into "verified" — and would have caught the import-path and subcomponent bugs.
4. **Naming collision.** `iheanyi/shadcn-rails` vs `aviflombaum/shadcn-rails` (892 stars, same name, stalled) and his `shadcn-ui` gem. Not fixable by renaming (the gem name is owned and valuable) — fixable by a prominent README disambiguation and by making this the *actively maintained* one, which the November-2025 last-push date currently undercuts.
5. **A11y depth** (§1): `aria-labelledby`/`aria-describedby` wiring in overlays, menu typeahead, focus-trap correctness, `inert`/`aria-hidden` on background, and a per-component ARIA conformance table in the docs. This is the credibility bar shadcn users expect because Radix set it.
6. **Theming currency:** migrate to OKLCH variables and Tailwind-v4-first setup (keep an HSL compat layer), adopt `data-slot` attributes, and make the installer understand CSS-first Tailwind v4 apps instead of editing `tailwind.config.js`.
7. **Docs site not deployed.** The content exists; `fly.toml` exists; the site was never shipped. An undeployed docs site reads as abandonment. Also fix README drift (47 vs 57 components) and the broken doc examples.
8. **Turbo integration, ironically absent.** Zero `turbo:` event handling (open menus get snapshotted into Turbo's page cache), while `turbo-rails` sits as an unused hard dependency. Drop the dependency; add `turbo:before-cache` cleanup.
9. **Registry/CLI story:** none today; Rails generators are the current answer and fine for now, with the universal-registry option as the deliberate next step (§2).
10. **Quality gates:** real linters (RuboCop, ESLint) replacing the `ruby -c` lint job; Jest coverage for the 10 untested controllers (dropdown first); a Rails 7.x/8.x matrix to back the `railties >= 7.0` claim; delete the dead hand-rolled class merger or make `tailwind_merge` genuinely optional.
11. **Community surface:** no CONTRIBUTING.md, no issue/PR templates, no discussions, no "which components are stable" tiering, no public roadmap. PROGRESS.md and CLAUDE.md are agent working logs and read as such — replace with human-facing equivalents (move agent context to `.github/` or AGENTS.md).
12. **Versioning policy:** the plumbing is excellent; what's missing is a stated policy — what 0.x means, what will break, criteria for 1.0.

---

## 4. A concrete 30/60/90-day roadmap

**Days 0–30 — make the existing promise true (credibility):**
- Add the MIT LICENSE file; ship as 0.2.2 immediately.
- Fix `shadcn:add` to copy complete component units (all subcomponent files + sidecar templates + controller with corrected import paths); add `empty`/`item` to the map; test the local-override precedence claim.
- Add the fresh-Rails-app integration test to CI (importmap + esbuild variants).
- Drop the unused `turbo-rails` dependency; delete or truly-optionalize the hand-rolled class merger; fix the dialog doc example and dead controller code.
- Deploy the docs site (Fly config already exists) and correct README claims (57 components, honest per-component a11y notes, disambiguation from the other shadcn-rails).
- Add the "using Inertia? use the official shadcn CLI — here's the cookbook link" README section.

**Days 30–60 — close the quality gap that Radix users will notice (depth):**
- Overlay a11y pass: `aria-labelledby`/`aria-describedby` auto-wiring, focus-trap fixes (disabled/hidden exclusion, `inert` background), replace the innerHTML portal with a moved-node portal that preserves Stimulus bindings.
- Menu a11y: typeahead, `aria-activedescendant`.
- Turbo lifecycle: `turbo:before-cache` cleanup across all stateful controllers.
- Jest tests for the 10 uncovered controllers, starting with dropdown and base_menu.
- RuboCop + ESLint in CI; Rails version matrix (7.1/7.2/8.x).
- Begin OKLCH/Tailwind-v4-first theming migration with an HSL compat layer and `data-slot` adoption.

**Days 60–90 — distribution and adoption (growth):**
- Prototype the shadcn-compatible registry: serve 5–10 components as universal registry items consumable via `npx shadcn add <url>`; decide registry-vs-generators as the primary story based on how it feels.
- Publish a stability tier list (stable / beta / experimental) instead of the parity table; state the 0.x→1.0 policy.
- Community infra: CONTRIBUTING, issue templates, a couple of good-first-issues from this document.
- Announce: a "why ViewComponent shadcn" writeup, Lookbook-powered docs, and an ask for real-app adopters — the library needs one production consumer more than it needs its 58th component.

---

## 5. What I would not do

- **Do not add Inertia or React rendering to this gem, in any form** — not as an optional mode, not as a second package. That lane belongs to `inertia_rails` + official `npx shadcn`, which will always do it better.
- **Do not dual-support ViewComponent and React.** Every upstream change ×2, every issue triaged ×2, one maintainer.
- **Do not rewrite in Phlex** to chase ruby_ui. It would take years to re-earn current test coverage, and it abandons the only differentiator (ViewComponent/ERB familiarity) for a lane someone else already owns.
- **Do not build a TSX→ERB transpiler** or promise automated sync with upstream shadcn JSON. The registry play (§2) distributes hand-maintained Ruby sources; the transformation itself cannot be automated honestly.
- **Do not chase full parity with shadcn's bases matrix** (Radix/Base UI/React Aria variants, `registry:base` design-system payloads, RTL, charts, data table) before the core 20 components are bulletproof. Parity tables are a treadmill; a stability tier list is a promise you can keep.
- **Do not rename the gem.** `shadcn-rails` on RubyGems is owned and descriptive; the collision with the dormant same-named repo is managed with documentation and activity, not a rename.
- **Do not keep publishing breadth.** 57 components with a half-working `add` generator is worth less than 25 components that install perfectly, pass an axe-core audit, and survive Turbo navigation. Shrink the public promise to what is verifiably true, then grow it again.

---

## Appendix: specific ecosystem claims checked

| Claim | Verdict | Evidence |
|---|---|---|
| `inertia_rails` at 3.22 + official `npx shadcn` is the served Inertia path | **True** | RubyGems shows 3.22.0 (~1.95M downloads); official React/Vue/Svelte starter kits ship shadcn components pre-installed; official cookbook documents `npx shadcn init` on Inertia Rails |
| An "INERTIA_SHADCN generator" exists | **False as stated** | No such string anywhere in `inertiajs/inertia-rails`; the substance (starter kits + CLI cookbook) holds regardless |
| The Hotwire-side public winner is ruby_ui (Phlex), not a ViewComponent port | **True** | ruby_ui: 1,032 stars, 30 contributors, v1.1.0 Feb 2026, pushed this week. No active ViewComponent competitor; `aviflombaum/shadcn-rails` (892 stars) last pushed Nov 2025 |
| shadcn/ui supports non-React distribution today | **True** | Universal registry items (July 2025) work with "no framework, no components.json, no tailwind, no react"; CLI v4 (March 2026) added `registry:base`, private registries, payload inspection |
| Current shadcn/ui conventions have moved past this repo's | **True** | OKLCH replaced HSL (Feb 2025), Tailwind v4 `@theme`, `data-slot` on every primitive, Toast deprecated for Sonner, default style deprecated for new-york, base choice (Radix/Base UI/React Aria) at init |
