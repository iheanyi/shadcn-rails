# frozen_string_literal: true

require "test_helper"

class InputGroupComponentTest < ViewComponent::TestCase
  def test_renders_input_group_container_with_upstream_classes
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_input(placeholder: "Search")
    end

    assert_selector "div[data-slot='input-group'][role='group']"

    classes = class_list("[data-slot='input-group']")
    upstream_tokens = %w[
      group/input-group
      relative
      flex
      w-full
      items-center
      rounded-md
      border
      border-input
      shadow-xs
      transition-[color,box-shadow]
      outline-none
      dark:bg-input/30
      h-9
      min-w-0
      has-[>textarea]:h-auto
      has-[>[data-align=inline-start]]:[&>input]:pl-2
      has-[>[data-align=inline-end]]:[&>input]:pr-2
      has-[>[data-align=block-start]]:h-auto
      has-[>[data-align=block-start]]:flex-col
      has-[>[data-align=block-start]]:[&>input]:pb-3
      has-[>[data-align=block-end]]:h-auto
      has-[>[data-align=block-end]]:flex-col
      has-[>[data-align=block-end]]:[&>input]:pt-3
      has-[[data-slot=input-group-control]:focus-visible]:border-ring
      has-[[data-slot=input-group-control]:focus-visible]:ring-[3px]
      has-[[data-slot=input-group-control]:focus-visible]:ring-ring/50
      has-[[data-slot][aria-invalid=true]]:border-destructive
      has-[[data-slot][aria-invalid=true]]:ring-destructive/20
      dark:has-[[data-slot][aria-invalid=true]]:ring-destructive/40
    ]

    upstream_tokens.each { |token| assert_includes classes, token }
    refute_includes classes, "focus-within:border-ring"
    refute_includes classes, "focus-within:ring-ring/50"
    refute_includes classes, "focus-within:ring-[3px]"
  end

  def test_renders_with_prefix
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "$" }
      group.with_input(placeholder: "Amount")
    end

    assert_selector "div[data-slot='input-group-addon'][data-align='inline-start']", text: "$"
    assert_selector "input[placeholder='Amount']"
  end

  def test_renders_with_suffix
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_input(type: :email)
      group.with_suffix { "@example.com" }
    end

    assert_selector "div[data-slot='input-group-addon'][data-align='inline-end']", text: "@example.com"
    assert_selector "input[type='email']"
  end

  def test_renders_with_both_prefix_and_suffix
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "$" }
      group.with_input(type: :number, placeholder: "0.00")
      group.with_suffix { "USD" }
    end

    assert_selector "div[data-slot='input-group-addon']", text: "$"
    assert_selector "div[data-slot='input-group-addon']", text: "USD"
    assert_selector "input[type='number']"
  end

  def test_input_uses_upstream_input_group_control_classes
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_input
    end

    assert_selector "input[data-slot='input-group-control']"
    classes = class_list("input")
    upstream_tokens = %w[
      flex-1
      rounded-none
      border-0
      bg-transparent
      shadow-none
      focus-visible:ring-0
      dark:bg-transparent
    ]

    upstream_tokens.each { |token| assert_includes classes, token }
    refute_includes classes, "ring-0"
    refute_includes classes, "focus:ring-0"
    refute_includes classes, "focus-visible:border-transparent"
    refute_includes classes, "focus-visible:outline-none"
  end

  def test_addon_uses_upstream_base_and_alignment_classes
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "Prefix" }
      group.with_input
      group.with_suffix { "Suffix" }
    end

    prefix_classes = class_list("[data-align='inline-start']")
    suffix_classes = class_list("[data-align='inline-end']")
    base_tokens = %w[
      flex
      h-auto
      cursor-text
      items-center
      justify-center
      gap-2
      py-1.5
      text-sm
      font-medium
      text-muted-foreground
      select-none
      group-data-[disabled=true]/input-group:opacity-50
      [&>kbd]:rounded-[calc(var(--radius)-5px)]
      [&>svg:not([class*='size-'])]:size-4
    ]

    base_tokens.each { |token| assert_includes prefix_classes, token }
    %w[order-first pl-3 has-[>button]:ml-[-0.45rem] has-[>kbd]:ml-[-0.35rem]].each do |token|
      assert_includes prefix_classes, token
    end
    %w[order-last pr-3 has-[>button]:mr-[-0.45rem] has-[>kbd]:mr-[-0.35rem]].each do |token|
      assert_includes suffix_classes, token
    end
    refute_includes prefix_classes, "px-3"
  end

  def test_addon_supports_upstream_block_alignment_classes
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix(align: :block_start) { "Label" }
      group.with_textarea
    end

    classes = class_list("[data-align='block-start']")
    %w[
      order-first
      w-full
      justify-start
      px-3
      pt-3
      group-has-[>input]/input-group:pt-2.5
      [.border-b]:pb-3
    ].each { |token| assert_includes classes, token }
  end

  def test_textarea_uses_upstream_input_group_control_classes
    render_inline(Shadcn::InputGroupComponent.new) do |group|
      group.with_textarea(placeholder: "Notes")
    end

    assert_selector "textarea[data-slot='input-group-control'][placeholder='Notes']"
    classes = class_list("textarea")
    %w[
      flex-1
      resize-none
      rounded-none
      border-0
      bg-transparent
      py-3
      shadow-none
      focus-visible:ring-0
      dark:bg-transparent
    ].each { |token| assert_includes classes, token }
  end

  def test_text_component_uses_upstream_classes
    render_inline(Shadcn::InputGroupComponent::InputGroupTextComponent.new) { "USD" }

    classes = class_list("span")
    %w[
      flex
      items-center
      gap-2
      text-sm
      text-muted-foreground
      [&_svg]:pointer-events-none
      [&_svg:not([class*='size-'])]:size-4
    ].each { |token| assert_includes classes, token }
  end

  def test_button_component_uses_upstream_input_group_button_classes
    render_inline(Shadcn::InputGroupComponent::InputGroupButtonComponent.new) { "Go" }

    assert_selector "button[data-size='xs'][data-variant='ghost']", text: "Go"
    refute_selector "button[data-size='default']"

    classes = class_list("button")
    %w[
      flex
      items-center
      gap-1
      text-sm
      shadow-none
      h-6
      rounded-[calc(var(--radius)-5px)]
      px-2
      has-[>svg]:px-2
      [&>svg:not([class*='size-'])]:size-3.5
    ].each { |token| assert_includes classes, token }

    %w[
      h-9
      px-4
      py-2
      has-[>svg]:px-3
    ].each { |token| refute_includes classes, token }
  end

  def test_icon_button_component_uses_input_group_size_without_default_button_size_classes
    render_inline(Shadcn::InputGroupComponent::InputGroupButtonComponent.new(size: :icon_xs)) { "Icon" }

    assert_selector "button[data-size='icon-xs'][data-variant='ghost']", text: "Icon"

    classes = class_list("button")
    %w[
      size-6
      rounded-[calc(var(--radius)-5px)]
      p-0
      has-[>svg]:p-0
    ].each { |token| assert_includes classes, token }

    %w[
      h-9
      px-4
      py-2
      has-[>svg]:px-3
    ].each { |token| refute_includes classes, token }
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::InputGroupComponent.new(class_name: "my-input-group")) do |group|
      group.with_input
    end

    assert_selector "div.my-input-group"
  end

  private

  def class_list(selector)
    page.find(selector)[:class].split
  end
end
