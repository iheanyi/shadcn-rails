import { Application } from "@hotwired/stimulus"
import shadcnRailsStimulus, {
  DialogController,
  type ShadcnControllerIdentifier,
  type ShadcnControllerMap,
  controllers,
  registerShadcnControllers
} from "shadcn-rails-stimulus"
import { DialogController as DialogControllerFromBarrel } from "shadcn-rails-stimulus/controllers"
import { ChartController, registerShadcnChartController } from "shadcn-rails-stimulus/chart"
import DialogControllerFromSubpath from "shadcn-rails-stimulus/controllers/dialog_controller"

const application = Application.start()

registerShadcnControllers(application)
registerShadcnChartController(application)
shadcnRailsStimulus.registerShadcnControllers(application)

const identifier: ShadcnControllerIdentifier = "shadcn--dialog"
const controllerMap: ShadcnControllerMap = controllers
const dialogController = controllerMap[identifier]

application.register(identifier, dialogController)

const exportedControllers: Array<typeof DialogController> = [
  DialogController,
  DialogControllerFromBarrel,
  DialogControllerFromSubpath
]

const exportedChartControllers: Array<typeof ChartController> = [
  ChartController
]

export { exportedControllers, exportedChartControllers }
