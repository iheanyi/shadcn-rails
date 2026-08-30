# frozen_string_literal: true

require "test_helper"

class TabsComponentTest < ViewComponent::TestCase
  def test_renders_tabs_container
    render_inline(Shadcn::TabsComponent.new)

    assert_selector "div[data-controller='shadcn--tabs']"
  end

  def test_renders_with_default_value
    render_inline(Shadcn::TabsComponent.new(default_value: "account"))

    assert_selector "div[data-shadcn--tabs-default-value-value='account']"
    assert_no_selector "div[data-shadcn--tabs-default-value]"
  end

  def test_renders_with_horizontal_orientation
    render_inline(Shadcn::TabsComponent.new(orientation: :horizontal))

    assert_selector "div[data-orientation='horizontal']"
  end

  def test_renders_with_vertical_orientation
    render_inline(Shadcn::TabsComponent.new(orientation: :vertical))

    assert_selector "div[data-orientation='vertical']"
  end

  def test_renders_tab_list_with_role
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
      end
      tabs.with_panel(value: "tab1") { "Panel 1" }
    end

    assert_selector "div[role='tablist']"
  end

  def test_renders_triggers_with_role
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
        list.with_trigger(value: "tab2") { "Tab 2" }
      end
      tabs.with_panel(value: "tab1") { "Panel 1" }
      tabs.with_panel(value: "tab2") { "Panel 2" }
    end

    assert_selector "button[role='tab']", count: 2
    assert_selector "button[role='tab']", text: "Tab 1"
    assert_selector "button[role='tab']", text: "Tab 2"
  end

  def test_renders_panels_with_role
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
      end
      tabs.with_panel(value: "tab1") { "Panel 1 Content" }
    end

    assert_selector "div[role='tabpanel']", text: "Panel 1 Content", visible: :all
  end

  def test_renders_trigger_with_stimulus_action
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
      end
      tabs.with_panel(value: "tab1") { "Panel 1" }
    end

    assert_selector "button[data-action='click->shadcn--tabs#selectTab']"
  end

  def test_renders_trigger_data_value
    render_inline(Shadcn::TabsComponent.new(default_value: "account")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "account") { "Account" }
        list.with_trigger(value: "password") { "Password" }
      end
    end

    assert_selector "button[data-value='account']"
    assert_selector "button[data-value='password']"
  end

  def test_renders_panel_data_value
    render_inline(Shadcn::TabsComponent.new(default_value: "account")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "account") { "Account" }
      end
      tabs.with_panel(value: "account") { "Account content" }
    end

    assert_selector "div[data-value='account']", visible: :all
  end

  def test_renders_disabled_trigger
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1", disabled: true) { "Disabled Tab" }
      end
    end

    assert_selector "button[disabled]"
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::TabsComponent.new(class_name: "my-tabs"))

    assert_selector "div.my-tabs"
  end

  def test_renders_with_url_param
    render_inline(Shadcn::TabsComponent.new(default_value: "account", url_param: "tab"))

    assert_selector "div[data-shadcn--tabs-url-param-value='tab']"
  end

  def test_renders_without_url_param_when_not_specified
    render_inline(Shadcn::TabsComponent.new(default_value: "account"))

    assert_no_selector "div[data-shadcn--tabs-url-param-value]"
  end

  def test_url_param_is_passed_to_stimulus_controller
    render_inline(Shadcn::TabsComponent.new(default_value: "settings", url_param: "section")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "general") { "General" }
        list.with_trigger(value: "security") { "Security" }
      end
      tabs.with_panel(value: "general") { "General content" }
      tabs.with_panel(value: "security") { "Security content" }
    end

    assert_selector "div[data-controller='shadcn--tabs'][data-shadcn--tabs-url-param-value='section']"
  end
end
