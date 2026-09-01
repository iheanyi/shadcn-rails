# frozen_string_literal: true

require "test_helper"

class ComboboxComponentTest < ViewComponent::TestCase
  def frameworks
    [
      { value: "next", label: "Next.js" },
      { value: "remix", label: "Remix" },
      { value: "rails", label: "Ruby on Rails" },
      { value: "nuxt", label: "Nuxt.js" },
      { value: "svelte", label: "SvelteKit" }
    ]
  end

  def test_renders_combobox
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    assert_selector "div[data-controller='shadcn--combobox']"
    assert_selector "button[role='combobox']"
  end

  def test_renders_with_placeholder
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      placeholder: "Select framework..."
    ))

    assert_text "Select framework..."
  end

  def test_renders_with_selected_value
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      value: "rails"
    ))

    assert_text "Ruby on Rails"
    # Check raw HTML for hidden content
    assert_includes rendered_content, 'data-selected="true"'
  end

  def test_renders_all_items
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    frameworks.each do |framework|
      # Items are in hidden popover content, check raw HTML
      assert_includes rendered_content, "data-value=\"#{framework[:value]}\""
    end
  end

  def test_renders_search_input
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      search_placeholder: "Search framework..."
    ))

    # Input is in hidden content, check raw HTML
    assert_includes rendered_content, 'placeholder="Search framework..."'
    assert_includes rendered_content, 'data-shadcn--combobox-target="input"'
  end

  def test_renders_empty_state
    render_inline(Shadcn::ComboboxComponent.new(
      items: [],
      empty_text: "No frameworks found."
    ))

    assert_text "No frameworks found."
  end

  def test_renders_with_name_for_form
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      name: "project[framework]"
    ))

    # Hidden input, check raw HTML
    assert_includes rendered_content, 'type="hidden"'
    assert_includes rendered_content, 'name="project[framework]"'
  end

  def test_renders_with_custom_width
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      width: "w-[300px]"
    ))

    assert_selector "button.w-\\[300px\\]"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      disabled: true
    ))

    assert_selector "button[disabled]"
  end

  def test_trigger_uses_new_york_v4_button_outline_classes
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    assert_includes rendered_content, "transition-all"
    assert_includes rendered_content, "outline-none"
    assert_includes rendered_content, "focus-visible:border-ring"
    assert_includes rendered_content, "focus-visible:ring-[3px]"
    assert_includes rendered_content, "focus-visible:ring-ring/50"
    assert_includes rendered_content, "shadow-xs"
    assert_includes rendered_content, "has-[&gt;svg]:px-3"

    refute_includes rendered_content, "focus-visible:ring-1"
    refute_includes rendered_content, "focus-visible:ring-ring\""
    refute_includes rendered_content, "border-input bg-background shadow-sm"
  end

  def test_icons_use_size_4_token
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    assert_includes rendered_content, "ml-2 size-4 shrink-0 opacity-50"
    assert_includes rendered_content, "mr-2 size-4 shrink-0 opacity-50"

    refute_includes rendered_content, "h-4 w-4"
  end

  def test_renders_with_aria_attributes
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    assert_selector "button[role='combobox']"
    assert_selector "button[aria-expanded='false']"
  end

  def test_renders_check_icon_for_selected_item
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      value: "rails"
    ))

    # Check raw HTML - selected item has opacity-100 check icon
    # The structure has data-value="rails" and nearby svg with opacity-100
    assert_includes rendered_content, 'data-value="rails"'
    assert_includes rendered_content, "opacity-100"
    assert_includes rendered_content, "opacity-0"
  end

  def test_check_icon_is_positioned_as_right_indicator
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      value: "rails"
    ))

    assert_includes rendered_content, "absolute right-2 size-4 opacity-100"
    assert_includes rendered_content, "absolute right-2 size-4 opacity-0"

    refute_includes rendered_content, "mr-2 h-4 w-4"
  end

  def test_renders_search_icon
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    # Should have search icon in the input wrapper
    assert_selector "svg", minimum: 1
  end

  def test_renders_popover_content_hidden_by_default
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    # Hidden attribute on popover content
    assert_includes rendered_content, 'data-shadcn--combobox-target="content"'
    assert_includes rendered_content, "hidden"
  end

  def test_popover_content_uses_new_york_v4_ring_chrome
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    assert_includes rendered_content, "bg-popover"
    assert_includes rendered_content, "shadow-md"
    assert_includes rendered_content, "ring-1"
    assert_includes rendered_content, "ring-foreground/10"
    assert_includes rendered_content, "duration-100"

    refute_includes rendered_content, "rounded-md border bg-popover"
  end

  def test_hidden_input_has_selected_value
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      name: "framework",
      value: "rails"
    ))

    # Hidden input with value, check raw HTML
    assert_includes rendered_content, 'type="hidden"'
    assert_includes rendered_content, 'value="rails"'
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ComboboxComponent.new(
      items: frameworks,
      class_name: "custom-combobox"
    ))

    assert_selector "div.custom-combobox"
  end

  def test_items_have_proper_data_attributes
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    # Items are in hidden content, check raw HTML
    assert_includes rendered_content, 'data-shadcn--combobox-target="item"'
    assert_includes rendered_content, 'data-value="rails"'
    assert_includes rendered_content, 'data-label="Ruby on Rails"'
  end

  def test_items_have_option_role
    render_inline(Shadcn::ComboboxComponent.new(items: frameworks))

    # Items are in hidden content, check raw HTML
    assert_includes rendered_content, 'role="option"'
  end
end
