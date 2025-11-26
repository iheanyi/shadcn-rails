# Pin npm packages by running ./bin/importmap

# Hotwire - using cdn.jsdelivr for better ES module support
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Application
pin "application", preload: true

# Stimulus controllers from this app
pin_all_from "app/javascript/controllers", under: "controllers"

# Note: shadcn-rails gem provides its own importmap pins via engine initializer
# The gem's config/importmap.rb pins "shadcn" and all controllers automatically
