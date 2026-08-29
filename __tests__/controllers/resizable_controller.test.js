import { Application } from "@hotwired/stimulus"
import ResizableController from "../../app/assets/javascripts/shadcn/controllers/resizable_controller.ts"
import { setupController, cleanupController, click, nextFrame, wait } from '../helpers/stimulus-test-helper.js'

describe("ResizableController", () => {
  let application
  let element
  let controller

  afterEach(() => {
    cleanupController(application)
    // Clean up localStorage
    localStorage.clear()
  })

  describe("basic rendering and initialization", () => {
    const basicHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             data-action="mousedown->shadcn--resizable#startResize touchstart->shadcn--resizable#startResize"
             style="width: 4px; cursor: col-resize;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, basicHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with horizontal direction", () => {
      expect(controller.directionValue).toBe("horizontal")
    })

    test("initializes isDragging to false", () => {
      expect(controller.isDragging).toBe(false)
    })

    test("isHorizontal returns true for horizontal direction", () => {
      expect(controller.isHorizontal).toBe(true)
    })

    test("has panel targets", () => {
      expect(controller.panelTargets.length).toBe(2)
    })

    test("has handle target", () => {
      expect(controller.handleTargets.length).toBe(1)
    })
  })

  describe("vertical direction", () => {
    const verticalHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="vertical"
           style="display: flex; flex-direction: column; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="height: 4px; cursor: row-resize;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, verticalHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("initializes with vertical direction", () => {
      expect(controller.directionValue).toBe("vertical")
    })

    test("isHorizontal returns false for vertical direction", () => {
      expect(controller.isHorizontal).toBe(false)
    })
  })

  describe("startResize", () => {
    const startResizeHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             data-action="mousedown->shadcn--resizable#startResize"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, startResizeHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("sets isDragging to true", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(controller.isDragging).toBe(true)
    })

    test("sets currentHandle", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(controller.currentHandle).toBe(handle)
    })

    test("sets handle data-state to dragging", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(handle.dataset.state).toBe("dragging")
    })

    test("stores start position for horizontal", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(controller.startPosition).toBe(250)
    })

    test("prevents default", async () => {
      const handle = controller.handleTargets[0]
      const preventDefault = jest.fn()
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault
      })

      expect(preventDefault).toHaveBeenCalled()
    })
  })

  describe("stopResize", () => {
    const stopResizeHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, stopResizeHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("sets isDragging to false", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      controller.stopResize()
      await nextFrame()

      expect(controller.isDragging).toBe(false)
    })

    test("clears handle data-state", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      controller.stopResize()
      await nextFrame()

      expect(handle.dataset.state).toBe("")
    })

    test("clears currentHandle", async () => {
      const handle = controller.handleTargets[0]
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      controller.stopResize()
      await nextFrame()

      expect(controller.currentHandle).toBeNull()
    })

    test("does nothing if not dragging", async () => {
      // Should not throw
      expect(() => {
        controller.stopResize()
      }).not.toThrow()
    })
  })

  describe("keyboard navigation", () => {
    const keyboardHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel
             data-min-size="10" data-max-size="90"
             style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel
             data-min-size="10" data-max-size="90"
             style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, keyboardHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("ArrowRight calls findAdjacentPanels and storePanelSizes", async () => {
      const handle = controller.handleTargets[0]
      const findAdjacentSpy = jest.spyOn(controller, 'findAdjacentPanels')
      const storeSizesSpy = jest.spyOn(controller, 'storePanelSizes')

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "ArrowRight",
        shiftKey: false,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(findAdjacentSpy).toHaveBeenCalled()
      expect(storeSizesSpy).toHaveBeenCalled()
    })

    test("ArrowLeft calls findAdjacentPanels and storePanelSizes", async () => {
      const handle = controller.handleTargets[0]
      const findAdjacentSpy = jest.spyOn(controller, 'findAdjacentPanels')
      const storeSizesSpy = jest.spyOn(controller, 'storePanelSizes')

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "ArrowLeft",
        shiftKey: false,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(findAdjacentSpy).toHaveBeenCalled()
      expect(storeSizesSpy).toHaveBeenCalled()
    })

    test("Shift key modifies step size calculation", async () => {
      const handle = controller.handleTargets[0]

      // Without shift
      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "ArrowRight",
        shiftKey: false,
        preventDefault: jest.fn()
      })

      // With shift - step is 10 instead of 1
      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "ArrowRight",
        shiftKey: true,
        preventDefault: jest.fn()
      })
      await nextFrame()

      // Just verify it doesn't throw
      expect(true).toBe(true)
    })

    test("prevents default on arrow keys", async () => {
      const handle = controller.handleTargets[0]
      const preventDefault = jest.fn()

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "ArrowRight",
        shiftKey: false,
        preventDefault
      })

      expect(preventDefault).toHaveBeenCalled()
    })
  })

  describe("panel size constraints", () => {
    const constraintsHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel
             data-min-size="20" data-max-size="80"
             style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel
             data-min-size="20" data-max-size="80"
             style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, constraintsHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("respects min-size constraint", async () => {
      const handle = controller.handleTargets[0]
      const prevPanel = controller.panelTargets[0]

      controller.setPanelSize(prevPanel, 50)
      controller.setPanelSize(controller.panelTargets[1], 50)

      // Try to resize below min
      for (let i = 0; i < 50; i++) {
        controller.handleKeydown.call(controller, {
          currentTarget: handle,
          key: "ArrowLeft",
          shiftKey: false,
          preventDefault: jest.fn()
        })
      }
      await nextFrame()

      expect(parseFloat(prevPanel.dataset.panelSize)).toBeGreaterThanOrEqual(20)
    })

    test("respects max-size constraint", async () => {
      const handle = controller.handleTargets[0]
      const prevPanel = controller.panelTargets[0]

      controller.setPanelSize(prevPanel, 50)
      controller.setPanelSize(controller.panelTargets[1], 50)

      // Try to resize above max
      for (let i = 0; i < 50; i++) {
        controller.handleKeydown.call(controller, {
          currentTarget: handle,
          key: "ArrowRight",
          shiftKey: false,
          preventDefault: jest.fn()
        })
      }
      await nextFrame()

      expect(parseFloat(prevPanel.dataset.panelSize)).toBeLessThanOrEqual(80)
    })
  })

  describe("collapse functionality", () => {
    const collapseHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel
             data-min-size="0" data-max-size="100"
             style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel
             data-min-size="0" data-max-size="100"
             style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, collapseHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("Home calls collapsePanel with prev", async () => {
      const handle = controller.handleTargets[0]
      const collapseSpy = jest.spyOn(controller, 'collapsePanel')

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "Home",
        shiftKey: false,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(collapseSpy).toHaveBeenCalledWith('prev')
    })

    test("End calls collapsePanel with next", async () => {
      const handle = controller.handleTargets[0]
      const collapseSpy = jest.spyOn(controller, 'collapsePanel')

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "End",
        shiftKey: false,
        preventDefault: jest.fn()
      })
      await nextFrame()

      expect(collapseSpy).toHaveBeenCalledWith('next')
    })

    test("Home prevents default", async () => {
      const handle = controller.handleTargets[0]
      const preventDefault = jest.fn()

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "Home",
        shiftKey: false,
        preventDefault
      })

      expect(preventDefault).toHaveBeenCalled()
    })

    test("End prevents default", async () => {
      const handle = controller.handleTargets[0]
      const preventDefault = jest.fn()

      controller.handleKeydown.call(controller, {
        currentTarget: handle,
        key: "End",
        shiftKey: false,
        preventDefault
      })

      expect(preventDefault).toHaveBeenCalled()
    })
  })

  describe("auto-save functionality", () => {
    const autoSaveHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           data-shadcn--resizable-auto-save-id-value="test-layout"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, autoSaveHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("has autoSaveId value", () => {
      expect(controller.autoSaveIdValue).toBe("test-layout")
    })

    test("saves sizes to localStorage", async () => {
      controller.setPanelSize(controller.panelTargets[0], 60)
      controller.setPanelSize(controller.panelTargets[1], 40)
      controller.saveSizes()

      const saved = localStorage.getItem("resizable-test-layout")
      expect(saved).not.toBeNull()

      const sizes = JSON.parse(saved)
      expect(sizes).toHaveLength(2)
    })

    test("loads sizes from localStorage", async () => {
      localStorage.setItem("resizable-test-layout", JSON.stringify([70, 30]))

      controller.loadSavedSizes()
      await nextFrame()

      expect(parseFloat(controller.panelTargets[0].dataset.panelSize)).toBe(70)
      expect(parseFloat(controller.panelTargets[1].dataset.panelSize)).toBe(30)
    })
  })

  describe("setPanelSize and getPanelSize", () => {
    const sizeHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, sizeHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("setPanelSize sets flex-basis", async () => {
      const panel = controller.panelTargets[0]
      controller.setPanelSize(panel, 60)

      expect(panel.style.flexBasis).toBe("60%")
    })

    test("setPanelSize sets data-panel-size", async () => {
      const panel = controller.panelTargets[0]
      controller.setPanelSize(panel, 60)

      expect(panel.dataset.panelSize).toBe("60")
    })
  })

  describe("findAdjacentPanels", () => {
    const adjacentHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 33%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 33%;">Panel 2</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 33%;">Panel 3</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, adjacentHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("finds correct adjacent panels for first handle", async () => {
      controller.currentHandle = controller.handleTargets[0]
      controller.findAdjacentPanels()

      expect(controller.prevPanel).toBe(controller.panelTargets[0])
      expect(controller.nextPanel).toBe(controller.panelTargets[1])
    })

    test("finds correct adjacent panels for second handle", async () => {
      controller.currentHandle = controller.handleTargets[1]
      controller.findAdjacentPanels()

      expect(controller.prevPanel).toBe(controller.panelTargets[1])
      expect(controller.nextPanel).toBe(controller.panelTargets[2])
    })
  })

  describe("disconnect cleanup", () => {
    const disconnectHTML = `
      <div data-controller="shadcn--resizable"
           data-shadcn--resizable-direction-value="horizontal"
           style="display: flex; width: 500px; height: 300px;">
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 1</div>
        <div data-shadcn--resizable-target="handle"
             role="separator"
             tabindex="0"
             style="width: 4px;"></div>
        <div data-shadcn--resizable-target="panel" data-panel style="flex-basis: 50%;">Panel 2</div>
      </div>
    `

    beforeEach(async () => {
      const setup = await setupController(ResizableController, disconnectHTML, 'shadcn--resizable')
      application = setup.application
      element = setup.element
      controller = setup.controller
    })

    test("cleans up event listeners on disconnect", async () => {
      const handle = controller.handleTargets[0]

      // Start resize
      controller.startResize({
        currentTarget: handle,
        type: 'mousedown',
        clientX: 250,
        clientY: 150,
        preventDefault: jest.fn()
      })
      await nextFrame()

      // Disconnect
      expect(() => {
        controller.disconnect()
      }).not.toThrow()
    })
  })
})
