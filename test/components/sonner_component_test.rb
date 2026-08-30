# frozen_string_literal: true

require "test_helper"

class SonnerComponentTest < ViewComponent::TestCase
  def test_renders_sonner_toaster_viewport
    render_inline(Shadcn::SonnerComponent.new)

    assert_selector "div[data-controller='shadcn--sonner']"
    assert_selector "ol#shadcn-sonner-viewport[role='region'][aria-label='Notifications']"
    assert_selector "ol[data-shadcn--sonner-target='viewport']"
    assert_selector "ol[data-turbo-permanent]"
  end

  def test_renders_controller_values
    render_inline(Shadcn::SonnerComponent.new(position: :top_center, limit: 5, duration: 2500))

    assert_selector "div[data-shadcn--sonner-position-value='top-center']"
    assert_selector "div[data-shadcn--sonner-limit-value='5']"
    assert_selector "div[data-shadcn--sonner-duration-value='2500']"
  end

  def test_renders_position_classes
    render_inline(Shadcn::SonnerComponent.new(position: :top_right))

    assert_selector "ol.top-0.right-0.flex-col"
  end

  def test_renders_bottom_positions_in_reverse_stack_order
    render_inline(Shadcn::SonnerComponent.new(position: :bottom_left))

    assert_selector "ol.bottom-0.left-0.flex-col-reverse"
  end

  def test_renders_content_inside_controller_scope
    render_inline(Shadcn::SonnerComponent.new) do
      "<button data-action=\"click->shadcn--sonner#demo\">Show toast</button>".html_safe
    end

    assert_selector "div[data-controller='shadcn--sonner'] button[data-action='click->shadcn--sonner#demo']", text: "Show toast"
  end

  def test_supports_toaster_component_alias
    render_inline(Shadcn::ToasterComponent.new(position: "bottom-center", id: "notifications"))

    assert_selector "div[data-controller='shadcn--sonner']"
    assert_selector "ol#notifications[class*='bottom-0'][class*='left-1/2']"
  end

  def test_supports_short_sonner_constant
    render_inline(Shadcn::Sonner.new)

    assert_selector "div[data-controller='shadcn--sonner']"
  end

  def test_rejects_unknown_position
    error = assert_raises(ArgumentError) do
      render_inline(Shadcn::SonnerComponent.new(position: :middle))
    end

    assert_includes error.message, "Unknown Sonner position"
  end
end
