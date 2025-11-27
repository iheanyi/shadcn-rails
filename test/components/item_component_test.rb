# frozen_string_literal: true

require "test_helper"

class ItemComponentTest < ViewComponent::TestCase
  def test_renders_basic_item
    render_inline(Shadcn::ItemComponent.new) { "Content" }

    assert_selector "div.flex.items-start"
    assert_text "Content"
  end

  def test_renders_with_content_slot
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_content do |content|
        content.with_title { "Title" }
        content.with_description { "Description" }
      end
    end

    assert_selector "div.text-sm.font-medium", text: "Title"
    assert_selector "p.text-muted-foreground", text: "Description"
  end

  def test_renders_with_media_icon_variant
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_media(variant: :icon) { "Icon" }
    end

    assert_selector "div.flex.size-10.items-center.justify-center.rounded-lg.bg-muted"
  end

  def test_renders_with_media_image_variant
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_media(variant: :image) { "Image" }
    end

    assert_selector "div.overflow-hidden.rounded-lg"
  end

  def test_renders_with_actions
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_actions { "Actions" }
    end

    assert_selector "div.shrink-0.flex.items-center.gap-2", text: "Actions"
  end

  def test_renders_outline_variant
    render_inline(Shadcn::ItemComponent.new(variant: :outline)) { "Content" }

    assert_selector "div.border.border-border.rounded-lg"
  end

  def test_renders_muted_variant
    render_inline(Shadcn::ItemComponent.new(variant: :muted)) { "Content" }

    assert_selector "div.rounded-lg"
  end

  def test_renders_sm_size
    render_inline(Shadcn::ItemComponent.new(size: :sm)) { "Content" }

    assert_selector "div.p-3.gap-3"
  end

  def test_renders_as_link_with_href
    render_inline(Shadcn::ItemComponent.new(href: "/test")) { "Link" }

    assert_selector "a.flex.items-start[href='/test']", text: "Link"
  end

  def test_renders_with_custom_tag
    render_inline(Shadcn::ItemComponent.new(tag: :li)) { "List item" }

    assert_selector "li.flex.items-start", text: "List item"
  end

  def test_renders_complete_item
    render_inline(Shadcn::ItemComponent.new(variant: :outline)) do |item|
      item.with_media(variant: :icon) { "Icon" }
      item.with_content do |content|
        content.with_title { "Item Title" }
        content.with_description { "Item description goes here." }
      end
      item.with_actions { "Button" }
    end

    assert_selector "div.border.border-border"
    assert_selector "div.text-sm.font-medium", text: "Item Title"
    assert_selector "p.text-muted-foreground", text: "Item description goes here."
    assert_text "Button"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ItemComponent.new(class_name: "hover:bg-accent")) { "Content" }

    assert_selector "div.flex.items-start.hover\\:bg-accent"
  end
end

class ItemGroupComponentTest < ViewComponent::TestCase
  def test_renders_item_group
    render_inline(Shadcn::ItemGroupComponent.new) { "Content" }

    assert_selector "div.flex.flex-col"
  end
end

class ItemSeparatorComponentTest < ViewComponent::TestCase
  def test_renders_separator
    render_inline(Shadcn::ItemSeparatorComponent.new)

    assert_selector "div.bg-border[role='separator']"
  end
end
