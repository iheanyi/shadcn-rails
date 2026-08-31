# frozen_string_literal: true

require "test_helper"

class TabsComponentTest < ViewComponent::TestCase
  def test_renders_tabs_container
    render_inline(Shadcn::TabsComponent.new)

    assert_selector "div[data-controller='shadcn--tabs']"
  end

  def test_renders_tabs_container_with_v4_classes_and_slot
    render_inline(Shadcn::TabsComponent.new)

    root = page.find("div[data-controller='shadcn--tabs']")
    classes = root[:class]

    assert_equal "tabs", root["data-slot"]
    assert_includes classes, "group/tabs"
    assert_includes classes, "flex"
    assert_includes classes, "gap-2"
    assert_includes classes, "data-[orientation=horizontal]:flex-col"
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

  def test_renders_default_tab_list_with_v4_classes_variant_and_slot
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
      end
    end

    list = page.find("div[role='tablist']")
    classes = list[:class]
    class_tokens = classes.split

    assert_equal "tabs-list", list["data-slot"]
    assert_equal "default", list["data-variant"]
    assert_includes classes, "group/tabs-list"
    assert_includes class_tokens, "w-fit"
    assert_includes class_tokens, "p-[3px]"
    assert_includes class_tokens, "bg-muted"
    assert_includes class_tokens, "group-data-[orientation=horizontal]/tabs:h-9"
    assert_includes class_tokens, "group-data-[orientation=vertical]/tabs:h-fit"
    assert_includes class_tokens, "group-data-[orientation=vertical]/tabs:flex-col"
    assert_includes class_tokens, "data-[variant=line]:rounded-none"
    refute_includes class_tokens, "h-9"
    refute_includes class_tokens, "p-1"
  end

  def test_renders_line_tab_list_variant_with_v4_classes
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list(variant: :line) do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
      end
    end

    list = page.find("div[role='tablist']")
    class_tokens = list[:class].split

    assert_equal "line", list["data-variant"]
    assert_includes class_tokens, "gap-1"
    assert_includes class_tokens, "bg-transparent"
    refute_includes class_tokens, "bg-muted"
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

  def test_renders_trigger_with_v4_classes_and_slot
    render_inline(Shadcn::TabsComponent.new(default_value: "tab1")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "tab1") { "Tab 1" }
      end
    end

    trigger = page.find("button[role='tab']")
    classes = trigger[:class]
    class_tokens = classes.split

    assert_equal "tabs-trigger", trigger["data-slot"]
    assert_includes class_tokens, "relative"
    assert_includes class_tokens, "h-[calc(100%-1px)]"
    assert_includes class_tokens, "border-transparent"
    assert_includes class_tokens, "text-foreground/60"
    assert_includes class_tokens, "focus-visible:ring-[3px]"
    assert_includes class_tokens, "focus-visible:ring-ring/50"
    assert_includes class_tokens, "group-data-[variant=default]/tabs-list:data-[state=active]:shadow-sm"
    assert_includes class_tokens, "group-data-[variant=line]/tabs-list:data-[state=active]:shadow-none"
    assert_includes class_tokens, "group-data-[variant=line]/tabs-list:bg-transparent"
    assert_includes class_tokens, "group-data-[variant=line]/tabs-list:data-[state=active]:bg-transparent"
    assert_includes class_tokens, "data-[state=active]:bg-background"
    assert_includes class_tokens, "dark:data-[state=active]:bg-input/30"
    assert_includes class_tokens, "after:absolute"
    assert_includes class_tokens, "group-data-[variant=line]/tabs-list:data-[state=active]:after:opacity-100"
    refute_includes class_tokens, "ring-offset-background"
    refute_includes class_tokens, "focus-visible:ring-2"
    refute_includes class_tokens, "focus-visible:ring-offset-2"
    refute_includes class_tokens, "data-[state=active]:shadow"
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

  def test_renders_content_with_v4_classes_and_slot
    render_inline(Shadcn::TabsComponent.new(default_value: "account")) do |tabs|
      tabs.with_panel(value: "account") { "Account content" }
    end

    content = page.find("div[role='tabpanel']", visible: :all)
    class_tokens = content[:class].split

    assert_equal "tabs-content", content["data-slot"]
    assert_includes class_tokens, "flex-1"
    assert_includes class_tokens, "outline-none"
    refute_includes class_tokens, "mt-2"
    refute_includes class_tokens, "ring-offset-background"
    refute_includes class_tokens, "focus-visible:ring-offset-2"
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
