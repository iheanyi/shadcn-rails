# frozen_string_literal: true

require "test_helper"

class TypographyComponentTest < ViewComponent::TestCase
  def test_renders_h1_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :h1)) { "Heading 1" }

    assert_selector "h1", text: "Heading 1"
    assert_selector "h1.text-4xl"
    assert_selector "h1.font-extrabold"
  end

  def test_renders_h2_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :h2)) { "Heading 2" }

    assert_selector "h2", text: "Heading 2"
    assert_selector "h2.text-3xl"
    assert_selector "h2.font-semibold"
  end

  def test_renders_h3_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :h3)) { "Heading 3" }

    assert_selector "h3", text: "Heading 3"
    assert_selector "h3.text-2xl"
  end

  def test_renders_h4_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :h4)) { "Heading 4" }

    assert_selector "h4", text: "Heading 4"
    assert_selector "h4.text-xl"
  end

  def test_renders_paragraph_variant_by_default
    render_inline(Shadcn::TypographyComponent.new) { "Paragraph text" }

    assert_selector "p", text: "Paragraph text"
    assert_selector "p.leading-7"
  end

  def test_renders_lead_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :lead)) { "Lead text" }

    assert_selector "p", text: "Lead text"
    assert_selector "p.text-xl"
    assert_selector "p.text-muted-foreground"
  end

  def test_renders_large_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :large)) { "Large text" }

    assert_selector "div", text: "Large text"
    assert_selector "div.text-lg"
    assert_selector "div.font-semibold"
  end

  def test_renders_small_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :small)) { "Small text" }

    assert_selector "small", text: "Small text"
    assert_selector "small.text-sm"
  end

  def test_renders_muted_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :muted)) { "Muted text" }

    assert_selector "p", text: "Muted text"
    assert_selector "p.text-muted-foreground"
  end

  def test_renders_blockquote_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :blockquote)) { "Quote" }

    assert_selector "blockquote", text: "Quote"
    assert_selector "blockquote.border-l-2"
    assert_selector "blockquote.italic"
  end

  def test_renders_code_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :code)) { "code" }

    assert_selector "code", text: "code"
    assert_selector "code.font-mono"
    assert_selector "code.bg-muted"
  end

  def test_renders_list_variant
    render_inline(Shadcn::TypographyComponent.new(variant: :list)) { "<li>Item</li>".html_safe }

    assert_selector "ul.list-disc"
  end

  def test_renders_with_custom_tag
    render_inline(Shadcn::TypographyComponent.new(variant: :h1, tag: :span)) { "Custom" }

    assert_selector "span", text: "Custom"
    assert_selector "span.text-4xl"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::TypographyComponent.new(class_name: "my-custom")) { "Text" }

    assert_selector "p.my-custom"
  end
end
