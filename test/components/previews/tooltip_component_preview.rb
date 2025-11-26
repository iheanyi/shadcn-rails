# frozen_string_literal: true

# @label Tooltip
# @display bg_color "#ffffff"
class TooltipComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic tooltip on top of button - hover to show
  def default
    render(Shadcn::TooltipComponent.new(text: "Add to library")) do
      button_html(:outline, "Hover me")
    end
  end

  # @label All Sides
  # Shows tooltip on different sides
  # @param side select { choices: [top, right, bottom, left] }
  def sides(side: :top)
    render(Shadcn::TooltipComponent.new(text: "Tooltip content", side: side.to_sym)) do
      button_html(:outline, "Hover me")
    end
  end

  # @label With Icon Button
  # Tooltip on an icon-only button
  def with_icon_button
    render(Shadcn::TooltipComponent.new(text: "Add to library")) do
      button_html(:outline, "+", "h-10 w-10 p-0")
    end
  end

  # @label Top
  # Tooltip positioned on top (default)
  def top
    render(Shadcn::TooltipComponent.new(text: "This is a helpful tooltip", side: :top)) do
      button_html(:secondary, "Top")
    end
  end

  # @label Right
  # Tooltip positioned on right side
  def right
    render(Shadcn::TooltipComponent.new(text: "This is a helpful tooltip", side: :right)) do
      button_html(:secondary, "Right")
    end
  end

  # @label Bottom
  # Tooltip positioned on bottom
  def bottom
    render(Shadcn::TooltipComponent.new(text: "This is a helpful tooltip", side: :bottom)) do
      button_html(:secondary, "Bottom")
    end
  end

  # @label Left
  # Tooltip positioned on left side
  def left
    render(Shadcn::TooltipComponent.new(text: "This is a helpful tooltip", side: :left)) do
      button_html(:secondary, "Left")
    end
  end

  # @label With Delay
  # Tooltip with custom delay duration
  def with_delay
    render(Shadcn::TooltipComponent.new(text: "Appears after 1 second", delay_duration: 1000)) do
      button_html(:outline, "Hover (1s delay)")
    end
  end

  # @label Multiple Tooltips
  # Multiple tooltips in a row
  def multiple
    <<~HTML.html_safe
      <div class="flex gap-2">
        #{render(Shadcn::TooltipComponent.new(text: "Edit")) do
          button_html(:ghost, "Edit", "h-10 w-10 p-0")
        end}
        #{render(Shadcn::TooltipComponent.new(text: "Delete")) do
          button_html(:ghost, "Delete", "h-10 w-10 p-0")
        end}
        #{render(Shadcn::TooltipComponent.new(text: "Share")) do
          button_html(:ghost, "Share", "h-10 w-10 p-0")
        end}
      </div>
    HTML
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
