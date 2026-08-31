# frozen_string_literal: true

require "test_helper"

class AccordionComponentTest < ViewComponent::TestCase
  def test_renders_accordion_container
    render_inline(Shadcn::AccordionComponent.new)

    assert_selector "div[data-controller='shadcn--accordion']"
  end

  def test_renders_with_single_type
    render_inline(Shadcn::AccordionComponent.new(type: :single))

    assert_selector "div[data-shadcn--accordion-type-value='single']"
  end

  def test_renders_with_multiple_type
    render_inline(Shadcn::AccordionComponent.new(type: :multiple))

    assert_selector "div[data-shadcn--accordion-type-value='multiple']"
  end

  def test_renders_with_collapsible
    render_inline(Shadcn::AccordionComponent.new(collapsible: true))

    assert_selector "div[data-shadcn--accordion-collapsible-value='true']"
  end

  def test_renders_with_default_value
    render_inline(Shadcn::AccordionComponent.new(default_value: "item-1"))

    assert_selector "div[data-shadcn--accordion-default-value='item-1']"
  end

  def test_renders_items_with_slots
    render_inline(Shadcn::AccordionComponent.new) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Question 1" }
        item.with_body { "Answer 1" }
      end
    end

    assert_selector "div[data-shadcn--accordion-target='item']"
    assert_selector "button[data-shadcn--accordion-target='trigger']", text: "Question 1"
    assert_selector "div[data-shadcn--accordion-target='content']", text: "Answer 1", visible: :all
  end

  def test_renders_multiple_items
    render_inline(Shadcn::AccordionComponent.new) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Q1" }
        item.with_body { "A1" }
      end
      accordion.with_item(value: "item-2") do |item|
        item.with_trigger { "Q2" }
        item.with_body { "A2" }
      end
    end

    assert_selector "div[data-value='item-1']"
    assert_selector "div[data-value='item-2']"
  end

  def test_renders_trigger_with_chevron_icon
    render_inline(Shadcn::AccordionComponent.new) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Question" }
        item.with_body { "Answer" }
      end
    end

    assert_selector "button svg" # Chevron icon
  end

  def test_uses_new_york_v4_classes
    render_inline(Shadcn::AccordionComponent.new) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Question" }
        item.with_body { "Answer" }
      end
    end

    item_classes = page.find("div[data-shadcn--accordion-target='item']")[:class].split
    trigger_classes = page.find("button[data-shadcn--accordion-target='trigger']")[:class].split
    chevron_classes = page.find("button svg")[:class].split

    assert_includes item_classes, "border-b"
    assert_includes item_classes, "last:border-b-0"
    assert_includes trigger_classes, "items-start"
    assert_includes trigger_classes, "gap-4"
    assert_includes trigger_classes, "rounded-md"
    assert_includes trigger_classes, "outline-none"
    assert_includes trigger_classes, "focus-visible:border-ring"
    assert_includes trigger_classes, "focus-visible:ring-[3px]"
    assert_includes trigger_classes, "focus-visible:ring-ring/50"
    assert_includes trigger_classes, "disabled:pointer-events-none"
    assert_includes trigger_classes, "disabled:opacity-50"
    assert_includes trigger_classes, "[&[data-state=open]>svg]:rotate-180"
    assert_includes chevron_classes, "size-4"
    refute_includes trigger_classes, "items-center"
    refute_includes trigger_classes, "focus-visible:ring-2"
    refute_includes trigger_classes, "data-[size=default]"
    refute_includes chevron_classes, "h-4"
    refute_includes chevron_classes, "w-4"
  end

  def test_renders_trigger_with_aria_attributes
    render_inline(Shadcn::AccordionComponent.new) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Question" }
        item.with_body { "Answer" }
      end
    end

    assert_selector "button[aria-expanded='false']"
  end

  def test_renders_content_with_role
    render_inline(Shadcn::AccordionComponent.new) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Question" }
        item.with_body { "Answer" }
      end
    end

    assert_selector "div[role='region']", visible: :all
  end

  def test_renders_with_custom_class
    render_inline(Shadcn::AccordionComponent.new(class_name: "my-accordion"))

    assert_selector "div.my-accordion"
  end
end
