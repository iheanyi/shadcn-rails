// Entry point for JavaScript bundled with esbuild
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// Start Stimulus application
const application = Application.start()
application.debug = false
window.Stimulus = application

// Import shadcn-rails controllers from the compiled gem bundle.
// The package imports are aliased by the package.json build script.
import { registerShadcnControllers } from "shadcn-rails-stimulus"
import { registerShadcnChartController } from "shadcn-rails-stimulus/chart"
registerShadcnControllers(application)
registerShadcnChartController(application)

// Import local controllers
import ClipboardController from "./controllers/clipboard_controller"
import DocsLiveFilterController from "./controllers/docs_live_filter_controller"
import EditorController from "./controllers/editor_controller"
application.register("clipboard", ClipboardController)
application.register("docs--live-filter", DocsLiveFilterController)
application.register("editor", EditorController)

export { application }
