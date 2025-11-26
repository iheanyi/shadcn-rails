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
    render_inline(Shadcn::CardComponent.new(class_name: "w-96")) { "Content" }

    assert_selector "div.rounded-xl.w-96"
  end
end
