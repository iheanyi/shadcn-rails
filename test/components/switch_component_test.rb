# frozen_string_literal: true

require "test_helper"

class SwitchComponentTest < ViewComponent::TestCase
  def test_renders_default_switch
    render_inline(Shadcn::SwitchComponent.new)

    assert_selector "button[role='switch']"
    assert_selector "button[data-state='unchecked']"
    assert_selector "button[aria-checked='false']"
    assert_selector "button[data-slot='switch']"
    assert_no_selector "button[data-size]"
  end

  def test_renders_v4_switch_track_classes_without_size_variant_selectors
    render_inline(Shadcn::SwitchComponent.new)

    classes = page.find("button[role='switch']")["class"].split

    assert_includes classes, "peer"
    assert_includes classes, "inline-flex"
    assert_includes classes, "shrink-0"
    assert_includes classes, "items-center"
    assert_includes classes, "rounded-full"
    assert_includes classes, "border"
    assert_includes classes, "border-transparent"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "transition-all"
    assert_includes classes, "outline-none"
    assert_includes classes, "focus-visible:border-ring"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "disabled:cursor-not-allowed"
    assert_includes classes, "disabled:opacity-50"
    assert_includes classes, "h-[1.15rem]"
    assert_includes classes, "w-8"
    assert_includes classes, "data-[state=checked]:bg-primary"
    assert_includes classes, "data-[state=unchecked]:bg-input"
    assert_includes classes, "dark:data-[state=unchecked]:bg-input/80"

    refute_includes classes, "group/switch"
    refute_includes classes, "data-[size=default]:h-[1.15rem]"
    refute_includes classes, "data-[size=default]:w-8"
    refute_includes classes, "data-[size=sm]:h-3.5"
    refute_includes classes, "data-[size=sm]:w-6"
    refute_includes classes, "h-5"
    refute_includes classes, "w-9"
    refute_includes classes, "border-2"
    refute_includes classes, "shadow-sm"
    refute_includes classes, "focus-visible:ring-2"
    refute_includes classes, "focus-visible:ring-offset-2"
    refute_includes classes, "focus-visible:ring-offset-background"
  end

  def test_renders_v4_switch_thumb_classes_without_size_variant_selectors
    render_inline(Shadcn::SwitchComponent.new)

    thumb = page.find("button[role='switch'] span[data-slot='switch-thumb']")
    classes = thumb["class"].split

    assert_includes classes, "pointer-events-none"
    assert_includes classes, "block"
    assert_includes classes, "size-4"
    assert_includes classes, "rounded-full"
    assert_includes classes, "bg-background"
    assert_includes classes, "ring-0"
    assert_includes classes, "transition-transform"
    assert_includes classes, "data-[state=checked]:translate-x-3.5"
    assert_includes classes, "data-[state=unchecked]:translate-x-0"
    assert_includes classes, "dark:data-[state=checked]:bg-primary-foreground"
    assert_includes classes, "dark:data-[state=unchecked]:bg-foreground"

    refute_includes classes, "group-data-[size=default]/switch:size-4"
    refute_includes classes, "group-data-[size=sm]/switch:size-3"
    refute_includes classes, "data-[state=checked]:translate-x-[calc(100%-2px)]"
    refute_includes classes, "shadow-lg"
    refute_includes classes, "duration-150"
    refute_includes classes, "data-[state=checked]:translate-x-4"
  end

  def test_renders_with_name_and_id
    render_inline(Shadcn::SwitchComponent.new(name: "notifications", id: "notifications-switch"))

    # Hidden inputs for form submission
    assert_selector "input[type='hidden'][name='notifications'][value='0']", visible: :all
    assert_selector "input[type='checkbox'][name='notifications'][id='notifications-switch']", visible: :all
  end

  def test_renders_checked_state
    render_inline(Shadcn::SwitchComponent.new(checked: true))

    assert_selector "button[data-state='checked']"
    assert_selector "button[aria-checked='true']"
  end

  def test_renders_disabled_state
    render_inline(Shadcn::SwitchComponent.new(disabled: true))

    assert_selector "button[disabled]"
  end

  def test_disabled_switch_does_not_render_hidden_unchecked_input
    render_inline(Shadcn::SwitchComponent.new(name: "locked", disabled: true))

    assert_selector "input[type='checkbox'][name='locked'][disabled]", visible: :all
    assert_selector "input[type='hidden'][name='locked']", count: 0
  end

  def test_renders_required_state
    render_inline(Shadcn::SwitchComponent.new(required: true))

    assert_selector "button[aria-required='true']"
  end

  def test_renders_stimulus_controller_on_wrapper
    render_inline(Shadcn::SwitchComponent.new)

    # Controller is on the wrapper span, not the button
    assert_selector "span[data-controller='shadcn--switch']"
    assert_selector "button[data-action*='click->shadcn--switch#toggle']"
  end

  def test_appends_host_data_action_without_losing_switch_actions
    render_inline(Shadcn::SwitchComponent.new(data: { action: "analytics#track" }))

    assert_selector "button[data-action='click->shadcn--switch#toggle keydown->shadcn--switch#handleKeydown analytics#track']"
  end

  def test_appends_host_data_controller_without_losing_switch_controller
    render_inline(Shadcn::SwitchComponent.new(data: { controller: "analytics" }))

    assert_selector "span[data-controller='shadcn--switch analytics']"
    assert_no_selector "button[data-controller='analytics']"
  end

  def test_renders_thumb_element
    render_inline(Shadcn::SwitchComponent.new)

    # Should have thumb span inside button
    assert_selector "button span[data-state]"
    assert_selector "button span[data-slot='switch-thumb']"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::SwitchComponent.new(class_name: "my-custom-class"))

    assert_selector "button.my-custom-class"
  end

  def test_renders_with_custom_value
    render_inline(Shadcn::SwitchComponent.new(name: "active", value: "on"))

    assert_selector "input[type='checkbox'][value='on']", visible: :all
  end

  def test_renders_with_integrated_label
    render_inline(Shadcn::SwitchComponent.new(name: "dark_mode")) { "Enable dark mode" }

    assert_selector "label.flex.items-center"
    assert_selector "label span", text: "Enable dark mode"
  end

  def test_generates_id_from_name
    render_inline(Shadcn::SwitchComponent.new(name: "notifications"))

    assert_selector "input[type='checkbox'][id='switch-notifications']", visible: :all
  end

  def test_component_css_does_not_override_switch_state_classes
    css = File.read(Rails.root.join("../../app/assets/stylesheets/shadcn/components.css"))

    refute_includes css, 'button[role="switch"][data-state="checked"]'
    refute_includes css, 'button[role="switch"][data-state="unchecked"]'
    refute_includes css, 'button[role="switch"] > span[data-state="checked"]'
    refute_includes css, "translateX(1rem)"
  end
end
