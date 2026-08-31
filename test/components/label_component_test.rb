# frozen_string_literal: true

require "test_helper"

class LabelComponentTest < ViewComponent::TestCase
  def test_renders_default_label
    render_inline(Shadcn::LabelComponent.new) { "Label" }

    assert_selector "label", text: "Label"
    assert_selector "label.text-sm.font-medium"
  end

  def test_renders_new_york_v4_class_tokens_and_data_slot
    render_inline(Shadcn::LabelComponent.new(for: "email")) { "Email" }

    label = page.find("label[for='email']")
    classes = label[:class].split

    assert_equal "flex items-center gap-2 text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50", label[:class]
    assert_equal "label", label["data-slot"]
    assert_includes classes, "flex"
    assert_includes classes, "items-center"
    assert_includes classes, "gap-2"
    assert_includes classes, "select-none"
    assert_includes classes, "peer-disabled:opacity-50"
    assert_includes classes, "group-data-[disabled=true]:pointer-events-none"
    assert_includes classes, "group-data-[disabled=true]:opacity-50"
    refute_includes classes, "peer-disabled:opacity-70"
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
