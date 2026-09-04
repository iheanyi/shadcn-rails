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

  def test_renders_upstream_command_slot_and_classes
    render_inline(Shadcn::CommandComponent.new)

    assert_selector "div[data-slot='command']"
    assert_includes rendered_content, "flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground"
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

  def test_dialog_uses_upstream_overlay_content_and_command_tokens
    render_inline(Shadcn::CommandDialogComponent.new) do |dialog|
      dialog.with_command
    end

    assert_includes rendered_content, "bg-black/50"
    assert_includes rendered_content, "overflow-hidden p-0"
    assert_includes rendered_content, "**:data-[slot=command-input-wrapper]:h-12"
    refute_includes rendered_content, "bg-black/80"
    refute_includes rendered_content, "[&amp;_[data-shadcn--command-target=&#39;input&#39;]]:h-12"
    refute_includes rendered_content, "rounded-lg border shadow-md md:min-w-[450px]"
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

  def test_uses_upstream_input_wrapper_icon_and_input_tokens
    render_inline(Shadcn::CommandInputComponent.new)

    assert_selector "div[data-slot='command-input-wrapper']"
    assert_selector "input[data-slot='command-input']"
    assert_includes rendered_content, "flex h-9 items-center gap-2 border-b px-3"
    assert_includes rendered_content, "size-4 shrink-0 opacity-50"
    assert_includes rendered_content, "outline-hidden"
    refute_includes rendered_content, "flex items-center border-b px-3"
    refute_includes rendered_content, "mr-2 h-4 w-4"
    refute_includes rendered_content, "outline-none"
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

  def test_uses_upstream_list_tokens
    render_inline(Shadcn::CommandListComponent.new)

    assert_selector "div[data-slot='command-list']"
    assert_includes rendered_content, "max-h-[300px] scroll-py-1 overflow-x-hidden overflow-y-auto"
    refute_includes rendered_content, "max-h-[300px] overflow-y-auto overflow-x-hidden"
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

  def test_uses_upstream_group_slot_and_heading_tokens
    render_inline(Shadcn::CommandGroupComponent.new(heading: "Applications"))

    assert_selector "div[data-slot='command-group']"
    assert_includes rendered_content, "[&amp;_[cmdk-group-heading]]:px-2"
    assert_includes rendered_content, "[&amp;_[cmdk-group-heading]]:text-muted-foreground"
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

  def test_uses_upstream_item_slot_and_svg_tokens
    render_inline(Shadcn::CommandItemComponent.new(value: "calendar")) { "Calendar" }

    assert_selector "div[data-slot='command-item']"
    assert_includes rendered_content, "relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none"
    assert_includes rendered_content, "[&amp;_svg:not([class*=&#39;size-&#39;])]:size-4"
    assert_includes rendered_content, "[&amp;_svg:not([class*=&#39;text-&#39;])]:text-muted-foreground"
    refute_includes rendered_content, "outline-none"
    refute_includes rendered_content, "[&amp;_svg]:size-4"
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

  def test_uses_upstream_empty_slot_and_tokens
    render_inline(Shadcn::CommandEmptyComponent.new)

    assert_selector "div[data-slot='command-empty']"
    assert_includes rendered_content, "py-6 text-center text-sm"
    refute_includes rendered_content, "py-6 text-center text-sm text-muted-foreground"
  end
end

class CommandSeparatorComponentTest < ViewComponent::TestCase
  def test_renders_separator
    render_inline(Shadcn::CommandSeparatorComponent.new)

    assert_selector "div[role='separator']"
  end

  def test_uses_upstream_separator_slot_and_tokens
    render_inline(Shadcn::CommandSeparatorComponent.new)

    assert_selector "div[data-slot='command-separator']"
    assert_includes rendered_content, "-mx-1 h-px bg-border"
  end
end

class CommandShortcutComponentTest < ViewComponent::TestCase
  def test_renders_shortcut
    render_inline(Shadcn::CommandShortcutComponent.new) { "⌘K" }

    assert_selector "span", text: "⌘K"
  end

  def test_uses_upstream_shortcut_slot_and_tokens
    render_inline(Shadcn::CommandShortcutComponent.new) { "⌘K" }

    assert_selector "span[data-slot='command-shortcut']"
    assert_includes rendered_content, "ml-auto text-xs tracking-widest text-muted-foreground"
  end
end
