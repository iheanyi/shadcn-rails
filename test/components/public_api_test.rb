# frozen_string_literal: true

require "test_helper"

class PublicApiTest < ViewComponent::TestCase
  teardown do
    Shadcn::Rails.reset_configuration!
  end

  def test_public_component_aliases_match_component_classes
    assert_equal Shadcn::BaseComponent, Shadcn::Component
    assert_equal Shadcn::ButtonComponent, Shadcn::Button
    assert_equal Shadcn::DialogComponent, Shadcn::Dialog
    assert_equal Shadcn::DialogContentComponent, Shadcn::DialogContent
    assert_equal Shadcn::InputComponent, Shadcn::Input
  end

  def test_rendering_with_public_button_name
    render_inline(Shadcn::Button.new(class: "h-11")) { "Save" }

    assert_selector "button", text: "Save"
    assert_selector "button.h-11"
  end

  def test_tailwind_prefix_is_applied_to_component_classes
    Shadcn::Rails.configure do |config|
      config.tailwind_prefix = "tw-"
    end

    render_inline(Shadcn::Button.new(class: "h-11 hover:bg-accent shadcn-custom")) { "Save" }

    assert_selector "button.tw-inline-flex"
    assert_selector "button.tw-h-11"
    assert_no_selector "button.tw-h-9"
    assert_selector "button.hover\\:tw-bg-accent"
    assert_selector "button.shadcn-custom"
  end
end
