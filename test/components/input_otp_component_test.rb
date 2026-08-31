# frozen_string_literal: true

require "test_helper"

class InputOtpComponentTest < ViewComponent::TestCase
  def test_renders_otp_container
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    assert_selector "div[data-slot='input-otp'][data-controller='shadcn--input-otp']"
    assert_selector "div.flex.items-center"
  end

  def test_renders_correct_number_of_slots
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    assert_selector "input[type='text'][maxlength='1']", count: 6
  end

  def test_renders_4_digit_pin
    render_inline(Shadcn::InputOtpComponent.new(length: 4, name: "pin"))

    assert_selector "input[type='text'][maxlength='1']", count: 4
  end

  def test_renders_hidden_input_for_form_submission
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "verification_code"))

    assert_selector "input[type='hidden'][name='verification_code']", visible: :all
  end

  def test_renders_with_groups_and_separator
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp")) do |otp|
      otp.with_group(slots: 3)
      otp.with_separator
      otp.with_group(slots: 3)
    end

    assert_selector "div[role='separator']"
    assert_selector "input[type='text'][maxlength='1']", count: 6
  end

  def test_renders_disabled_state
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp", disabled: true))

    assert_selector "input[disabled]", count: 6
    assert_selector "div[data-shadcn--input-otp-disabled-value='true']"
  end

  def test_renders_with_pattern
    render_inline(Shadcn::InputOtpComponent.new(length: 4, name: "pin", pattern: "^[0-9]*$"))

    assert_selector "div[data-shadcn--input-otp-pattern-value='^[0-9]*$']"
  end

  def test_renders_numeric_inputmode
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    assert_selector "input[inputmode='numeric']", count: 6
  end

  def test_renders_with_autocomplete_on_first_input
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    assert_selector "input[autocomplete='one-time-code']", count: 1
    assert_selector "input[autocomplete='off']", count: 5
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp", class_name: "my-otp"))

    assert_selector "div.my-otp"
  end

  def test_uses_new_york_v4_container_classes
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    classes = page.find("div[data-slot='input-otp']")[:class]
    assert_equal "flex items-center gap-2 has-disabled:opacity-50", classes
  end

  def test_uses_new_york_v4_slot_classes
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    classes = page.find("div[data-slot='input-otp-slot']", match: :first)[:class]
    assert_includes classes, "relative"
    assert_includes classes, "flex"
    assert_includes classes, "h-9"
    assert_includes classes, "w-9"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "outline-none"
    assert_includes classes, "aria-invalid:border-destructive"
    assert_includes classes, "data-[active=true]:z-10"
    assert_includes classes, "data-[active=true]:border-ring"
    assert_includes classes, "data-[active=true]:ring-[3px]"
    assert_includes classes, "data-[active=true]:ring-ring/50"
    assert_includes classes, "data-[active=true]:aria-invalid:border-destructive"
    assert_includes classes, "data-[active=true]:aria-invalid:ring-destructive/20"
    assert_includes classes, "dark:bg-input/30"
    assert_includes classes, "dark:data-[active=true]:aria-invalid:ring-destructive/40"
    refute_includes classes, "h-10"
    refute_includes classes, "w-10"
    refute_includes classes, "shadow-sm"
    refute_includes classes, "ring-1"
  end

  def test_renders_new_york_v4_data_slots
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp")) do |otp|
      otp.with_group(slots: 3)
      otp.with_separator
      otp.with_group(slots: 3)
    end

    assert_selector "[data-slot='input-otp']"
    assert_selector "[data-slot='input-otp-group']", count: 2
    assert_selector "[data-slot='input-otp-slot'][data-active='false']", count: 6
    assert_selector "[data-slot='input-otp-separator'][role='separator']"
  end
end
