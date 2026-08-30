// Entry point for JavaScript bundled with esbuild
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Start Stimulus application
const application = Application.start()
application.debug = false
window.Stimulus = application

// Import shadcn-rails controllers from the compiled gem bundle.
// The "shadcn-rails-stimulus" import is aliased in package.json to dist/index.esm.js.
import { registerShadcnControllers } from "shadcn-rails-stimulus"
import { registerShadcnChartController } from "shadcn-rails-stimulus/chart"
registerShadcnControllers(application)
registerShadcnChartController(application)

// Import local controllers
import ClipboardController from "./controllers/clipboard_controller"
import EditorController from "./controllers/editor_controller"
application.register("clipboard", ClipboardController)
application.register("editor", EditorController)

export { application }
