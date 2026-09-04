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

    assert_selector "div.flex.h-full"
  end

  def test_panel_group_matches_new_york_v4_classes_and_slot
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :horizontal))

    group = page.find("[data-controller='shadcn--resizable']")
    class_tokens = group[:class].split

    assert_equal "resizable-panel-group", group["data-slot"]
    assert_equal "horizontal", group["aria-orientation"]
    assert_includes class_tokens, "flex"
    assert_includes class_tokens, "h-full"
    assert_includes class_tokens, "w-full"
    assert_includes class_tokens, "aria-[orientation=vertical]:flex-col"
  end

  def test_renders_vertical_direction
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :vertical))

    assert_selector "[data-shadcn--resizable-direction-value='vertical']"
    assert_selector "[data-panel-group-direction='vertical']"
  end

  def test_renders_with_vertical_flex_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new(direction: :vertical))

    group = page.find("[data-controller='shadcn--resizable']")
    class_tokens = group[:class].split

    assert_selector "div.flex"
    assert_equal "vertical", group["aria-orientation"]
    assert_includes class_tokens, "aria-[orientation=vertical]:flex-col"
    refute_includes class_tokens, "flex-col"
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

    panel = page.find("[data-panel]")

    assert_equal "resizable-panel", panel["data-slot"]
    assert_selector "[data-panel-size='30']"
    assert_selector "[data-min-size='10']"
    assert_selector "[data-max-size='50']"
  end

  def test_panel_does_not_add_non_upstream_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_panel(default_size: 30) { "Content" }
    end

    panel = page.find("[data-panel]")
    classes = panel[:class].to_s.split

    refute_includes classes, "relative"
    refute_includes classes, "overflow-hidden"
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

    handle = page.find("[data-shadcn--resizable-target='handle']")

    assert_equal "resizable-handle", handle["data-slot"]
    assert_selector "[data-panel-resize-handle]"
  end

  def test_handle_matches_new_york_v4_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle(with_handle: true)
    end

    handle = page.find("[data-panel-resize-handle]")
    class_tokens = handle[:class].split

    %w[
      relative
      flex
      w-px
      items-center
      justify-center
      bg-border
      after:absolute
      after:inset-y-0
      after:left-1/2
      after:w-1
      after:-translate-x-1/2
      focus-visible:ring-1
      focus-visible:ring-ring
      focus-visible:ring-offset-1
      focus-visible:outline-hidden
      aria-[orientation=horizontal]:h-px
      aria-[orientation=horizontal]:w-full
      aria-[orientation=horizontal]:after:left-0
      aria-[orientation=horizontal]:after:h-1
      aria-[orientation=horizontal]:after:w-full
      aria-[orientation=horizontal]:after:translate-x-0
      aria-[orientation=horizontal]:after:-translate-y-1/2
      [&[aria-orientation=horizontal]>div]:rotate-90
    ].each do |class_name|
      assert_includes class_tokens, class_name
    end

    refute_includes class_tokens, "focus-visible:outline-none"
    refute_includes class_tokens, "hover:bg-primary/50"
    refute_includes class_tokens, "transition-colors"
    refute_includes class_tokens, "[&[data-state=dragging]]:bg-primary"
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

  def test_handle_grip_indicator_matches_new_york_v4_classes
    render_inline(Shadcn::ResizablePanelGroupComponent.new) do |group|
      group.with_handle(with_handle: true)
    end

    indicator = page.find("[data-panel-resize-handle] > div")
    indicator_tokens = indicator[:class].split
    grip_tokens = page.find("[data-panel-resize-handle] svg")[:class].split

    %w[z-10 flex h-4 w-3 items-center justify-center rounded-xs border bg-border].each do |class_name|
      assert_includes indicator_tokens, class_name
    end

    assert_includes grip_tokens, "size-2.5"
    refute_includes indicator_tokens, "rounded-sm"
    refute_includes indicator_tokens, "w-4"
    refute_includes indicator_tokens, "h-3"
    refute_includes grip_tokens, "h-2.5"
    refute_includes grip_tokens, "w-2.5"
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
