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
    render(Shadcn::ToggleGroupComponent.new(type: :single, default_value: "center")) do |group|
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

  # @label Disabled
  # Toggle group with disabled items
  def disabled
    render(Shadcn::ToggleGroupComponent.new(type: :single, disabled: true)) do |group|
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
end
