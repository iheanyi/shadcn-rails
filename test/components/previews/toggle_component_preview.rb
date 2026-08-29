# frozen_string_literal: true

# @label Toggle
# @display bg_color "#ffffff"
class ToggleComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic toggle button
  def default
    render(Shadcn::ToggleComponent.new(aria_label: "Toggle bold")) do
      bold_icon
    end
  end

  # @label Pressed
  # Toggle in pressed state
  def pressed
    render(Shadcn::ToggleComponent.new(aria_label: "Toggle italic", pressed: true)) do
      italic_icon
    end
  end

  # @label Disabled
  # Disabled toggle
  def disabled
    render(Shadcn::ToggleComponent.new(aria_label: "Toggle underline", disabled: true)) do
      underline_icon
    end
  end

  # @label With Text
  # Toggle with text content
  def with_text
    render(Shadcn::ToggleComponent.new(aria_label: "Toggle bold")) do
      content_tag(:div, class: "flex items-center gap-2") do
        bold_icon +
        content_tag(:span, "Bold")
      end
    end
  end

  # @label All Variants
  # Shows all available variants
  # @param variant select { choices: [default, outline] }
  def variants(variant: :default)
    render(Shadcn::ToggleComponent.new(variant: variant.to_sym, aria_label: "Toggle")) do
      content_tag(:div, class: "flex items-center gap-2") do
        bold_icon +
        content_tag(:span, variant.to_s.titleize)
      end
    end
  end

  # @label Outline Variant
  # Toggle with outline style
  def outline
    render(Shadcn::ToggleComponent.new(variant: :outline, aria_label: "Toggle bold")) do
      bold_icon
    end
  end

  # @label All Sizes
  # Shows all available sizes
  # @param size select { choices: [sm, default, lg] }
  def sizes(size: :default)
    render(Shadcn::ToggleComponent.new(size: size.to_sym, aria_label: "Toggle")) do
      bold_icon
    end
  end

  # @label Small Size
  # Small toggle button
  def small
    render(Shadcn::ToggleComponent.new(size: :sm, aria_label: "Toggle bold")) do
      bold_icon
    end
  end

  # @label Large Size
  # Large toggle button
  def large
    render(Shadcn::ToggleComponent.new(size: :lg, aria_label: "Toggle bold")) do
      bold_icon
    end
  end

  # @label Text Formatting
  # Multiple toggles for text formatting
  def text_formatting
    render(Shadcn::ToggleComponent.new(aria_label: "Toggle bold")) do
      bold_icon
    end
  end

  # @label Text Alignment
  # Toggles for text alignment
  def text_alignment
    render(Shadcn::ToggleComponent.new(variant: :outline, aria_label: "Align left", pressed: true)) do
      align_left_icon
    end
  end

  # @label With Labels
  # Toggles with text labels
  def with_labels
    render(Shadcn::ToggleComponent.new(variant: :outline, aria_label: "Toggle bold")) do
      content_tag(:div, class: "flex items-center gap-2") do
        bold_icon + content_tag(:span, "Bold", class: "text-sm")
      end
    end
  end

  # @label Disabled State
  # Multiple toggles in disabled state
  def disabled_state
    render(Shadcn::ToggleComponent.new(aria_label: "Toggle bold", disabled: true)) do
      bold_icon
    end
  end

  # @label Interactive Example
  # Toggle with interactive controls
  # @param variant select { choices: [default, outline] }
  # @param size select { choices: [sm, default, lg] }
  # @param pressed toggle
  # @param disabled toggle
  def interactive(variant: :default, size: :default, pressed: false, disabled: false)
    render(Shadcn::ToggleComponent.new(
      variant: variant.to_sym,
      size: size.to_sym,
      pressed: pressed,
      disabled: disabled,
      aria_label: "Toggle"
    )) do
      content_tag(:div, class: "flex items-center gap-2") do
        bold_icon +
        content_tag(:span, "Toggle")
      end
    end
  end

  private

  def bold_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"/>
        <path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"/>
      </svg>
    SVG
  end

  def italic_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="19" y1="4" x2="10" y2="4"/>
        <line x1="14" y1="20" x2="5" y2="20"/>
        <line x1="15" y1="4" x2="9" y2="20"/>
      </svg>
    SVG
  end

  def underline_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M6 4v6a6 6 0 0 0 12 0V4"/>
        <line x1="4" y1="20" x2="20" y2="20"/>
      </svg>
    SVG
  end

  def strikethrough_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M16 4H9a3 3 0 0 0-2.83 4"/>
        <path d="M14 12a4 4 0 0 1 0 8H6"/>
        <line x1="4" y1="12" x2="20" y2="12"/>
      </svg>
    SVG
  end

  def align_left_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="21" y1="6" x2="3" y2="6"/>
        <line x1="15" y1="12" x2="3" y2="12"/>
        <line x1="17" y1="18" x2="3" y2="18"/>
      </svg>
    SVG
  end

  def align_center_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="21" y1="6" x2="3" y2="6"/>
        <line x1="17" y1="12" x2="7" y2="12"/>
        <line x1="19" y1="18" x2="5" y2="18"/>
      </svg>
    SVG
  end

  def align_right_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="21" y1="6" x2="3" y2="6"/>
        <line x1="21" y1="12" x2="9" y2="12"/>
        <line x1="21" y1="18" x2="7" y2="18"/>
      </svg>
    SVG
  end
end
