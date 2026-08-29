import { Controller } from "@hotwired/stimulus";
/**
 * Resizable Panel Controller
 * Handles resizable panel layouts with keyboard and mouse support
 */
export default class default_1 extends Controller {
    static { this.targets = ["panel", "handle"]; }
    static { this.values = {
        direction: { type: String, default: "horizontal" },
        autoSaveId: String
    }; }
    connect() {
        this.isDragging = false;
        this.currentHandle = null;
        this.startPosition = 0;
        this.startSizes = [];
        // Bind methods
        this.boundResize = this.resize.bind(this);
        this.boundStopResize = this.stopResize.bind(this);
        // Load saved sizes if autoSaveId is set
        if (this.hasAutoSaveIdValue) {
            this.loadSavedSizes();
        }
        // Add keyboard support
        this.handleTargets.forEach((handle) => {
            handle.addEventListener('keydown', this.handleKeydown.bind(this));
        });
    }
    disconnect() {
        document.removeEventListener('mousemove', this.boundResize);
        document.removeEventListener('mouseup', this.boundStopResize);
        document.removeEventListener('touchmove', this.boundResize);
        document.removeEventListener('touchend', this.boundStopResize);
    }
    startResize(event) {
        event.preventDefault();
        this.isDragging = true;
        this.currentHandle = event.currentTarget;
        this.currentHandle.dataset.state = "dragging";
        // Get the position based on event type
        const position = event.type.includes('touch')
            ? (this.isHorizontal ? event.touches[0].clientX : event.touches[0].clientY)
            : (this.isHorizontal ? event.clientX : event.clientY);
        this.startPosition = position;
        // Find adjacent panels
        this.findAdjacentPanels();
        // Store initial sizes
        this.storePanelSizes();
        // Add document listeners
        document.addEventListener('mousemove', this.boundResize);
        document.addEventListener('mouseup', this.boundStopResize);
        document.addEventListener('touchmove', this.boundResize, { passive: false });
        document.addEventListener('touchend', this.boundStopResize);
        // Prevent text selection during drag
        document.body.style.userSelect = 'none';
        document.body.style.cursor = this.isHorizontal ? 'col-resize' : 'row-resize';
    }
    resize(event) {
        if (!this.isDragging)
            return;
        event.preventDefault();
        const position = event.type.includes('touch')
            ? (this.isHorizontal ? event.touches[0].clientX : event.touches[0].clientY)
            : (this.isHorizontal ? event.clientX : event.clientY);
        const delta = position - this.startPosition;
        const containerSize = this.isHorizontal
            ? this.element.offsetWidth
            : this.element.offsetHeight;
        const deltaPercent = (delta / containerSize) * 100;
        if (this.prevPanel && this.nextPanel) {
            const prevSize = this.prevPanelStartSize + deltaPercent;
            const nextSize = this.nextPanelStartSize - deltaPercent;
            // Get min/max constraints
            const prevMin = parseFloat(this.prevPanel.dataset.minSize) || 0;
            const prevMax = parseFloat(this.prevPanel.dataset.maxSize) || 100;
            const nextMin = parseFloat(this.nextPanel.dataset.minSize) || 0;
            const nextMax = parseFloat(this.nextPanel.dataset.maxSize) || 100;
            // Apply constraints
            if (prevSize >= prevMin && prevSize <= prevMax &&
                nextSize >= nextMin && nextSize <= nextMax) {
                this.setPanelSize(this.prevPanel, prevSize);
                this.setPanelSize(this.nextPanel, nextSize);
            }
        }
    }
    stopResize() {
        if (!this.isDragging)
            return;
        this.isDragging = false;
        if (this.currentHandle) {
            this.currentHandle.dataset.state = "";
        }
        document.removeEventListener('mousemove', this.boundResize);
        document.removeEventListener('mouseup', this.boundStopResize);
        document.removeEventListener('touchmove', this.boundResize);
        document.removeEventListener('touchend', this.boundStopResize);
        document.body.style.userSelect = '';
        document.body.style.cursor = '';
        // Save sizes if autoSaveId is set
        if (this.hasAutoSaveIdValue) {
            this.saveSizes();
        }
        this.currentHandle = null;
    }
    handleKeydown(event) {
        const handle = event.currentTarget;
        const step = event.shiftKey ? 10 : 1;
        let delta = 0;
        if (this.isHorizontal) {
            if (event.key === 'ArrowLeft')
                delta = -step;
            if (event.key === 'ArrowRight')
                delta = step;
        }
        else {
            if (event.key === 'ArrowUp')
                delta = -step;
            if (event.key === 'ArrowDown')
                delta = step;
        }
        if (delta !== 0) {
            event.preventDefault();
            this.currentHandle = handle;
            this.findAdjacentPanels();
            this.storePanelSizes();
            if (this.prevPanel && this.nextPanel) {
                const prevSize = this.prevPanelStartSize + delta;
                const nextSize = this.nextPanelStartSize - delta;
                // Get min/max constraints
                const prevMin = parseFloat(this.prevPanel.dataset.minSize) || 0;
                const prevMax = parseFloat(this.prevPanel.dataset.maxSize) || 100;
                const nextMin = parseFloat(this.nextPanel.dataset.minSize) || 0;
                const nextMax = parseFloat(this.nextPanel.dataset.maxSize) || 100;
                if (prevSize >= prevMin && prevSize <= prevMax &&
                    nextSize >= nextMin && nextSize <= nextMax) {
                    this.setPanelSize(this.prevPanel, prevSize);
                    this.setPanelSize(this.nextPanel, nextSize);
                }
            }
            if (this.hasAutoSaveIdValue) {
                this.saveSizes();
            }
        }
        // Home/End keys
        if (event.key === 'Home') {
            event.preventDefault();
            this.collapsePanel('prev');
        }
        if (event.key === 'End') {
            event.preventDefault();
            this.collapsePanel('next');
        }
    }
    findAdjacentPanels() {
        const allElements = Array.from(this.element.children);
        const handleIndex = allElements.indexOf(this.currentHandle);
        // Find the panel before the handle
        this.prevPanel = null;
        for (let i = handleIndex - 1; i >= 0; i--) {
            if (allElements[i].dataset.panel !== undefined) {
                this.prevPanel = allElements[i];
                break;
            }
        }
        // Find the panel after the handle
        this.nextPanel = null;
        for (let i = handleIndex + 1; i < allElements.length; i++) {
            if (allElements[i].dataset.panel !== undefined) {
                this.nextPanel = allElements[i];
                break;
            }
        }
    }
    storePanelSizes() {
        if (this.prevPanel) {
            this.prevPanelStartSize = this.getPanelSize(this.prevPanel);
        }
        if (this.nextPanel) {
            this.nextPanelStartSize = this.getPanelSize(this.nextPanel);
        }
    }
    getPanelSize(panel) {
        const containerSize = this.isHorizontal
            ? this.element.offsetWidth
            : this.element.offsetHeight;
        const panelSize = this.isHorizontal
            ? panel.offsetWidth
            : panel.offsetHeight;
        return (panelSize / containerSize) * 100;
    }
    setPanelSize(panel, percent) {
        panel.style.flexBasis = `${percent}%`;
        panel.dataset.panelSize = String(percent);
    }
    collapsePanel(which) {
        this.findAdjacentPanels();
        this.storePanelSizes();
        if (which === 'prev' && this.prevPanel && this.nextPanel) {
            const prevMin = parseFloat(this.prevPanel.dataset.minSize) || 0;
            this.setPanelSize(this.prevPanel, prevMin);
            this.setPanelSize(this.nextPanel, this.prevPanelStartSize + this.nextPanelStartSize - prevMin);
        }
        else if (which === 'next' && this.prevPanel && this.nextPanel) {
            const nextMin = parseFloat(this.nextPanel.dataset.minSize) || 0;
            this.setPanelSize(this.nextPanel, nextMin);
            this.setPanelSize(this.prevPanel, this.prevPanelStartSize + this.nextPanelStartSize - nextMin);
        }
    }
    saveSizes() {
        const sizes = this.panelTargets.map((panel) => this.getPanelSize(panel));
        localStorage.setItem(`resizable-${this.autoSaveIdValue}`, JSON.stringify(sizes));
    }
    loadSavedSizes() {
        const saved = localStorage.getItem(`resizable-${this.autoSaveIdValue}`);
        if (saved) {
            try {
                const sizes = JSON.parse(saved);
                this.panelTargets.forEach((panel, index) => {
                    if (sizes[index] !== undefined) {
                        this.setPanelSize(panel, sizes[index]);
                    }
                });
            }
            catch (e) {
                console.warn('Failed to load saved panel sizes:', e);
            }
        }
    }
    get isHorizontal() {
        return this.directionValue === 'horizontal';
    }
}
//# sourceMappingURL=resizable_controller.js.map