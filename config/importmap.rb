# Importmap configuration for shadcn-rails
# This file is automatically included when using importmaps

pin "shadcn", to: "shadcn/index.js"
pin_all_from File.expand_path("../app/assets/javascripts/shadcn/controllers", __dir__), under: "shadcn/controllers"
