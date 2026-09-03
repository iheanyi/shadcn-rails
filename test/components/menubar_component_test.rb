# frozen_string_literal: true

require "test_helper"

class MenubarComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_menubar_container
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "div[data-controller='shadcn--menubar']"
  end

  def test_renders_with_menubar_role
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "div[role='menubar']"
  end

  def test_renders_with_base_classes
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "div.flex"
    assert_selector "div.items-center"
    assert_selector "div.rounded-md"
    assert_selector "div.border"
    assert_selector "div.bg-background"
    assert_selector "div.shadow-xs"
    assert_selector "div.gap-1"
    assert_no_selector "div.space-x-1"
  end

  def test_content_uses_v4_animation_origin_and_side_tokens
    render_inline(Shadcn::MenubarContentComponent.new)

    assert_includes rendered_content, "origin-(--radix-menubar-content-transform-origin)"
    assert_includes rendered_content, "data-[side=bottom]:slide-in-from-top-2"
    assert_selector "[data-side='bottom']", visible: :all
  end

  def test_item_uses_v4_item_tokens
    render_inline(Shadcn::MenubarItemComponent.new(inset: true, variant: :destructive)) { "Delete" }

    assert_includes rendered_content, "outline-hidden"
    assert_includes rendered_content, "[&amp;_svg:not([class*=&#39;size-&#39;])]:size-4"
    assert_selector "[data-inset]", visible: :all
    assert_selector "[data-variant='destructive']", visible: :all
  end

  # Menu slots
  def test_renders_with_single_menu
    render_inline(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu do |menu|
        menu.with_trigger { "File" }
      end
    end

    assert_selector "[data-shadcn--menubar-target='menu']"
  end

  def test_renders_with_multiple_menus
    render_inline(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu do |menu|
        menu.with_trigger { "File" }
      end
      menubar.with_menu do |menu|
        menu.with_trigger { "Edit" }
      end
      menubar.with_menu do |menu|
        menu.with_trigger { "View" }
      end
    end

    assert_selector "[data-shadcn--menubar-target='menu']", count: 3
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::MenubarComponent.new(class_name: "my-menubar"))

    assert_selector "div.my-menubar"
  end

  # Stimulus controller
  def test_has_stimulus_controller
    render_inline(Shadcn::MenubarComponent.new)

    assert_selector "[data-controller='shadcn--menubar']"
  end
end
