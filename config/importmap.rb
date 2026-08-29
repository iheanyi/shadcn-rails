# Importmap configuration for shadcn-rails
# This file is automatically included when using importmaps

pin "shadcn", to: "index.esm.js"
pin "@floating-ui/dom", to: "https://cdn.jsdelivr.net/npm/@floating-ui/dom@1.6.13/+esm"
pin "stimulus-use", to: "https://cdn.jsdelivr.net/npm/stimulus-use@0.52.3/+esm"
pin_all_from File.expand_path("../dist/controllers", __dir__), under: "shadcn/controllers"
