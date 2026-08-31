# frozen_string_literal: true

require "test_helper"

class SheetComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_sheet_container
    render_inline(Shadcn::SheetComponent.new)

    assert_selector "div[data-controller='shadcn--sheet']"
    assert_selector "div[data-slot='sheet']"
  end

  def test_renders_with_trigger_slot
    render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_trigger { "Open Sheet" }
    end

    assert_selector "[data-slot='sheet-trigger'][data-shadcn--sheet-target='trigger']", text: "Open Sheet"
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

  def test_sheet_template_parts_have_v4_data_slots
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body do |body|
        body.with_header do |header|
          header.with_title { "Sheet Title" }
          header.with_description { "Sheet description" }
        end
        body.with_footer { "Footer content" }
      end
    end

    html = result.to_html
    assert html.include?("data-slot=\"sheet-portal\"")
    assert html.include?("data-slot=\"sheet-overlay\"")
    assert html.include?("data-slot=\"sheet-content\"")
    assert html.include?("data-slot=\"sheet-header\"")
    assert html.include?("data-slot=\"sheet-footer\"")
    assert html.include?("data-slot=\"sheet-title\"")
    assert html.include?("data-slot=\"sheet-description\"")
    assert html.include?("data-slot=\"sheet-close\"")
  end

  def test_content_uses_v4_flex_column_without_panel_padding
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body { "Content" }
    end

    content_tag = result.to_html[/<[^>]*data-slot="sheet-content"[^>]*>/m]
    content_classes = content_tag[/class="([^"]*)"/, 1].split
    assert_includes content_classes, "flex"
    assert_includes content_classes, "flex-col"
    assert_includes content_classes, "gap-4"
    refute_includes content_classes, "p-6"
  end

  def test_header_uses_v4_gap_and_padding_classes
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body do |body|
        body.with_header { "Header content" }
      end
    end

    header_tag = result.to_html[/<[^>]*data-slot="sheet-header"[^>]*>/m]
    header_classes = header_tag[/class="([^"]*)"/, 1].split
    assert_includes header_classes, "gap-1.5"
    assert_includes header_classes, "p-4"
    refute_includes header_classes, "space-y-2"
  end

  def test_footer_uses_v4_auto_margin_and_padding_classes
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body do |body|
        body.with_footer { "Footer content" }
      end
    end

    footer_tag = result.to_html[/<[^>]*data-slot="sheet-footer"[^>]*>/m]
    footer_classes = footer_tag[/class="([^"]*)"/, 1].split
    assert_includes footer_classes, "mt-auto"
    assert_includes footer_classes, "p-4"
    assert_includes footer_classes, "flex-col"
    refute_includes footer_classes, "flex-col-reverse"
    refute_includes footer_classes, "sm:flex-row"
  end

  def test_title_uses_v4_typography_without_large_text_class
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body do |body|
        body.with_title { "Sheet Title" }
      end
    end

    title_tag = result.to_html[/<[^>]*data-slot="sheet-title"[^>]*>/m]
    title_classes = title_tag[/class="([^"]*)"/, 1].split
    assert_includes title_classes, "font-semibold"
    assert_includes title_classes, "text-foreground"
    refute_includes title_classes, "text-lg"
  end

  def test_description_keeps_v4_muted_small_text_classes
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body do |body|
        body.with_description { "Sheet description" }
      end
    end

    description_tag = result.to_html[/<[^>]*data-slot="sheet-description"[^>]*>/m]
    description_classes = description_tag[/class="([^"]*)"/, 1].split
    assert_includes description_classes, "text-sm"
    assert_includes description_classes, "text-muted-foreground"
  end

  def test_close_button_uses_v4_focus_styles_and_icon_size
    result = render_inline(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_body { "Content" }
    end

    html = result.to_html
    close_button_match = html.match(/<button.*?data-slot="sheet-close".*?>/m)
    assert close_button_match

    close_classes = close_button_match[0][/class="([^"]*)"/, 1].split
    assert_includes close_classes, "rounded-xs"
    assert_includes close_classes, "ring-offset-background"
    assert_includes close_classes, "focus:ring-2"
    assert_includes close_classes, "focus:ring-ring"
    assert_includes close_classes, "focus:ring-offset-2"
    assert_includes close_classes, "focus:outline-hidden"
    assert_includes close_classes, "data-[state=open]:bg-secondary"
    refute_includes close_classes, "hover:bg-accent"
    refute_includes close_classes, "hover:text-accent-foreground"
    refute_includes close_classes, "focus-visible:ring-2"

    close_icon_match = html.match(/<svg.*?class="([^"]*)".*?>/m)
    assert close_icon_match

    close_icon_classes = close_icon_match[1].split
    assert_includes close_icon_classes, "size-4"
    refute_includes close_icon_classes, "h-4"
    refute_includes close_icon_classes, "w-4"
  end
end
