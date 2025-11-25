# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class CardComponentTest < ViewComponent::TestCase
  def test_renders_basic_card
    render_inline(Ui::CardComponent.new) { "Content" }

    assert_selector "div.rounded-xl"
    assert_selector "div.border"
    assert_selector "div.bg-card"
    assert_selector "div.text-card-foreground"
    assert_selector "div.shadow"
    assert_text "Content"
  end

  def test_renders_card_with_header
    render_inline(Ui::CardComponent.new) do |card|
      card.with_header { "Header" }
    end

    assert_selector "div.p-6", text: "Header"
  end

  def test_renders_card_with_title
    render_inline(Ui::CardComponent.new) do |card|
      card.with_title { "My Title" }
    end

    assert_selector "h3", text: "My Title"
    assert_selector "h3.font-semibold"
  end

  def test_renders_card_with_description
    render_inline(Ui::CardComponent.new) do |card|
      card.with_description { "Description text" }
    end

    assert_selector "p.text-muted-foreground", text: "Description text"
  end

  def test_renders_card_with_content
    render_inline(Ui::CardComponent.new) do |card|
      card.with_card_content { "Main content" }
    end

    assert_selector "div.p-6", text: "Main content"
  end

  def test_renders_card_with_footer
    render_inline(Ui::CardComponent.new) do |card|
      card.with_footer { "Footer" }
    end

    assert_selector "div.flex.items-center", text: "Footer"
  end

  def test_accepts_custom_classes
    render_inline(Ui::CardComponent.new(class_name: "custom-card")) { "Content" }

    assert_selector "div.custom-card"
  end

  def test_renders_complete_card
    render_inline(Ui::CardComponent.new) do |card|
      card.with_header do
        card.with_title { "Card Title" }
        card.with_description { "Card description" }
      end
      card.with_card_content { "Main content" }
      card.with_footer { "Footer content" }
    end

    assert_text "Card Title"
    assert_text "Card description"
    assert_text "Main content"
    assert_text "Footer content"
  end
end
