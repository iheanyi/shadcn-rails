# frozen_string_literal: true

require "test_helper"

class DrawerComponentTest < ViewComponent::TestCase
  def test_renders_drawer_container
    render_inline(Shadcn::DrawerComponent.new)

    assert_selector "div[data-controller='shadcn--drawer']"
    assert_selector "div[data-slot='drawer']"
  end

  def test_renders_with_trigger
    render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_trigger { "Open Drawer" }
    end

    assert_selector "[data-slot='drawer-trigger'][data-shadcn--drawer-target='trigger']", text: "Open Drawer"
  end

  def test_renders_body_template
    render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Drawer Title" }
        end
      end
    end

    assert_selector "template[data-shadcn--drawer-target='template']", visible: :all
  end

  def test_renders_with_header_title_and_description
    render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Edit Profile" }
          header.with_description { "Make changes here." }
        end
      end
    end

    assert_selector "template", visible: :all
  end

  def test_renders_with_footer
    render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body do |body|
        body.with_footer { "Footer content" }
      end
    end

    assert_selector "template", visible: :all
  end

  def test_renders_with_open_state
    render_inline(Shadcn::DrawerComponent.new(open: true))

    assert_selector "[data-shadcn--drawer-open-value='true']"
  end

  def test_renders_with_bottom_direction
    render_inline(Shadcn::DrawerComponent.new(direction: :bottom))

    assert_selector "[data-shadcn--drawer-direction-value='bottom']"
  end

  def test_renders_with_right_direction
    render_inline(Shadcn::DrawerComponent.new(direction: :right))

    assert_selector "[data-shadcn--drawer-direction-value='right']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::DrawerComponent.new(class_name: "my-drawer"))

    assert_selector "div.my-drawer"
  end

  def test_renders_with_class_alias
    render_inline(Shadcn::DrawerComponent.new(class: "alias-class"))

    assert_selector "div.alias-class"
  end

  def test_renders_with_data_attributes
    render_inline(Shadcn::DrawerComponent.new(data: { testid: "drawer" }))

    assert_selector "[data-testid='drawer']"
  end

  def test_drawer_template_parts_have_v4_data_slots
    result = render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Drawer Title" }
          header.with_description { "Drawer description" }
        end
        body.with_footer { "Footer content" }
      end
    end

    html = result.to_html
    assert_includes html, 'data-slot="drawer-portal"'
    assert_includes html, 'data-slot="drawer-overlay"'
    assert_includes html, 'data-slot="drawer-content"'
    assert_includes html, 'data-slot="drawer-header"'
    assert_includes html, 'data-slot="drawer-footer"'
    assert_includes html, 'data-slot="drawer-title"'
    assert_includes html, 'data-slot="drawer-description"'
  end

  def test_overlay_uses_upstream_v4_classes_and_keeps_controller_hooks
    result = render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body { "Drawer content" }
    end

    overlay_tag = tag_with_slot(result.to_html, "drawer-overlay")
    overlay_classes = classes_from_tag(overlay_tag)

    assert_includes overlay_classes, "fixed"
    assert_includes overlay_classes, "inset-0"
    assert_includes overlay_classes, "z-50"
    assert_includes overlay_classes, "bg-black/50"
    assert_includes overlay_classes, "data-[state=closed]:animate-out"
    assert_includes overlay_classes, "data-[state=closed]:fade-out-0"
    assert_includes overlay_classes, "data-[state=open]:animate-in"
    assert_includes overlay_classes, "data-[state=open]:fade-in-0"
    refute_includes overlay_classes, "bg-black/80"

    assert_includes overlay_tag, 'data-shadcn--drawer-target="overlay"'
    assert_includes overlay_tag, 'data-action="click-&gt;shadcn--drawer#close"'
    assert_includes overlay_tag, 'data-state="closed"'
  end

  def test_content_uses_upstream_v4_direction_classes_and_keeps_motion_hooks
    result = render_inline(Shadcn::DrawerComponent.new(direction: :bottom)) do |drawer|
      drawer.with_body { "Drawer content" }
    end

    content_tag = tag_with_slot(result.to_html, "drawer-content")
    content_classes = classes_from_tag(content_tag)

    assert_includes content_classes, "group/drawer-content"
    assert_includes content_classes, "fixed"
    assert_includes content_classes, "z-50"
    assert_includes content_classes, "flex"
    assert_includes content_classes, "h-auto"
    assert_includes content_classes, "flex-col"
    assert_includes content_classes, "bg-background"
    assert_includes content_classes, "data-[vaul-drawer-direction=top]:inset-x-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=top]:top-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=top]:mb-24"
    assert_includes content_classes, "data-[vaul-drawer-direction=top]:max-h-[80vh]"
    assert_includes content_classes, "data-[vaul-drawer-direction=top]:rounded-b-lg"
    assert_includes content_classes, "data-[vaul-drawer-direction=top]:border-b"
    assert_includes content_classes, "data-[vaul-drawer-direction=bottom]:inset-x-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=bottom]:bottom-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=bottom]:mt-24"
    assert_includes content_classes, "data-[vaul-drawer-direction=bottom]:max-h-[80vh]"
    assert_includes content_classes, "data-[vaul-drawer-direction=bottom]:rounded-t-lg"
    assert_includes content_classes, "data-[vaul-drawer-direction=bottom]:border-t"
    assert_includes content_classes, "data-[vaul-drawer-direction=right]:inset-y-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=right]:right-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=right]:w-3/4"
    assert_includes content_classes, "data-[vaul-drawer-direction=right]:border-l"
    assert_includes content_classes, "data-[vaul-drawer-direction=right]:sm:max-w-sm"
    assert_includes content_classes, "data-[vaul-drawer-direction=left]:inset-y-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=left]:left-0"
    assert_includes content_classes, "data-[vaul-drawer-direction=left]:w-3/4"
    assert_includes content_classes, "data-[vaul-drawer-direction=left]:border-r"
    assert_includes content_classes, "data-[vaul-drawer-direction=left]:sm:max-w-sm"
    refute_includes content_classes, "rounded-t-[10px]"
    refute_includes content_classes, "rounded-b-[10px]"
    refute_includes content_classes, "border"
    refute_includes content_classes, "h-full"
    refute_includes content_classes, "max-w-sm"
    refute_includes content_classes, "data-[size=default]"

    assert_includes content_tag, 'data-shadcn--drawer-target="content"'
    assert_includes content_tag, 'data-state="closed"'
    assert_includes content_tag, 'data-direction="bottom"'
    assert_includes content_tag, 'data-vaul-drawer-direction="bottom"'
  end

  def test_header_uses_upstream_v4_classes
    result = render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body do |body|
        body.with_header { "Header content" }
      end
    end

    header_classes = classes_from_tag(tag_with_slot(result.to_html, "drawer-header"))
    assert_includes header_classes, "flex"
    assert_includes header_classes, "flex-col"
    assert_includes header_classes, "gap-0.5"
    assert_includes header_classes, "p-4"
    assert_includes header_classes, "group-data-[vaul-drawer-direction=bottom]/drawer-content:text-center"
    assert_includes header_classes, "group-data-[vaul-drawer-direction=top]/drawer-content:text-center"
    assert_includes header_classes, "md:gap-1.5"
    assert_includes header_classes, "md:text-left"
    refute_includes header_classes, "grid"
    refute_includes header_classes, "gap-1.5"
    refute_includes header_classes, "text-center"
    refute_includes header_classes, "sm:text-left"
  end

  def test_title_uses_upstream_v4_typography
    result = render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Drawer Title" }
        end
      end
    end

    title_classes = classes_from_tag(tag_with_slot(result.to_html, "drawer-title"))
    assert_includes title_classes, "font-semibold"
    assert_includes title_classes, "text-foreground"
    refute_includes title_classes, "text-lg"
    refute_includes title_classes, "leading-none"
    refute_includes title_classes, "tracking-tight"
  end

  def test_handle_uses_upstream_v4_bottom_only_group_visibility_classes
    result = render_inline(Shadcn::DrawerComponent.new(direction: :top)) do |drawer|
      drawer.with_body { "Drawer content" }
    end

    handle_classes = result.to_html[/<div class="([^"]*group-data-\[vaul-drawer-direction=bottom\]\/drawer-content:block[^"]*)"/, 1].split
    assert_includes handle_classes, "mx-auto"
    assert_includes handle_classes, "mt-4"
    assert_includes handle_classes, "hidden"
    assert_includes handle_classes, "h-2"
    assert_includes handle_classes, "w-[100px]"
    assert_includes handle_classes, "shrink-0"
    assert_includes handle_classes, "rounded-full"
    assert_includes handle_classes, "bg-muted"
    assert_includes handle_classes, "group-data-[vaul-drawer-direction=bottom]/drawer-content:block"
  end

  private

  def tag_with_slot(html, slot)
    html[/<[^>]*data-slot="#{slot}"[^>]*>/m].tap do |tag|
      assert tag, "Expected tag with data-slot=#{slot}"
    end
  end

  def classes_from_tag(tag)
    tag[/class="([^"]*)"/, 1].split
  end
end
