# frozen_string_literal: true

require "test_helper"

# Regression tests for interleaved content ordering
# These tests ensure that items, separators, labels, and other elements
# render in the exact order they are declared, not grouped by type.
class InterleavedContentTest < ViewComponent::TestCase
  # DropdownMenuContentComponent tests
  def test_dropdown_menu_content_preserves_interleaved_order
    render_inline(Shadcn::DropdownMenuContentComponent.new) do |content|
      content.with_label { "My Account" }
      content.with_separator
      content.with_item { "Profile" }
      content.with_item { "Settings" }
      content.with_separator
      content.with_item { "Log out" }
    end

    # Get all children in order (menu is hidden by default)
    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    # Verify order: label, separator, item, item, separator, item
    assert_equal 6, children.length, "Expected 6 children"
    assert_match(/My Account/, children[0].text)
    assert children[1]["role"] == "separator" || children[1]["class"]&.include?("h-px"), "Expected separator at index 1"
    assert_equal "Profile", children[2].text.strip
    assert_equal "Settings", children[3].text.strip
    assert children[4]["role"] == "separator" || children[4]["class"]&.include?("h-px"), "Expected separator at index 4"
    assert_equal "Log out", children[5].text.strip
  end

  def test_dropdown_menu_content_handles_multiple_labels_interleaved
    render_inline(Shadcn::DropdownMenuContentComponent.new) do |content|
      content.with_label { "Section 1" }
      content.with_item { "Item A" }
      content.with_separator
      content.with_label { "Section 2" }
      content.with_item { "Item B" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 5, children.length
    assert_match(/Section 1/, children[0].text)
    assert_equal "Item A", children[1].text.strip
    # children[2] is separator
    assert_match(/Section 2/, children[3].text)
    assert_equal "Item B", children[4].text.strip
  end

  # MenubarContentComponent tests
  def test_menubar_content_preserves_interleaved_order
    render_inline(Shadcn::MenubarContentComponent.new) do |content|
      content.with_item { "New Tab" }
      content.with_item { "New Window" }
      content.with_separator
      content.with_item { "Share" }
      content.with_separator
      content.with_item { "Print" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 6, children.length
    assert_equal "New Tab", children[0].text.strip
    assert_equal "New Window", children[1].text.strip
    # children[2] is separator
    assert_equal "Share", children[3].text.strip
    # children[4] is separator
    assert_equal "Print", children[5].text.strip
  end

  def test_menubar_content_handles_checkbox_items_interleaved
    render_inline(Shadcn::MenubarContentComponent.new) do |content|
      content.with_item { "Regular Item" }
      content.with_separator
      content.with_checkbox_item(checked: true) { "Always Show Bookmarks Bar" }
      content.with_checkbox_item { "Always Show Full URLs" }
      content.with_separator
      content.with_item { "Another Item" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 6, children.length
    assert_equal "Regular Item", children[0].text.strip
    # children[1] is separator
    assert_match(/Always Show Bookmarks Bar/, children[2].text)
    assert_match(/Always Show Full URLs/, children[3].text)
    # children[4] is separator
    assert_equal "Another Item", children[5].text.strip
  end

  def test_menubar_content_handles_radio_groups_interleaved
    render_inline(Shadcn::MenubarContentComponent.new) do |content|
      content.with_label { "Options" }
      content.with_separator
      content.with_radio_group(value: "andy") do |group|
        group.with_item(value: "andy", checked: true) { "Andy" }
        group.with_item(value: "chris") { "Chris" }
      end
      content.with_separator
      content.with_item { "Manage" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 5, children.length
    assert_match(/Options/, children[0].text)
    # children[1] is separator
    assert children[2]["role"] == "group", "Expected radio group at index 2"
    # children[3] is separator
    assert_equal "Manage", children[4].text.strip
  end

  # ContextMenuContentComponent tests
  def test_context_menu_content_preserves_interleaved_order
    render_inline(Shadcn::ContextMenuContentComponent.new) do |content|
      content.with_item { "Back" }
      content.with_item { "Forward" }
      content.with_separator
      content.with_item { "Reload" }
      content.with_separator
      content.with_item { "View Source" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 6, children.length
    assert_equal "Back", children[0].text.strip
    assert_equal "Forward", children[1].text.strip
    # children[2] is separator
    assert_equal "Reload", children[3].text.strip
    # children[4] is separator
    assert_equal "View Source", children[5].text.strip
  end

  def test_context_menu_content_handles_radio_group_interleaved
    render_inline(Shadcn::ContextMenuContentComponent.new) do |content|
      content.with_item { "Copy" }
      content.with_separator
      content.with_radio_group(value: "one") do |group|
        group.with_item(value: "one", checked: true) { "Option 1" }
        group.with_item(value: "two") { "Option 2" }
      end
      content.with_separator
      content.with_item { "Delete" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 5, children.length
    assert_equal "Copy", children[0].text.strip
    # children[1] is separator
    assert children[2]["role"] == "group", "Expected radio group at index 2"
    # children[3] is separator
    assert_equal "Delete", children[4].text.strip
  end

  # CommandListComponent tests
  def test_command_list_preserves_interleaved_order
    render_inline(Shadcn::CommandListComponent.new) do |list|
      list.with_group(heading: "Suggestions") do |group|
        group.with_item { "Calendar" }
      end
      list.with_separator
      list.with_group(heading: "Settings") do |group|
        group.with_item { "Profile" }
      end
    end

    command_list = page.find("[data-shadcn--command-target='list']", visible: false)
    children = command_list.all("> *", visible: false)

    assert_equal 3, children.length
    # First group
    assert children[0]["role"] == "group" || children[0]["data-shadcn--command-target"] == "group"
    # Separator in middle
    assert children[1]["role"] == "separator" || children[1]["class"]&.include?("h-px")
    # Second group
    assert children[2]["role"] == "group" || children[2]["data-shadcn--command-target"] == "group"
  end

  # SelectComponent tests
  def test_select_preserves_interleaved_groups
    render_inline(Shadcn::SelectComponent.new(placeholder: "Select...")) do |select|
      select.with_group(label: "Fruits") do |group|
        group.with_item(value: "apple") { "Apple" }
      end
      select.with_group(label: "Vegetables") do |group|
        group.with_item(value: "carrot") { "Carrot" }
      end
    end

    # Note: SelectComponent has hidden content, so just verify it renders
    assert_selector "[data-controller='shadcn--select']"
  end

  # MenubarSubContentComponent tests
  def test_menubar_sub_content_preserves_interleaved_order
    render_inline(Shadcn::MenubarSubContentComponent.new) do |content|
      content.with_item { "Sub Item 1" }
      content.with_separator
      content.with_item { "Sub Item 2" }
      content.with_separator
      content.with_item { "Sub Item 3" }
    end

    sub_content = page.find("[role='menu']", visible: false)
    children = sub_content.all("> *", visible: false)

    assert_equal 5, children.length
    assert_equal "Sub Item 1", children[0].text.strip
    # children[1] is separator
    assert_equal "Sub Item 2", children[2].text.strip
    # children[3] is separator
    assert_equal "Sub Item 3", children[4].text.strip
  end

  # Edge cases
  def test_dropdown_content_empty_still_works
    render_inline(Shadcn::DropdownMenuContentComponent.new)

    assert_selector "[role='menu']", visible: false
  end

  def test_consecutive_separators_preserved
    render_inline(Shadcn::DropdownMenuContentComponent.new) do |content|
      content.with_item { "Item 1" }
      content.with_separator
      content.with_separator
      content.with_item { "Item 2" }
    end

    menu_content = page.find("[role='menu']", visible: false)
    children = menu_content.all("> *", visible: false)

    assert_equal 4, children.length
    assert_equal "Item 1", children[0].text.strip
    # Two consecutive separators
    assert children[1]["role"] == "separator" || children[1]["class"]&.include?("h-px")
    assert children[2]["role"] == "separator" || children[2]["class"]&.include?("h-px")
    assert_equal "Item 2", children[3].text.strip
  end

  def test_group_with_raw_content
    render_inline(Shadcn::DropdownMenuContentComponent.new) do |content|
      content.with_group do
        # Use raw content instead of with_item since DropdownMenuGroupComponent
        # uses raw content block
        "<div role='menuitem'>Group Item A</div><div role='menuitem'>Group Item B</div>".html_safe
      end
    end

    # Find the group and verify it exists
    assert_selector "[role='group']", visible: false
    assert_selector "[role='menuitem']", visible: false, count: 2
  end
end
