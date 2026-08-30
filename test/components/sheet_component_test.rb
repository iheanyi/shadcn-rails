# frozen_string_literal: true

require "test_helper"

class SheetComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_sheet_container
    render_inline(Shadcn::SheetComponent.new)

    assert_selector "div[data-controller='shadcn--sheet']"
  end

  def test_renders_with_trigger_slot
    render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_trigger { "Open Sheet" }
    end

    assert_selector "[data-shadcn--sheet-target='trigger']", text: "Open Sheet"
    assert_selector "[data-action='click->shadcn--sheet#open']"
  end

  def test_renders_with_body_slot
    render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body { "Sheet content" }
    end

    # Body renders inside a template tag with target='template'
    assert_selector "template[data-shadcn--sheet-target='template']", visible: false
  end

  # Side variants
  def test_renders_with_right_side
    render_inline(Shadcn::SheetComponent.new(side: :right))

    assert_selector "[data-shadcn--sheet-side-value='right']"
  end

  def test_renders_with_left_side
    render_inline(Shadcn::SheetComponent.new(side: :left))

    assert_selector "[data-shadcn--sheet-side-value='left']"
  end

  def test_renders_with_top_side
    render_inline(Shadcn::SheetComponent.new(side: :top))

    assert_selector "[data-shadcn--sheet-side-value='top']"
  end

  def test_renders_with_bottom_side
    render_inline(Shadcn::SheetComponent.new(side: :bottom))

    assert_selector "[data-shadcn--sheet-side-value='bottom']"
  end

  # Open state
  def test_renders_closed_by_default
    render_inline(Shadcn::SheetComponent.new)

    assert_selector "[data-shadcn--sheet-open-value='false']"
  end

  def test_renders_open_when_specified
    render_inline(Shadcn::SheetComponent.new(open: true))

    assert_selector "[data-shadcn--sheet-open-value='true']"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::SheetComponent.new(class_name: "my-sheet"))

    assert_selector "div.my-sheet"
  end

  # Stimulus integration
  def test_has_stimulus_controller
    render_inline(Shadcn::SheetComponent.new)

    assert_selector "[data-controller='shadcn--sheet']"
  end

  def test_trigger_has_click_action
    render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_trigger { "Click me" }
    end

    assert_selector "[data-action='click->shadcn--sheet#open']"
  end

  # Content structure
  def test_renders_both_trigger_and_body
    render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_trigger { "Open" }
      sheet.with_body { "Content" }
    end

    assert_selector "[data-shadcn--sheet-target='trigger']"
    # Body renders inside a template tag
    assert_selector "template[data-shadcn--sheet-target='template']", visible: false
  end

  def test_close_button_uses_ghost_hover_and_keyboard_focus_styles
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body { "Content" }
    end

    html = result.to_html
    close_button_match = html.match(/<button type="button" class="([^"]*)"[^>]*aria-label="Close"/)
    assert close_button_match

    close_classes = close_button_match[1].split
    assert_includes close_classes, "hover:bg-accent"
    assert_includes close_classes, "hover:text-accent-foreground"
    assert_includes close_classes, "focus-visible:ring-2"
    refute_includes close_classes, "focus:ring-2"
    refute_includes close_classes, "ring-offset-2"
    refute_includes close_classes, "ring-offset-background"
    refute close_classes.any? { |class_name| class_name.start_with?("data-[state=open]:") }
  end
end
