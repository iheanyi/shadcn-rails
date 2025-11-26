// Import and register Stimulus controllers

import { Application } from "@hotwired/stimulus"

// Start Stimulus application
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// Import shadcn-rails controllers
import { registerShadcnControllers } from "shadcn"
registerShadcnControllers(application)

// Export application for use by other modules
export { application }
