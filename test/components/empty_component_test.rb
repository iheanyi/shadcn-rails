# frozen_string_literal: true

require "test_helper"

class EmptyComponentTest < ViewComponent::TestCase
  def test_renders_basic_empty
    render_inline(Shadcn::EmptyComponent.new) { "Content" }

    assert_selector "div.flex.flex-col.items-center"
    assert_text "Content"
  end

  def test_renders_with_header
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_title { "No Data" }
        header.with_description { "Nothing to see here" }
      end
    end

    assert_selector "h3", text: "No Data"
    assert_selector "p", text: "Nothing to see here"
  end

  def test_renders_with_media_icon_variant
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :icon) { "Icon" }
        header.with_title { "Title" }
      end
    end

    assert_selector "div.flex.size-12.items-center.justify-center.rounded-full.bg-muted"
  end

  def test_renders_with_media_default_variant
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :default) { "Avatar" }
        header.with_title { "Title" }
      end
    end

    assert_selector "div", text: "Avatar"
  end

  def test_renders_with_content
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_content { "Action buttons" }
    end

    assert_selector "div.flex.flex-col.items-center.gap-2", text: "Action buttons"
  end

  def test_renders_complete_empty_state
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :icon) { "Icon" }
        header.with_title { "No Projects" }
        header.with_description { "Create your first project to get started." }
      end
      empty.with_content { "Create Project Button" }
    end

    assert_selector "h3", text: "No Projects"
    assert_selector "p.text-muted-foreground", text: "Create your first project to get started."
    assert_text "Create Project Button"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::EmptyComponent.new(class_name: "border border-dashed")) { "Content" }

    assert_selector "div.flex.flex-col.border.border-dashed"
  end

  def test_renders_with_outline_style
    render_inline(Shadcn::EmptyComponent.new(class_name: "border border-dashed rounded-lg")) do |empty|
      empty.with_header do |header|
        header.with_title { "Empty State" }
      end
    end

    assert_selector "div.border.border-dashed.rounded-lg"
    assert_selector "h3", text: "Empty State"
  end
end
