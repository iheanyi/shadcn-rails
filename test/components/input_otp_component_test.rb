# frozen_string_literal: true

require "test_helper"

class InputOtpComponentTest < ViewComponent::TestCase
  def test_renders_otp_container
    render_inline(Shadcn::InputOtpComponent.new(length: 6, name: "otp"))

    assert_selector "div[data-controller='shadcn--input-otp']"
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
end
