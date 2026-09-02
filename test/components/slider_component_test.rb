# frozen_string_literal: true

require "test_helper"

class SliderComponentTest < ViewComponent::TestCase
  COMPONENT_STYLESHEET = File.expand_path("../../app/assets/stylesheets/shadcn/components.css", __dir__)
  DUMMY_STYLESHEET = File.expand_path("../dummy/app/assets/tailwind/shadcn/components.css", __dir__)

  def test_renders_native_range_input
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "input[type='range']"
    assert_selector "input[data-controller='shadcn--slider']"
  end

  def test_renders_with_value_attributes
    render_inline(Shadcn::SliderComponent.new(min: 0, max: 100, value: 50))

    assert_selector "input[min='0.0']"
    assert_selector "input[max='100.0']"
    assert_selector "input[value='50.0']"
  end

  def test_renders_with_custom_range
    render_inline(Shadcn::SliderComponent.new(min: 1, max: 10, value: 5, step: 1))

    assert_selector "input[min='1.0']"
    assert_selector "input[max='10.0']"
    assert_selector "input[step='1.0']"
    assert_selector "input[value='5.0']"
  end

  def test_renders_with_name_attribute
    render_inline(Shadcn::SliderComponent.new(name: "volume", value: 50))

    assert_selector "input[type='range'][name='volume'][value='50.0']"
  end

  def test_does_not_render_name_without_name_param
    result = render_inline(Shadcn::SliderComponent.new(value: 50))

    refute result.css("input[name]").any?
  end

  def test_renders_with_disabled_state
    render_inline(Shadcn::SliderComponent.new(disabled: true))

    assert_selector "input[disabled]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SliderComponent.new(class_name: "my-slider"))

    assert_selector "input.my-slider"
  end

  def test_calculates_percentage_style
    result = render_inline(Shadcn::SliderComponent.new(min: 0, max: 100, value: 25))

    # The style should include the fill percentage
    html = result.to_html
    assert html.include?("--slider-fill: 25.0%")
  end

  def test_renders_with_stimulus_action
    render_inline(Shadcn::SliderComponent.new)

    assert_selector "input[data-action='input->shadcn--slider#updateStyle']"
  end

  def test_renders_base_classes
    result = render_inline(Shadcn::SliderComponent.new)
    class_tokens = result.css("input").first["class"].split

    assert_includes class_tokens, "shadcn-slider"
    assert_includes class_tokens, "w-full"
    assert_includes class_tokens, "h-1.5"
    assert_includes class_tokens, "bg-muted"
    assert_includes class_tokens, "disabled:pointer-events-none"
    assert_includes class_tokens, "disabled:opacity-50"
    refute_includes class_tokens, "bg-primary/20"
    refute_includes class_tokens, "focus-visible:ring-2"
    refute_includes class_tokens, "focus-visible:ring-ring"
    refute_includes class_tokens, "focus-visible:ring-offset-2"
    refute_includes class_tokens, "ring-offset-2"
  end

  def test_slider_css_uses_new_york_v4_native_tokens
    [COMPONENT_STYLESHEET, DUMMY_STYLESHEET].each do |stylesheet|
      css = slider_css(stylesheet)

      assert_includes css, "height: 0.375rem;"
      assert_includes css, "hsl(var(--muted)) var(--slider-fill, 0%)"
      assert_includes css, "background: hsl(var(--muted));"
      assert_includes css, "width: 1rem;"
      assert_includes css, "height: 1rem;"
      assert_includes css, "background: #fff;"
      assert_includes css, "border: 1px solid hsl(var(--primary));"
      assert_includes css, "box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);"
      assert_includes css, "0 0 0 4px hsl(var(--ring) / 0.5)"
      refute_includes css, "hsl(var(--secondary))"
      refute_includes css, "1.25rem"
      refute_includes css, "background: hsl(var(--background));"
      refute_includes css, "0 0 0 2px hsl(var(--background))"
      refute_includes css, "transform: scale"
    end
  end

  private

  def slider_css(stylesheet)
    css = File.read(stylesheet)
    css[/\/\* Slider Component.*?\/\* ============================================\n   Checkbox Component/m]
  end
end
