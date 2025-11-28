# frozen_string_literal: true

require "test_helper"

class CardComponentTest < ViewComponent::TestCase
  def test_renders_basic_card
    render_inline(Shadcn::CardComponent.new) { "Content" }

    assert_selector "div.rounded-xl.border.bg-card"
    assert_text "Content"
  end

  def test_renders_with_header
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Title" }
        header.with_description { "Description" }
      end
    end

    assert_selector "div.flex.flex-col"
    assert_selector "h3", text: "Title"
    assert_selector "p", text: "Description"
  end

  def test_renders_with_content
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_content_slot { "Main content here" }
    end

    assert_selector "div.p-6.pt-0", text: "Main content here"
  end

  def test_renders_with_footer
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_footer { "Footer content" }
    end

    assert_selector "div.flex.items-center.p-6.pt-0", text: "Footer content"
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
    assert_selector "p.text-sm.text-muted-foreground", text: "Card description"
    assert_text "Content"
    assert_text "Footer"
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
    # rounded-none should override rounded-xl, shadow-lg should override shadow
    assert_includes html, "rounded-none"
    assert_includes html, "shadow-lg"
    refute_includes html, "rounded-xl"
  end

  # Nested slot custom class tests
  def test_header_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header(class_name: "bg-slate-100") do |header|
        header.with_title { "Title" }
      end
    end

    assert_selector "div.flex.flex-col.bg-slate-100"
  end

  def test_content_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_content(class_name: "bg-gray-50") { "Content" }
    end

    assert_selector "div.p-6.bg-gray-50"
  end

  def test_footer_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_footer(class_name: "justify-between") { "Footer" }
    end

    assert_selector "div.flex.items-center.p-6.justify-between"
  end

  def test_title_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title(class_name: "text-2xl") { "Title" }
      end
    end

    assert_selector "h3.text-2xl"
  end

  def test_description_renders_with_custom_class
    render_inline(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_description(class_name: "text-base") { "Description" }
      end
    end

    assert_selector "p.text-base"
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
