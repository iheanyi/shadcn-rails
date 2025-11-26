# frozen_string_literal: true

require "test_helper"

class LabelComponentTest < ViewComponent::TestCase
  def test_renders_default_label
    render_inline(Shadcn::LabelComponent.new) { "Label" }

    assert_selector "label", text: "Label"
    assert_selector "label.text-sm.font-medium"
  end

  def test_renders_with_for_attribute
    render_inline(Shadcn::LabelComponent.new(for: "email")) { "Email" }

    assert_selector "label[for='email']"
  end

  def test_renders_required_indicator
    render_inline(Shadcn::LabelComponent.new(required: true)) { "Required Field" }

    assert_selector "label", text: /Required Field/
    assert_selector "span.text-destructive", text: "*"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::LabelComponent.new(class_name: "my-label")) { "Custom" }

    assert_selector "label.my-label"
  end
end
