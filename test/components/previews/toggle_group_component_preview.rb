# frozen_string_literal: true

# @label Toggle Group
# @display bg_color "#ffffff"
class ToggleGroupComponentPreview < ViewComponent::Preview
  # @label Default (Single)
  # Toggle group with single selection
  def default
    render(Shadcn::ToggleGroupComponent.new(type: :single)) do |group|
      group.with_item(value: "bold") do
        bold_icon
      end
      group.with_item(value: "italic") do
        italic_icon
      end
      group.with_item(value: "underline") do
        underline_icon
      end
    end
  end

  # @label Multiple Selection
  # Toggle group with multiple selection
  def multiple
    render(Shadcn::ToggleGroupComponent.new(type: :multiple)) do |group|
      group.with_item(value: "bold") do
        bold_icon
      end
      group.with_item(value: "italic") do
        italic_icon
      end
      group.with_item(value: "underline") do
        underline_icon
      end
    end
  end

  # @label Outline Variant
  # Toggle group with outline variant
  def outline
    render(Shadcn::ToggleGroupComponent.new(type: :single, variant: :outline)) do |group|
      group.with_item(value: "left") do
        align_left_icon
      end
      group.with_item(value: "center") do
        align_center_icon
      end
      group.with_item(value: "right") do
        align_right_icon
      end
    end
  end

  # @label With Default Value
  # Toggle group with default selected value
  def with_default_value
    render(Shadcn::ToggleGroupComponent.new(type: :single, value: "center")) do |group|
      group.with_item(value: "left", aria_label: "Align left") do
        align_left_icon
      end
      group.with_item(value: "center", pressed: true, aria_label: "Align center") do
        align_center_icon
      end
      group.with_item(value: "right", aria_label: "Align right") do
        align_right_icon
      end
    end
  end

  # @label Small Size
  # Toggle group with small size
  def small
    render(Shadcn::ToggleGroupComponent.new(type: :single, size: :sm)) do |group|
      group.with_item(value: "bold") do
        bold_icon
      end
      group.with_item(value: "italic") do
        italic_icon
      end
      group.with_item(value: "underline") do
        underline_icon
      end
    end
  end

  # @label Large Size
  # Toggle group with large size
  def large
    render(Shadcn::ToggleGroupComponent.new(type: :single, size: :lg)) do |group|
      group.with_item(value: "bold") do
        bold_icon
      end
      group.with_item(value: "italic") do
        italic_icon
      end
      group.with_item(value: "underline") do
        underline_icon
      end
    end
  end

  # @label Disabled Items
  # Toggle group with some disabled items
  def disabled
    render(Shadcn::ToggleGroupComponent.new(type: :single, variant: :outline)) do |group|
      group.with_item(value: "bold", aria_label: "Bold") do
        bold_icon
      end
      group.with_item(value: "italic", disabled: true, aria_label: "Italic (disabled)") do
        italic_icon
      end
      group.with_item(value: "underline", aria_label: "Underline") do
        underline_icon
      end
    end
  end

  # @label All Variants
  # Interactive preview showing all variants
  # @param variant select { choices: [default, outline] }
  def variants(variant: :default)
    render(Shadcn::ToggleGroupComponent.new(type: :single, variant: variant.to_sym)) do |group|
      group.with_item(value: "left", aria_label: "Align left") do
        align_left_icon
      end
      group.with_item(value: "center", aria_label: "Align center") do
        align_center_icon
      end
      group.with_item(value: "right", aria_label: "Align right") do
        align_right_icon
      end
    end
  end

  # @label All Sizes
  # Interactive preview showing all sizes
  # @param size select { choices: [sm, default, lg] }
  def sizes(size: :default)
    render(Shadcn::ToggleGroupComponent.new(type: :single, size: size.to_sym, variant: :outline)) do |group|
      group.with_item(value: "bold", aria_label: "Bold") do
        bold_icon
      end
      group.with_item(value: "italic", aria_label: "Italic") do
        italic_icon
      end
      group.with_item(value: "underline", aria_label: "Underline") do
        underline_icon
      end
    end
  end

  # @label With Text Content
  # Toggle group with text instead of icons
  def with_text
    render(Shadcn::ToggleGroupComponent.new(type: :single, variant: :outline)) do |group|
      group.with_item(value: "a") { "A" }
      group.with_item(value: "b") { "B" }
      group.with_item(value: "c") { "C" }
    end
  end

  # @label Multiple With Values
  # Multiple selection mode with pre-selected values
  def multiple_with_values
    render(Shadcn::ToggleGroupComponent.new(type: :multiple, value: ["bold", "italic"], variant: :outline)) do |group|
      group.with_item(value: "bold", pressed: true, aria_label: "Toggle bold") do
        bold_icon
      end
      group.with_item(value: "italic", pressed: true, aria_label: "Toggle italic") do
        italic_icon
      end
      group.with_item(value: "underline", aria_label: "Toggle underline") do
        underline_icon
      end
      group.with_item(value: "strikethrough", aria_label: "Toggle strikethrough") do
        strikethrough_icon
      end
    end
  end

  # @label Text Formatting Toolbar
  # Complete text formatting example
  def text_formatting_toolbar
    render(Shadcn::ToggleGroupComponent.new(type: :multiple, variant: :outline, name: "formatting")) do |group|
      group.with_item(value: "bold", aria_label: "Toggle bold") do
        bold_icon
      end
      group.with_item(value: "italic", aria_label: "Toggle italic") do
        italic_icon
      end
      group.with_item(value: "underline", aria_label: "Toggle underline") do
        underline_icon
      end
      group.with_item(value: "strikethrough", aria_label: "Toggle strikethrough") do
        strikethrough_icon
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

  def strikethrough_icon
    <<~SVG.html_safe
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M16 4H9a3 3 0 0 0-2.83 4"/>
        <path d="M14 12a4 4 0 0 1 0 8H6"/>
        <line x1="4" x2="20" y1="12" y2="12"/>
      </svg>
    SVG
  end
end
