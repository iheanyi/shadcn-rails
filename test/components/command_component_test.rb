# frozen_string_literal: true

require "test_helper"

class CommandComponentTest < ViewComponent::TestCase
  def test_renders_command
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_input(placeholder: "Search...")
      command.with_list do |list|
        list.with_group(heading: "Suggestions") do |group|
          group.with_item(value: "calendar") { "Calendar" }
        end
      end
    end

    assert_selector "div[data-controller='shadcn--command']"
    assert_selector "input[placeholder='Search...']"
  end

  def test_renders_with_empty_state
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_input
      command.with_list do |list|
        list.with_empty { "No results found." }
      end
    end

    assert_selector "div[data-shadcn--command-target='empty']", text: "No results found."
  end

  def test_renders_groups_with_headings
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_group(heading: "Applications") do |group|
          group.with_item(value: "calendar") { "Calendar" }
        end
        list.with_group(heading: "Settings") do |group|
          group.with_item(value: "profile") { "Profile" }
        end
      end
    end

    assert_selector "div[role='group']", count: 2
    assert_text "Applications"
    assert_text "Settings"
  end

  def test_renders_items_with_values
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_group do |group|
          group.with_item(value: "calendar") { "Calendar" }
          group.with_item(value: "search") { "Search" }
        end
      end
    end

    assert_selector "div[data-value='calendar']", text: "Calendar"
    assert_selector "div[data-value='search']", text: "Search"
  end

  def test_renders_disabled_items
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_group do |group|
          group.with_item(value: "disabled-item", disabled: true) { "Disabled Item" }
        end
      end
    end

    assert_selector "div[data-disabled='true']", text: "Disabled Item"
  end

  def test_renders_items_with_shortcuts
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_group do |group|
          group.with_item(value: "calendar") do |item|
            item.with_shortcut { "⌘K" }
            "Calendar"
          end
        end
      end
    end

    assert_text "⌘K"
  end

  def test_renders_separator
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_group(heading: "Group 1") do |group|
          group.with_item(value: "item1") { "Item 1" }
        end
        list.with_separator
        list.with_group(heading: "Group 2") do |group|
          group.with_item(value: "item2") { "Item 2" }
        end
      end
    end

    assert_selector "div[role='separator']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::CommandComponent.new(class_name: "custom-command"))

    assert_selector "div.custom-command"
  end

  def test_input_has_search_icon
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_input
    end

    assert_selector "svg"
  end

  def test_keyboard_navigation_data_attributes
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_group do |group|
          group.with_item(value: "test") { "Test" }
        end
      end
    end

    assert_selector "div[data-action='keydown->shadcn--command#handleKeydown']"
    assert_selector "div[data-shadcn--command-target='item']"
  end

  def test_renders_direct_items_in_list
    render_inline(Shadcn::CommandComponent.new) do |command|
      command.with_list do |list|
        list.with_item(value: "direct1") { "Direct Item 1" }
        list.with_item(value: "direct2") { "Direct Item 2" }
      end
    end

    assert_selector "div[data-value='direct1']", text: "Direct Item 1"
    assert_selector "div[data-value='direct2']", text: "Direct Item 2"
  end
end

class CommandDialogComponentTest < ViewComponent::TestCase
  def test_renders_command_dialog
    render_inline(Shadcn::CommandDialogComponent.new) do |dialog|
      dialog.with_trigger { "Open" }
      dialog.with_command do |command|
        command.with_input
        command.with_list do |list|
          list.with_group do |group|
            group.with_item(value: "test") { "Test" }
          end
        end
      end
    end

    assert_selector "div[data-controller='shadcn--command-dialog']"
  end

  def test_renders_with_keyboard_shortcut
    render_inline(Shadcn::CommandDialogComponent.new(shortcut: "k")) do |dialog|
      dialog.with_trigger { "Open" }
      dialog.with_command
    end

    assert_selector "div[data-shadcn--command-dialog-shortcut-value='k']"
  end

  def test_renders_trigger
    render_inline(Shadcn::CommandDialogComponent.new) do |dialog|
      dialog.with_trigger { "Open Command Palette" }
    end

    assert_selector "div[data-action='click->shadcn--command-dialog#open']", text: "Open Command Palette"
  end

  def test_renders_dialog_template
    render_inline(Shadcn::CommandDialogComponent.new) do |dialog|
      dialog.with_command do |command|
        command.with_input(placeholder: "Search...")
      end
    end

    # Template elements are not visible in Capybara, check the raw HTML
    assert_includes rendered_content, "data-shadcn--command-dialog-target=\"template\""
  end
end

class CommandInputComponentTest < ViewComponent::TestCase
  def test_renders_input
    render_inline(Shadcn::CommandInputComponent.new)

    assert_selector "input[type='text']"
    assert_selector "input[placeholder='Type a command or search...']"
  end

  def test_renders_with_custom_placeholder
    render_inline(Shadcn::CommandInputComponent.new(placeholder: "Search commands..."))

    assert_selector "input[placeholder='Search commands...']"
  end

  def test_renders_with_autofocus
    render_inline(Shadcn::CommandInputComponent.new(autofocus: true))

    assert_selector "input[autofocus]"
  end

  def test_renders_search_icon
    render_inline(Shadcn::CommandInputComponent.new)

    assert_selector "svg"
  end

  def test_has_filter_action
    render_inline(Shadcn::CommandInputComponent.new)

    assert_selector "input[data-action='input->shadcn--command#filter']"
  end
end

class CommandListComponentTest < ViewComponent::TestCase
  def test_renders_list
    render_inline(Shadcn::CommandListComponent.new)

    assert_selector "div[data-shadcn--command-target='list']"
  end

  def test_renders_with_empty_state
    render_inline(Shadcn::CommandListComponent.new) do |list|
      list.with_empty { "Nothing here" }
    end

    assert_selector "div[data-shadcn--command-target='empty']", text: "Nothing here"
  end
end

class CommandGroupComponentTest < ViewComponent::TestCase
  def test_renders_group
    render_inline(Shadcn::CommandGroupComponent.new)

    assert_selector "div[role='group']"
    assert_selector "div[data-shadcn--command-target='group']"
  end

  def test_renders_with_heading
    render_inline(Shadcn::CommandGroupComponent.new(heading: "Applications"))

    assert_text "Applications"
  end

  def test_renders_items
    render_inline(Shadcn::CommandGroupComponent.new) do |group|
      group.with_item(value: "test") { "Test Item" }
    end

    assert_text "Test Item"
  end
end

class CommandItemComponentTest < ViewComponent::TestCase
  def test_renders_item
    render_inline(Shadcn::CommandItemComponent.new) { "Calendar" }

    assert_selector "div[role='option']", text: "Calendar"
    assert_selector "div[data-shadcn--command-target='item']"
  end

  def test_renders_with_value
    render_inline(Shadcn::CommandItemComponent.new(value: "calendar")) { "Calendar" }

    assert_selector "div[data-value='calendar']"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::CommandItemComponent.new(disabled: true)) { "Disabled" }

    assert_selector "div[data-disabled='true']"
    assert_no_selector "div[tabindex='0']"
  end

  def test_renders_with_shortcut
    render_inline(Shadcn::CommandItemComponent.new) do |item|
      item.with_shortcut { "⌘K" }
      "Open"
    end

    assert_text "⌘K"
  end

  def test_has_click_action
    render_inline(Shadcn::CommandItemComponent.new(value: "test")) { "Test" }

    assert_selector "div[data-action='click->shadcn--command#select']"
  end
end

class CommandEmptyComponentTest < ViewComponent::TestCase
  def test_renders_default_message
    render_inline(Shadcn::CommandEmptyComponent.new)

    assert_text "No results found."
  end

  def test_renders_custom_message
    render_inline(Shadcn::CommandEmptyComponent.new) { "Nothing to show" }

    assert_text "Nothing to show"
  end

  def test_has_target_attribute
    render_inline(Shadcn::CommandEmptyComponent.new)

    assert_selector "div[data-shadcn--command-target='empty']"
  end
end

class CommandSeparatorComponentTest < ViewComponent::TestCase
  def test_renders_separator
    render_inline(Shadcn::CommandSeparatorComponent.new)

    assert_selector "div[role='separator']"
  end
end

class CommandShortcutComponentTest < ViewComponent::TestCase
  def test_renders_shortcut
    render_inline(Shadcn::CommandShortcutComponent.new) { "⌘K" }

    assert_selector "span", text: "⌘K"
  end
end
