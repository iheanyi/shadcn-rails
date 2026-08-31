# frozen_string_literal: true

require "test_helper"

class EmptyComponentTest < ViewComponent::TestCase
  def test_renders_basic_empty
    render_inline(Shadcn::EmptyComponent.new) { "Content" }

    assert_selector "div[data-slot='empty'].flex.flex-col.items-center"
    assert_text "Content"
  end

  def test_renders_with_header
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_title { "No Data" }
        header.with_description { "Nothing to see here" }
      end
    end

    assert_selector "div[data-slot='empty-header']"
    assert_selector "h3[data-slot='empty-title']", text: "No Data"
    assert_selector "p[data-slot='empty-description']", text: "Nothing to see here"
  end

  def test_renders_with_media_icon_variant
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :icon) { "Icon" }
        header.with_title { "Title" }
      end
    end

    assert_selector "div[data-slot='empty-icon'][data-variant='icon'].flex.size-10.items-center.justify-center.rounded-lg.bg-muted.text-foreground"
  end

  def test_renders_with_media_default_variant
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :default) { "Avatar" }
        header.with_title { "Title" }
      end
    end

    assert_selector "div[data-slot='empty-icon'][data-variant='default']", text: "Avatar"
  end

  def test_renders_with_content
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_content { "Action buttons" }
    end

    assert_selector "div[data-slot='empty-content'].flex.flex-col.items-center.gap-4", text: "Action buttons"
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

    assert_selector "h3[data-slot='empty-title']", text: "No Projects"
    assert_selector "p[data-slot='empty-description'].text-muted-foreground", text: "Create your first project to get started."
    assert_text "Create Project Button"
  end

  def test_empty_uses_new_york_v4_classes
    render_inline(Shadcn::EmptyComponent.new) { "Content" }

    classes = classes_for("div[data-slot='empty']")

    assert_includes classes, "flex"
    assert_includes classes, "min-w-0"
    assert_includes classes, "flex-1"
    assert_includes classes, "flex-col"
    assert_includes classes, "items-center"
    assert_includes classes, "justify-center"
    assert_includes classes, "gap-6"
    assert_includes classes, "rounded-lg"
    assert_includes classes, "border-dashed"
    assert_includes classes, "p-6"
    assert_includes classes, "text-center"
    assert_includes classes, "text-balance"
    assert_includes classes, "md:p-12"
    refute_includes classes, "py-16"
  end

  def test_header_uses_new_york_v4_classes
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_title { "Title" }
      end
    end

    classes = classes_for("div[data-slot='empty-header']")

    assert_includes classes, "flex"
    assert_includes classes, "max-w-sm"
    assert_includes classes, "flex-col"
    assert_includes classes, "items-center"
    assert_includes classes, "gap-2"
    assert_includes classes, "text-center"
  end

  def test_media_uses_new_york_v4_classes
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :icon) { "Icon" }
      end
    end

    classes = classes_for("div[data-slot='empty-icon']")

    assert_includes classes, "mb-2"
    assert_includes classes, "flex"
    assert_includes classes, "shrink-0"
    assert_includes classes, "items-center"
    assert_includes classes, "justify-center"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "[&_svg]:shrink-0"
    assert_includes classes, "size-10"
    assert_includes classes, "rounded-lg"
    assert_includes classes, "bg-muted"
    assert_includes classes, "text-foreground"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-6"
    refute_includes classes, "size-12"
    refute_includes classes, "rounded-full"
    refute_includes classes, "[&>svg]:text-muted-foreground"
  end

  def test_default_media_uses_new_york_v4_classes
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_media(variant: :default) { "Avatar" }
      end
    end

    classes = classes_for("div[data-slot='empty-icon']")

    assert_includes classes, "mb-2"
    assert_includes classes, "bg-transparent"
    refute_includes classes, "size-10"
  end

  def test_title_description_and_content_use_new_york_v4_classes
    render_inline(Shadcn::EmptyComponent.new) do |empty|
      empty.with_header do |header|
        header.with_title { "Title" }
        header.with_description { "Description" }
      end
      empty.with_content { "Actions" }
    end

    title_classes = classes_for("h3[data-slot='empty-title']")
    assert_includes title_classes, "text-lg"
    assert_includes title_classes, "font-medium"
    assert_includes title_classes, "tracking-tight"
    refute_includes title_classes, "font-semibold"

    description_classes = classes_for("p[data-slot='empty-description']")
    assert_includes description_classes, "text-sm/relaxed"
    assert_includes description_classes, "text-muted-foreground"
    assert_includes description_classes, "[&>a]:underline"
    assert_includes description_classes, "[&>a]:underline-offset-4"
    assert_includes description_classes, "[&>a:hover]:text-primary"
    refute_includes description_classes, "max-w-sm"

    content_classes = classes_for("div[data-slot='empty-content']")
    assert_includes content_classes, "flex"
    assert_includes content_classes, "w-full"
    assert_includes content_classes, "max-w-sm"
    assert_includes content_classes, "min-w-0"
    assert_includes content_classes, "flex-col"
    assert_includes content_classes, "items-center"
    assert_includes content_classes, "gap-4"
    assert_includes content_classes, "text-sm"
    assert_includes content_classes, "text-balance"
    refute_includes content_classes, "gap-2"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::EmptyComponent.new(class_name: "border border-dashed")) { "Content" }

    assert_selector "div[data-slot='empty'].flex.flex-col.border.border-dashed"
  end

  def test_renders_with_outline_style
    render_inline(Shadcn::EmptyComponent.new(class_name: "border border-dashed rounded-lg")) do |empty|
      empty.with_header do |header|
        header.with_title { "Empty State" }
      end
    end

    assert_selector "div.border.border-dashed.rounded-lg"
    assert_selector "h3[data-slot='empty-title']", text: "Empty State"
  end

  private

  def classes_for(selector)
    page.find(selector)["class"].split
  end
end
