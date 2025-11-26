# frozen_string_literal: true

# @label Popover
# @display bg_color "#ffffff"
class PopoverComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic popover with trigger button - click to open
  def default
    render(Shadcn::PopoverComponent.new) do |popover|
      popover.with_trigger do
        button_html(:outline, "Open popover")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="grid gap-4">
            <h4 class="font-medium leading-none">Dimensions</h4>
            <p class="text-sm text-muted-foreground">Set the dimensions for the layer.</p>
            <div class="grid gap-2">
              <div class="grid grid-cols-3 items-center gap-4">
                <label for="width" class="text-sm">Width</label>
                <input type="number" id="width" value="100" class="col-span-2 h-8 w-full rounded-md border border-input bg-background px-3 py-1 text-sm" />
              </div>
              <div class="grid grid-cols-3 items-center gap-4">
                <label for="height" class="text-sm">Height</label>
                <input type="number" id="height" value="25" class="col-span-2 h-8 w-full rounded-md border border-input bg-background px-3 py-1 text-sm" />
              </div>
            </div>
          </div>
        HTML
      end
    end
  end

  # @label All Sides
  # Shows popover on different sides
  # @param side select { choices: [top, right, bottom, left] }
  def sides(side: :bottom)
    render(Shadcn::PopoverComponent.new(side: side.to_sym)) do |popover|
      popover.with_trigger do
        button_html(:outline, "Open")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="p-4">
            <p class="text-sm">Popover content positioned on #{side}</p>
          </div>
        HTML
      end
    end
  end

  # @label All Alignments
  # Shows popover with different alignments
  # @param align select { choices: [start, center, end] }
  def alignments(align: :center)
    render(Shadcn::PopoverComponent.new(align: align.to_sym)) do |popover|
      popover.with_trigger do
        button_html(:outline, "Open")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="p-4">
            <p class="text-sm">Aligned to #{align}</p>
          </div>
        HTML
      end
    end
  end

  # @label Simple Content
  # Popover with simple text content
  def simple
    render(Shadcn::PopoverComponent.new) do |popover|
      popover.with_trigger do
        button_html(:ghost, "Help")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="space-y-2">
            <p class="text-sm font-medium">Quick tip</p>
            <p class="text-sm text-muted-foreground">This is some helpful information in a popover.</p>
          </div>
        HTML
      end
    end
  end

  # @label With Form
  # Popover containing a form
  def with_form
    render(Shadcn::PopoverComponent.new) do |popover|
      popover.with_trigger do
        button_html(:outline, "Settings")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="grid gap-4">
            <div class="space-y-2">
              <h4 class="font-medium leading-none">Settings</h4>
              <p class="text-sm text-muted-foreground">Configure your preferences.</p>
            </div>
            <div class="grid gap-2">
              <div class="grid grid-cols-3 items-center gap-4">
                <label for="name" class="text-sm">Name</label>
                <input type="text" id="name" value="John Doe" class="col-span-2 h-8 w-full rounded-md border border-input bg-background px-3 py-1 text-sm" />
              </div>
              <div class="grid grid-cols-3 items-center gap-4">
                <label for="email" class="text-sm">Email</label>
                <input type="email" id="email" value="john@example.com" class="col-span-2 h-8 w-full rounded-md border border-input bg-background px-3 py-1 text-sm" />
              </div>
              <div class="flex justify-end">
                #{button_html(:default, "Save", "h-8 px-3 text-xs")}
              </div>
            </div>
          </div>
        HTML
      end
    end
  end

  # @label Top Position
  # Popover positioned on top
  def top
    render(Shadcn::PopoverComponent.new(side: :top)) do |popover|
      popover.with_trigger do
        button_html(:outline, "Open (Top)")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="p-4">
            <p class="text-sm">Positioned on top</p>
          </div>
        HTML
      end
    end
  end

  # @label Right Position
  # Popover positioned on right
  def right
    render(Shadcn::PopoverComponent.new(side: :right)) do |popover|
      popover.with_trigger do
        button_html(:outline, "Open (Right)")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="p-4">
            <p class="text-sm">Positioned on right</p>
          </div>
        HTML
      end
    end
  end

  # @label Left Position
  # Popover positioned on left
  def left
    render(Shadcn::PopoverComponent.new(side: :left)) do |popover|
      popover.with_trigger do
        button_html(:outline, "Open (Left)")
      end
      popover.with_body do
        <<~HTML.html_safe
          <div class="p-4">
            <p class="text-sm">Positioned on left</p>
          </div>
        HTML
      end
    end
  end

  private

  def button_html(variant, text, extra_class = nil)
    base_classes = "inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2"

    variant_classes = case variant
    when :default
      "bg-primary text-primary-foreground hover:bg-primary/90"
    when :destructive
      "bg-destructive text-destructive-foreground hover:bg-destructive/90"
    when :outline
      "border border-input bg-background hover:bg-accent hover:text-accent-foreground"
    when :secondary
      "bg-secondary text-secondary-foreground hover:bg-secondary/80"
    when :ghost
      "hover:bg-accent hover:text-accent-foreground"
    when :link
      "text-primary underline-offset-4 hover:underline"
    else
      "bg-primary text-primary-foreground hover:bg-primary/90"
    end

    classes = [base_classes, variant_classes, extra_class].compact.join(" ")
    %(<button type="button" class="#{classes}">#{text}</button>).html_safe
  end
end
