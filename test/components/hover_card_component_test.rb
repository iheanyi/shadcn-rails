# frozen_string_literal: true

require "test_helper"

class HoverCardComponentTest < ViewComponent::TestCase
  def test_renders_hover_card_container
    render_inline(Shadcn::HoverCardComponent.new)

    assert_selector "div[data-controller='shadcn--hover-card']"
  end

  def test_renders_with_trigger
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_trigger { "@username" }
    end

    assert_selector "[data-shadcn--hover-card-target='trigger']", text: "@username"
  end

  def test_renders_with_card_content
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_card_content { "Profile preview" }
    end

    assert_selector "[data-shadcn--hover-card-target='content']", text: "Profile preview", visible: :all
  end

  def test_renders_with_custom_delays
    render_inline(Shadcn::HoverCardComponent.new(open_delay: 500, close_delay: 200))

    assert_selector "[data-shadcn--hover-card-open-delay-value='500']"
    assert_selector "[data-shadcn--hover-card-close-delay-value='200']"
  end

  def test_renders_content_with_tooltip_role
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_card_content { "Info" }
    end

    assert_selector "[role='tooltip']", visible: :all
  end

  def test_content_uses_new_york_v4_outline_class
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_card_content { "Info" }
    end

    classes = page.find("[data-shadcn--hover-card-target='content']", visible: :all)[:class].split
    assert_includes classes, "outline-hidden"
    refute_includes classes, "outline-none"
  end

  def test_renders_content_hidden_by_default
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_card_content { "Hidden content" }
    end

    assert_selector "[data-state='closed']", visible: :all
  end

  def test_renders_with_side_positioning
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_card_content(side: :top) { "Top content" }
    end

    assert_selector "[data-side='top']", visible: :all
  end

  def test_renders_with_align_positioning
    render_inline(Shadcn::HoverCardComponent.new) do |card|
      card.with_card_content(align: :start) { "Aligned start" }
    end

    assert_selector "[data-align='start']", visible: :all
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::HoverCardComponent.new(class_name: "my-hover-card"))

    assert_selector "div.my-hover-card"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::HoverCardComponent.new(class: "alias-class"))

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::HoverCardComponent.new(data: { testid: "hover-card" }))

    assert_selector "[data-testid='hover-card']"
  end
end
