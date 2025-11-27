# CLAUDE.md - Documentation Site Guide

This is the test/dummy Rails app that serves as the documentation site for shadcn-rails.

## Purpose

This app serves dual purposes:
1. **Testing environment** for component integration testing
2. **Documentation site** with live interactive examples

## Running the Server

```bash
cd test/dummy
bundle exec rails server
```

The documentation site will be available at `http://localhost:3000/docs`

## Key Routes

- `/` - Landing page
- `/docs` - Documentation introduction
- `/docs/components/{name}` - Individual component documentation
- `/showcase` - Component showcase page

## Directory Structure

```
app/
├── views/
│   ├── docs/                    # Component documentation pages
│   │   ├── button.html.erb
│   │   ├── dialog.html.erb
│   │   ├── tabs.html.erb
│   │   └── ... (43 component pages)
│   ├── layouts/
│   │   └── docs.html.erb        # Documentation layout with sidebar
│   └── pages/
│       └── home.html.erb        # Landing page
├── code_examples/               # Code examples displayed in docs
│   ├── button/
│   │   ├── default.txt
│   │   └── variants.txt
│   ├── pagination/
│   │   ├── kaminari_view.txt
│   │   ├── pagy_view.txt
│   │   └── will_paginate_view.txt
│   └── ... (organized by component)
├── helpers/
│   └── docs_helper.rb           # erb_example and code display helpers
└── controllers/
    ├── docs_controller.rb       # Documentation pages controller
    └── pages_controller.rb      # Static pages controller
```

## Adding Documentation for a New Component

1. **Create the documentation page**:
   ```bash
   touch app/views/docs/{component_name}.html.erb
   ```

2. **Follow the standard structure**:
   ```erb
   <% content_for :title, "Component Name" %>

   <div class="space-y-8">
     <!-- Header -->
     <div class="space-y-2">
       <h1 class="scroll-m-20 text-4xl font-bold tracking-tight">Component Name</h1>
       <p class="text-xl text-muted-foreground">Brief description.</p>
       <div class="flex items-center gap-2 mt-4">
         <!-- Badge: No JavaScript Required or Requires JavaScript -->
       </div>
     </div>

     <!-- Preview -->
     <%= render "docs/demo_card" do %>
       <!-- Live component demo -->
     <% end %>

     <!-- Installation -->
     <div id="installation" class="space-y-4">
       <h2 class="scroll-m-20 border-b pb-2 text-2xl font-semibold tracking-tight">Installation</h2>
       <%= render "docs/code_example", language: "bash", code: "rails generate shadcn:add component_name" %>
     </div>

     <!-- Usage -->
     <div id="usage" class="space-y-4">
       <h2 class="scroll-m-20 border-b pb-2 text-2xl font-semibold tracking-tight">Usage</h2>
       <%= erb_example("component_name/default") %>
     </div>

     <!-- Examples -->
     <div id="examples" class="space-y-8">
       <h2 class="scroll-m-20 border-b pb-2 text-2xl font-semibold tracking-tight">Examples</h2>
       <!-- Example sections -->
     </div>

     <!-- API Reference -->
     <div id="api-reference">
       <h2 class="scroll-m-20 border-b pb-2 text-2xl font-semibold tracking-tight mb-4">API Reference</h2>
       <%= render "docs/props_table", props: [...] %>
     </div>

     <!-- Accessibility -->
     <div class="space-y-4">
       <h2 class="scroll-m-20 border-b pb-2 text-2xl font-semibold tracking-tight">Accessibility</h2>
       <ul class="ml-6 list-disc space-y-2 [&>li]:mt-2">
         <li>Accessibility information</li>
       </ul>
     </div>
   </div>
   ```

3. **Create code examples**:
   ```bash
   mkdir -p app/code_examples/{component_name}
   ```

   Create `.txt` files with ERB code examples (without the `<%%= %>`):
   ```erb
   <%= render Shadcn::ButtonComponent.new do %>
     Click me
   <% end %>
   ```

4. **Add to sidebar navigation** in `app/views/layouts/docs.html.erb`

## Helpers

### `erb_example(path)`

Displays a code example from `app/code_examples/{path}.txt` with syntax highlighting.

```erb
<%= erb_example("button/default") %>
```

This reads `app/code_examples/button/default.txt` and displays it with ERB syntax highlighting.

### `render "docs/demo_card"`

Wraps a live component demo in a styled card:

```erb
<%= render "docs/demo_card" do %>
  <%= render Shadcn::ButtonComponent.new { "Click me" } %>
<% end %>
```

### `render "docs/code_example"`

Displays inline code with syntax highlighting:

```erb
<%= render "docs/code_example", language: "bash", code: "rails generate shadcn:add button" %>
```

### `render "docs/props_table"`

Displays a component's props in a table:

```erb
<%= render "docs/props_table", props: [
  { name: "variant", type: "Symbol", default: ":default", description: "Button style variant" },
  { name: "size", type: "Symbol", default: ":default", description: "Button size" }
] %>
```

## Stimulus Controllers in Docs

For interactive components, the documentation uses inline Stimulus controllers loaded via the docs layout. The Stimulus controllers are registered with the `shadcn--{name}` convention.

Components that require JavaScript display a "Requires JavaScript" badge and include a "Stimulus Controller" section documenting:
- Installation instructions (Importmap, esbuild, Webpack, Vite)
- Targets
- Values
- Actions
- TypeScript types

## Testing Components

The dummy app uses Tailwind CSS via CDN for quick iteration. To test a component:

1. Navigate to its documentation page
2. Interact with the live demos
3. Check browser console for JavaScript errors

## Development Tips

- **Hot reload**: The app uses `hotwire-livereload` for automatic page refresh
- **CSS caching**: If styles seem stuck, hard refresh with Cmd+Shift+R
- **Component changes**: Changes to components in the parent gem require server restart
- **Code examples**: Store as `.txt` files to avoid ERB processing issues
