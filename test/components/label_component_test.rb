# frozen_string_literal: true

require_relative "../test_helper"
require "view_component/test_case"

class LabelComponentTest < ViewComponent::TestCase
  def test_renders_default_label
    render_inline(Ui::LabelComponent.new) { "Email" }

    assert_selector "label", text: "Email"
    assert_selector "label.text-sm"
    assert_selector "label.font-medium"
  end

  def test_renders_with_for_attribute
    render_inline(Ui::LabelComponent.new(for_id: "email-input")) { "Email" }

    assert_selector "label[for='email-input']"
  end

  def test_renders_required_indicator
    render_inline(Ui::LabelComponent.new(required: true)) { "Required Field" }

    assert_text "Required Field"
    assert_selector "span.text-destructive", text: "*"
  end

  def test_does_not_render_required_indicator_when_not_required
    render_inline(Ui::LabelComponent.new(required: false)) { "Optional" }

    assert_no_selector "span.text-destructive"
  end

  def test_accepts_custom_classes
    render_inline(Ui::LabelComponent.new(class_name: "custom-label")) { "Label" }

    assert_selector "label.custom-label"
  end

  def test_has_proper_styling
    render_inline(Ui::LabelComponent.new) { "Label" }

    assert_selector "label.leading-none"
  end
end
