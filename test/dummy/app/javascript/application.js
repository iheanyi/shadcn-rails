// Entry point for JavaScript bundled with esbuild
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Start Stimulus application
const application = Application.start()
application.debug = false
window.Stimulus = application

// Import shadcn-rails controllers from the gem's source directory
// The "shadcn-rails" import is aliased in package.json to point to the gem's JS
import { registerShadcnControllers } from "shadcn-rails"
registerShadcnControllers(application)

export { application }
