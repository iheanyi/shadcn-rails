# frozen_string_literal: true

require "test_helper"

class ResizablePanelGroupComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_resizable_container
    render_inline(Shadcn::ResizablePanelGroupComponent.new)

    assert_selector "div[data-controller='shadcn--resizable']"
  end

  def test_renders_with_panel_group_data_attribute
    render_inline(Shadcn::ResizablePanelGroupComponent.new)

    assert_selector "div[data-panel-group]"
  end

  # Direction variants
  def test_renders_horizontal_by_default
    render_inline(Shadcn::ResizablePanelGroupComponent.new)

    assert_selector "[data-shadcn--resizable-direction-value='horizontal']"
    assert_selector "[data-panel-group-direction='horizontal']"
  end

  def test_renders_with_horizontal_flex_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal))

    assert_selector "div.flex.h-full.w-full"
  end

  def test_renders_vertical_direction
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :vertical))

    assert_selector "[data-shadcn--resizable-direction-value='vertical']"
    assert_selector "[data-panel-group-direction='vertical']"
  end

  def test_renders_with_vertical_flex_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :vertical))

    assert_selector "div.flex.flex-col"
  end

  # Auto save ID for persistence
  def test_renders_without_auto_save_id_by_default
    render_inline(Shadcn::ResizablePanelGroupComponent.new)

    assert_no_selector "[data-shadcn--resizable-auto-save-id-value]"
  end

  def test_renders_with_auto_save_id
    render_inline(Shadcn::ResizablePanelGroupComponent.new(auto_save_id: "my-layout"))

    assert_selector "[data-shadcn--resizable-auto-save-id-value='my-layout']"
  end

  # Panels slot
  def test_renders_with_panels
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_panel(default_size: 50) { "Panel 1" }
      group.with_panel(default_size: 50) { "Panel 2" }
    end

    assert_selector "[data-shadcn--resizable-target='panel']", count: 2
    assert_text "Panel 1"
    assert_text "Panel 2"
  end

  def test_panel_has_correct_data_attributes
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_panel(default_size: 30, min_size: 10, max_size: 50) { "Content" }
    end

    assert_selector "[data-panel]"
    assert_selector "[data-panel-size='30']"
    assert_selector "[data-min-size='10']"
    assert_selector "[data-max-size='50']"
  end

  def test_panel_has_flex_basis_style
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_panel(default_size: 40) { "Content" }
    end

    assert_selector "[style*='flex-basis: 40%']"
  end

  # Handle slot
  def test_renders_with_handle
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_panel(default_size: 50) { "Panel 1" }
      group.with_handle
      group.with_panel(default_size: 50) { "Panel 2" }
    end

    assert_selector "[data-shadcn--resizable-target='handle']"
    assert_selector "[data-panel-resize-handle]"
  end

  def test_handle_has_separator_role
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle
    end

    assert_selector "[role='separator']"
  end

  def test_handle_has_tabindex
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle
    end

    assert_selector "[tabindex='0']"
  end

  def test_handle_has_aria_orientation_for_horizontal
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal)) do |group|
      group.with_handle
    end

    # For horizontal resize, the separator orientation is vertical
    assert_selector "[aria-orientation='vertical']"
  end

  def test_handle_has_aria_orientation_for_vertical
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :vertical)) do |group|
      group.with_handle
    end

    # For vertical resize, the separator orientation is horizontal
    assert_selector "[aria-orientation='horizontal']"
  end

  def test_handle_has_resize_actions
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle
    end

    assert_selector "[data-action*='mousedown->shadcn--resizable#startResize']"
    assert_selector "[data-action*='touchstart->shadcn--resizable#startResize']"
  end

  def test_handle_uses_v4_orientation_aware_focus_and_hit_target_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :vertical)) do |group|
      group.with_handle(with_handle: true)
    end

    handle = page.find("[data-shadcn--resizable-target='handle']")
    assert_includes handle["class"], "after:w-1"
    assert_includes handle["class"], "focus-visible:outline-hidden"
    assert_includes handle["class"], "aria-[orientation=horizontal]:after:h-1"
    assert_includes handle["class"], "[&[aria-orientation=horizontal]>div]:rotate-90"
    assert_selector "[aria-orientation='horizontal']"
  end

  # Handle with grip indicator
  def test_handle_with_visible_grip
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle(with_handle: true)
    end

    assert_selector "[data-panel-resize-handle] svg"
  end

  def test_handle_without_visible_grip_by_default
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle
    end

    assert_no_selector "[data-panel-resize-handle] svg"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::ResizablePanelGroupComponent.new(class_name: "h-[200px]"))

    assert_selector "div.h-\\[200px\\]"
  end

  # Complete layout
  def test_renders_complete_two_panel_layout
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal)) do |group|
      group.with_panel(default_size: 50) { "Left" }
      group.with_handle(with_handle: true)
      group.with_panel(default_size: 50) { "Right" }
    end

    assert_selector "[data-controller='shadcn--resizable']"
    assert_selector "[data-shadcn--resizable-target='panel']", count: 2
    assert_selector "[data-shadcn--resizable-target='handle']", count: 1
    assert_text "Left"
    assert_text "Right"
  end

  def test_renders_complete_three_panel_layout
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal)) do |group|
      group.with_panel(default_size: 25) { "One" }
      group.with_handle(with_handle: true)
      group.with_panel(default_size: 50) { "Two" }
      group.with_handle(with_handle: true)
      group.with_panel(default_size: 25) { "Three" }
    end

    assert_selector "[data-shadcn--resizable-target='panel']", count: 3
    assert_selector "[data-shadcn--resizable-target='handle']", count: 2
  end
end
