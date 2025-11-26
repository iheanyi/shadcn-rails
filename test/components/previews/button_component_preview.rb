# frozen_string_literal: true

# @label Button
# @display bg_color "#ffffff"
class ButtonComponentPreview < ViewComponent::Preview
  # @label Default
  # The default button style
  def default
    render(Shadcn::ButtonComponent.new) { "Button" }
  end

  # @label All Variants
  # Shows all available button variants
  # @param variant select { choices: [default, destructive, outline, secondary, ghost, link] }
  def variants(variant: :default)
    render(Shadcn::ButtonComponent.new(variant: variant.to_sym)) { "Button" }
  end

  # @label All Sizes
  # Shows all available button sizes
  # @param size select { choices: [default, sm, lg, icon, icon_sm, icon_lg] }
  def sizes(size: :default)
    if size.to_s.start_with?("icon")
      render(Shadcn::ButtonComponent.new(size: size.to_sym)) do
        '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>'.html_safe
      end
    else
      render(Shadcn::ButtonComponent.new(size: size.to_sym)) { "Button" }
    end
  end

  # @label Destructive
  # Destructive variant for dangerous actions
  def destructive
    render(Shadcn::ButtonComponent.new(variant: :destructive)) { "Delete" }
  end

  # @label Outline
  # Outline variant with border
  def outline
    render(Shadcn::ButtonComponent.new(variant: :outline)) { "Outline" }
  end

  # @label Secondary
  # Secondary variant for less prominent actions
  def secondary
    render(Shadcn::ButtonComponent.new(variant: :secondary)) { "Secondary" }
  end

  # @label Ghost
  # Ghost variant with no background
  def ghost
    render(Shadcn::ButtonComponent.new(variant: :ghost)) { "Ghost" }
  end

  # @label Link
  # Link variant that looks like a text link
  def link
    render(Shadcn::ButtonComponent.new(variant: :link)) { "Link" }
  end

  # @label With Icon
  # Button with an icon and text
  def with_icon
    render(Shadcn::ButtonComponent.new(variant: :outline)) do
      '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="mr-2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg> Login with Email'.html_safe
    end
  end

  # @label Loading
  # Button in loading state
  def loading
    render(Shadcn::ButtonComponent.new(loading: true)) { "Please wait" }
  end

  # @label Disabled
  # Disabled button
  def disabled
    render(Shadcn::ButtonComponent.new(disabled: true)) { "Disabled" }
  end

  # @label As Link
  # Button rendered as an anchor tag
  def as_link
    render(Shadcn::ButtonComponent.new(href: "#", variant: :outline)) { "Go somewhere" }
  end
end
