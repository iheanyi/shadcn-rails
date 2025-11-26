# frozen_string_literal: true

require "test_helper"

class DrawerComponentTest < ViewComponent::TestCase
  def test_renders_drawer_container
    render_inline(Shadcn::DrawerComponent.new)

    assert_selector "div[data-controller='shadcn--drawer']"
  end

  def test_renders_with_trigger
    render_inline(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_trigger { "Open Drawer" }
    end

    assert_selector "[data-shadcn--drawer-target='trigger']", text: "Open Drawer"
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
end
