# frozen_string_literal: true

require "test_helper"

class ItemComponentTest < ViewComponent::TestCase
  def test_renders_basic_item
    render_inline(Shadcn::ItemComponent.new) { "Content" }

    assert_selector "div[data-slot='item'][data-variant='default'][data-size='default']"
    assert_text "Content"
  end

  def test_root_uses_new_york_v4_classes
    render_inline(Shadcn::ItemComponent.new) { "Content" }

    classes = page.find("div[data-slot='item']")["class"].split

    assert_includes classes, "group/item"
    assert_includes classes, "flex"
    assert_includes classes, "flex-wrap"
    assert_includes classes, "items-center"
    assert_includes classes, "rounded-md"
    assert_includes classes, "border"
    assert_includes classes, "border-transparent"
    assert_includes classes, "text-sm"
    assert_includes classes, "transition-colors"
    assert_includes classes, "duration-100"
    assert_includes classes, "outline-none"
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "[a]:transition-colors"
    assert_includes classes, "[a]:hover:bg-accent/50"
    assert_includes classes, "gap-4"
    assert_includes classes, "p-4"

    refute_includes classes, "items-start"
    refute_includes classes, "rounded-lg"
  end

  def test_renders_with_content_slot
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_content do |content|
        content.with_title { "Title" }
        content.with_description { "Description" }
      end
    end

    assert_selector "div[data-slot='item-title']", text: "Title"
    assert_selector "p[data-slot='item-description']", text: "Description"
  end

  def test_renders_with_media_icon_variant
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_media(variant: :icon) { "Icon" }
    end

    media = page.find("div[data-slot='item-media'][data-variant='icon']")
    classes = media["class"].split

    assert_includes classes, "flex"
    assert_includes classes, "shrink-0"
    assert_includes classes, "items-center"
    assert_includes classes, "justify-center"
    assert_includes classes, "gap-2"
    assert_includes classes, "group-has-[[data-slot=item-description]]/item:translate-y-0.5"
    assert_includes classes, "group-has-[[data-slot=item-description]]/item:self-start"
    assert_includes classes, "[&_svg]:pointer-events-none"
    assert_includes classes, "size-8"
    assert_includes classes, "rounded-sm"
    assert_includes classes, "border"
    assert_includes classes, "bg-muted"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"

    refute_includes classes, "size-10"
    refute_includes classes, "rounded-lg"
    refute_includes classes, "[&>svg]:size-5"
    refute_includes classes, "[&>svg]:text-muted-foreground"
  end

  def test_renders_with_media_image_variant
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_media(variant: :image) { "Image" }
    end

    classes = page.find("div[data-slot='item-media'][data-variant='image']")["class"].split

    assert_includes classes, "size-10"
    assert_includes classes, "overflow-hidden"
    assert_includes classes, "rounded-sm"
    assert_includes classes, "[&_img]:size-full"
    assert_includes classes, "[&_img]:object-cover"
    refute_includes classes, "rounded-lg"
  end

  def test_renders_with_actions
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_actions { "Actions" }
    end

    actions = page.find("div[data-slot='item-actions']", text: "Actions")
    classes = actions["class"].split

    assert_includes classes, "flex"
    assert_includes classes, "items-center"
    assert_includes classes, "gap-2"
    refute_includes classes, "shrink-0"
  end

  def test_renders_outline_variant
    render_inline(Shadcn::ItemComponent.new(variant: :outline)) { "Content" }

    classes = page.find("div[data-slot='item'][data-variant='outline']")["class"].split

    assert_includes classes, "border"
    assert_includes classes, "border-border"
    refute_includes classes, "rounded-lg"
  end

  def test_renders_muted_variant
    render_inline(Shadcn::ItemComponent.new(variant: :muted)) { "Content" }

    classes = page.find("div[data-slot='item'][data-variant='muted']")["class"].split

    assert_includes classes, "bg-muted/50"
    assert_includes classes, "rounded-md"
    refute_includes classes, "rounded-lg"
  end

  def test_renders_sm_size
    render_inline(Shadcn::ItemComponent.new(size: :sm)) { "Content" }

    classes = page.find("div[data-slot='item'][data-size='sm']")["class"].split

    assert_includes classes, "gap-2.5"
    assert_includes classes, "px-4"
    assert_includes classes, "py-3"
    refute_includes classes, "p-3"
    refute_includes classes, "gap-3"
  end

  def test_renders_as_link_with_href
    render_inline(Shadcn::ItemComponent.new(href: "/test")) { "Link" }

    assert_selector "a[data-slot='item'][href='/test']", text: "Link"
  end

  def test_renders_with_custom_tag
    render_inline(Shadcn::ItemComponent.new(tag: :li)) { "List item" }

    assert_selector "li[data-slot='item']", text: "List item"
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

    assert_selector "div[data-slot='item'].border-border"
    assert_selector "div[data-slot='item-title']", text: "Item Title"
    assert_selector "p[data-slot='item-description']", text: "Item description goes here."
    assert_text "Button"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::ItemComponent.new(class_name: "hover:bg-accent")) { "Content" }

    assert_selector "div[data-slot='item'].hover\\:bg-accent"
  end

  def test_content_title_and_description_use_new_york_v4_classes
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_content do |content|
        content.with_title { "Title" }
        content.with_description { "Description" }
      end
    end

    content_classes = page.find("div[data-slot='item-content']")["class"].split
    assert_includes content_classes, "flex"
    assert_includes content_classes, "flex-1"
    assert_includes content_classes, "flex-col"
    assert_includes content_classes, "gap-1"
    assert_includes content_classes, "[&+[data-slot=item-content]]:flex-none"
    refute_includes content_classes, "min-w-0"
    refute_includes content_classes, "space-y-1"

    title_classes = page.find("div[data-slot='item-title']")["class"].split
    assert_includes title_classes, "flex"
    assert_includes title_classes, "w-fit"
    assert_includes title_classes, "items-center"
    assert_includes title_classes, "gap-2"
    assert_includes title_classes, "text-sm"
    assert_includes title_classes, "leading-snug"
    assert_includes title_classes, "font-medium"
    refute_includes title_classes, "leading-none"

    description_classes = page.find("p[data-slot='item-description']")["class"].split
    assert_includes description_classes, "line-clamp-2"
    assert_includes description_classes, "text-sm"
    assert_includes description_classes, "leading-normal"
    assert_includes description_classes, "font-normal"
    assert_includes description_classes, "text-balance"
    assert_includes description_classes, "text-muted-foreground"
    assert_includes description_classes, "[&>a]:underline"
    assert_includes description_classes, "[&>a]:underline-offset-4"
    assert_includes description_classes, "[&>a:hover]:text-primary"
  end

  def test_header_and_footer_use_new_york_v4_classes
    render_inline(Shadcn::ItemComponent.new) do |item|
      item.with_header { "Header" }
      item.with_footer { "Footer" }
    end

    header_classes = page.find("div[data-slot='item-header']")["class"].split
    assert_includes header_classes, "flex"
    assert_includes header_classes, "basis-full"
    assert_includes header_classes, "items-center"
    assert_includes header_classes, "justify-between"
    assert_includes header_classes, "gap-2"
    refute_includes header_classes, "mb-2"

    footer_classes = page.find("div[data-slot='item-footer']")["class"].split
    assert_includes footer_classes, "flex"
    assert_includes footer_classes, "basis-full"
    assert_includes footer_classes, "items-center"
    assert_includes footer_classes, "justify-between"
    assert_includes footer_classes, "gap-2"
    refute_includes footer_classes, "mt-2"
    refute_includes footer_classes, "w-full"
  end
end

class ItemGroupComponentTest < ViewComponent::TestCase
  def test_renders_item_group
    render_inline(Shadcn::ItemGroupComponent.new) { "Content" }

    assert_selector "div[data-slot='item-group'][role='list']"

    classes = page.find("div[data-slot='item-group']")["class"].split
    assert_includes classes, "group/item-group"
    assert_includes classes, "flex"
    assert_includes classes, "flex-col"
  end
end

class ItemSeparatorComponentTest < ViewComponent::TestCase
  def test_renders_separator
    render_inline(Shadcn::ItemSeparatorComponent.new)

    assert_selector "div.bg-border[role='separator'][data-orientation='horizontal']"

    classes = page.find("div[role='separator']")["class"].split
    assert_includes classes, "my-0"
    assert_includes classes, "data-[orientation=horizontal]:h-px"
    assert_includes classes, "data-[orientation=horizontal]:w-full"
    refute_includes classes, "h-[1px]"
  end
end
