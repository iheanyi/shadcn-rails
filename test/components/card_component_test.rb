# frozen_string_literal: true

require "test_helper"

class CardComponentTest < ViewComponent::TestCase
  def test_renders_basic_card
    render_inline(Shadcn::CardComponent.new) { "Content" }

    assert_selector "div[data-slot='card'].rounded-xl.border.bg-card"
    assert_text "Content"
  end

  def test_renders_with_header
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Title" }
        header.with_description { "Description" }
      end
    end

    assert_selector "div[data-slot='card-header']"
    assert_selector "h3[data-slot='card-title']", text: "Title"
    assert_selector "p[data-slot='card-description']", text: "Description"
  end

  def test_renders_with_content
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_content_slot { "Main content here" }
    end

    assert_selector "div[data-slot='card-content'].px-6", text: "Main content here"
  end

  def test_renders_with_footer
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_footer { "Footer content" }
    end

    assert_selector "div[data-slot='card-footer'].flex.items-center.px-6", text: "Footer content"
  end

  def test_renders_complete_card
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Card Title" }
        header.with_description { "Card description" }
      end
      card.with_content_slot { "Content" }
      card.with_footer { "Footer" }
    end

    assert_selector "h3", text: "Card Title"
    assert_selector "p[data-slot='card-description'].text-sm.text-muted-foreground", text: "Card description"
    assert_text "Content"
    assert_text "Footer"
  end

  def test_default_card_uses_new_york_v4_classes
    render_inline(Shadcn::CardComponent.new) { "Content" }

    classes = page.find("div[data-slot='card']")["class"].split

    assert_includes classes, "flex"
    assert_includes classes, "flex-col"
    assert_includes classes, "gap-6"
    assert_includes classes, "rounded-xl"
    assert_includes classes, "border"
    assert_includes classes, "bg-card"
    assert_includes classes, "py-6"
    assert_includes classes, "text-card-foreground"
    assert_includes classes, "shadow-sm"
    refute_includes classes, "shadow"
  end

  def test_header_uses_new_york_v4_classes
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Title" }
        header.with_description { "Description" }
      end
    end

    classes = page.find("div[data-slot='card-header']")["class"].split

    assert_includes classes, "@container/card-header"
    assert_includes classes, "grid"
    assert_includes classes, "auto-rows-min"
    assert_includes classes, "grid-rows-[auto_auto]"
    assert_includes classes, "items-start"
    assert_includes classes, "gap-2"
    assert_includes classes, "px-6"
    assert_includes classes, "has-data-[slot=card-action]:grid-cols-[1fr_auto]"
    assert_includes classes, "[.border-b]:pb-6"
    refute_includes classes, "space-y-1.5"
    refute_includes classes, "p-6"
  end

  def test_card_action_uses_new_york_v4_slot_and_classes
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Title" }
        header.with_action { "Action" }
      end
    end

    action = page.find("div[data-slot='card-action']", text: "Action")
    classes = action["class"].split

    assert_includes classes, "col-start-2"
    assert_includes classes, "row-span-2"
    assert_includes classes, "row-start-1"
    assert_includes classes, "self-start"
    assert_includes classes, "justify-self-end"
  end

  def test_content_and_footer_use_new_york_v4_padding
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_content { "Content" }
      card.with_footer { "Footer" }
    end

    content_classes = page.find("div[data-slot='card-content']")["class"].split
    assert_includes content_classes, "px-6"
    refute_includes content_classes, "p-6"
    refute_includes content_classes, "pt-0"

    footer_classes = page.find("div[data-slot='card-footer']")["class"].split
    assert_includes footer_classes, "flex"
    assert_includes footer_classes, "items-center"
    assert_includes footer_classes, "px-6"
    assert_includes footer_classes, "[.border-t]:pt-6"
    refute_includes footer_classes, "p-6"
    refute_includes footer_classes, "pt-0"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new(class_name: "my-custom-class")) { "Content" }

    assert_selector "div.my-custom-class"
    assert_selector "div.rounded-xl.my-custom-class"  # Verify merged with base classes
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::CardComponent.new(class: "alias-class")) { "Content" }

    assert_selector "div.alias-class"
  end

  def test_custom_class_merges_with_base_classes
    render_inline(Shadcn::CardComponent.new(class_name: "w-96 mx-auto")) { "Content" }

    # Should have both base classes and custom classes
    assert_selector "div.rounded-xl.border.bg-card.w-96.mx-auto"
  end

  def test_custom_class_overrides_conflicting_base_classes
    render_inline(Shadcn::CardComponent.new(class_name: "rounded-none shadow-lg")) { "Content" }

    html = page.native.inner_html
    # rounded-none should override rounded-xl, shadow-lg should override shadow-sm
    assert_includes html, "rounded-none"
    assert_includes html, "shadow-lg"
    refute_includes html, "rounded-xl"
    refute_includes html, "shadow-sm"
  end

  # Nested slot custom class tests
  def test_header_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header(class_name: "bg-slate-100") do |header|
        header.with_title { "Title" }
      end
    end

    assert_selector "div[data-slot='card-header'].bg-slate-100"
  end

  def test_content_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_content(class_name: "bg-gray-50") { "Content" }
    end

    assert_selector "div[data-slot='card-content'].px-6.bg-gray-50"
  end

  def test_footer_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_footer(class_name: "justify-between") { "Footer" }
    end

    assert_selector "div[data-slot='card-footer'].flex.items-center.px-6.justify-between"
  end

  def test_title_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title(class_name: "text-2xl") { "Title" }
      end
    end

    assert_selector "h3[data-slot='card-title'].text-2xl"
  end

  def test_description_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_description(class_name: "text-base") { "Description" }
      end
    end

    assert_selector "p[data-slot='card-description'].text-base"
  end

  # Data attributes and HTML options
  def test_renders_with_data_attributes
    render_inline(Shadcn::CardComponent.new(data: { testid: "my-card", controller: "card" })) { "Content" }

    assert_selector "[data-testid='my-card']"
    assert_selector "[data-controller='card']"
  end

  def test_renders_with_html_options
    render_inline(Shadcn::CardComponent.new(id: "card-1", role: "region")) { "Content" }

    assert_selector "div#card-1[role='region']"
  end

  def test_multiple_custom_classes_preserved
    render_inline(Shadcn::CardComponent.new(class_name: "w-96   mx-auto  hover:shadow-lg")) { "Content" }

    assert_selector "div.w-96.mx-auto.hover\\:shadow-lg"
  end

  def test_nested_slots_all_accept_custom_classes
    render_inline(Shadcn::CardComponent.new(class_name: "card-custom")) do |card|
      card.with_header(class_name: "header-custom") do |header|
        header.with_title(class_name: "title-custom") { "Title" }
        header.with_description(class_name: "desc-custom") { "Description" }
      end
      card.with_content(class_name: "content-custom") { "Content" }
      card.with_footer(class_name: "footer-custom") { "Footer" }
    end

    assert_selector "div.card-custom"
    assert_selector "div.header-custom"
    assert_selector "h3.title-custom"
    assert_selector "p.desc-custom"
    assert_selector "div.content-custom"
    assert_selector "div.footer-custom"
  end
end
