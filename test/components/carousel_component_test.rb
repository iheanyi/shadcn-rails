# frozen_string_literal: true

require "test_helper"

class CarouselComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_carousel_container
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "div[data-controller='shadcn--carousel']"
    assert_selector "div[data-slot='carousel']"
  end

  def test_renders_with_relative_class
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "div.relative"
  end

  def test_renders_with_region_role
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "div[role='region']"
  end

  def test_renders_with_aria_roledescription
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "div[aria-roledescription='carousel']"
  end

  # Orientation variants
  def test_renders_horizontal_by_default
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "[data-shadcn--carousel-orientation-value='horizontal']"
  end

  def test_renders_vertical_orientation
    render_inline(Shadcn::CarouselComponent.new(orientation: :vertical))

    assert_selector "[data-shadcn--carousel-orientation-value='vertical']"
  end

  # Loop option
  def test_renders_without_loop_by_default
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "[data-shadcn--carousel-loop-value='false']"
  end

  def test_renders_with_loop
    render_inline(Shadcn::CarouselComponent.new(loop: true))

    assert_selector "[data-shadcn--carousel-loop-value='true']"
  end

  # Autoplay options
  def test_renders_without_autoplay_by_default
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "[data-shadcn--carousel-autoplay-value='false']"
  end

  def test_renders_with_autoplay
    render_inline(Shadcn::CarouselComponent.new(autoplay: true))

    assert_selector "[data-shadcn--carousel-autoplay-value='true']"
  end

  def test_renders_with_default_autoplay_interval
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "[data-shadcn--carousel-autoplay-interval-value='4000']"
  end

  def test_renders_with_custom_autoplay_interval
    render_inline(Shadcn::CarouselComponent.new(autoplay_interval: 3000))

    assert_selector "[data-shadcn--carousel-autoplay-interval-value='3000']"
  end

  # Align options
  def test_renders_with_start_align_by_default
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "[data-shadcn--carousel-align-value='start']"
  end

  def test_renders_with_center_align
    render_inline(Shadcn::CarouselComponent.new(align: :center))

    assert_selector "[data-shadcn--carousel-align-value='center']"
  end

  def test_renders_with_end_align
    render_inline(Shadcn::CarouselComponent.new(align: :end))

    assert_selector "[data-shadcn--carousel-align-value='end']"
  end

  # Slides slot
  def test_renders_with_slides
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_slides do |slides|
        slides.with_item { "Slide 1" }
        slides.with_item { "Slide 2" }
      end
    end

    assert_selector "[data-shadcn--carousel-target='viewport']"
    assert_selector "[data-slot='carousel-content']"
    assert_selector "[data-shadcn--carousel-target='content']"
    assert_selector "[data-shadcn--carousel-target='item']", count: 2
    assert_selector "[data-slot='carousel-item']", count: 2
  end

  def test_slide_items_have_group_role
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_slides do |slides|
        slides.with_item { "Slide 1" }
      end
    end

    assert_selector "[role='group'][aria-roledescription='slide']"
  end

  def test_slide_item_uses_new_york_v4_item_tokens
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_slides do |slides|
        slides.with_item { "Slide 1" }
      end
    end

    classes = page.find("[data-slot='carousel-item']")[:class]

    assert_includes classes, "min-w-0"
    assert_includes classes, "shrink-0"
    assert_includes classes, "grow-0"
    assert_includes classes, "basis-full"
    assert_includes classes, "pl-4"
  end

  # Navigation buttons
  def test_renders_with_previous_button
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_previous { "Prev" }
    end

    assert_selector "button[data-shadcn--carousel-target='prevButton']", text: "Prev"
  end

  def test_previous_button_has_action
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_previous { "Prev" }
    end

    assert_selector "button[data-action='click->shadcn--carousel#previous']"
  end

  def test_previous_button_has_aria_label
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_previous { "Prev" }
    end

    assert_selector "button[aria-label='Previous slide']"
  end

  def test_previous_button_uses_new_york_v4_button_tokens
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_previous
    end

    button = page.find("button[data-slot='carousel-previous']")
    classes = button[:class]
    class_tokens = classes.split

    assert_includes classes, "absolute"
    assert_includes classes, "size-8"
    assert_includes classes, "rounded-full"
    assert_includes classes, "top-1/2"
    assert_includes classes, "-left-12"
    assert_includes classes, "-translate-y-1/2"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"

    refute_includes class_tokens, "h-8"
    refute_includes class_tokens, "w-8"
    refute_includes class_tokens, "focus-visible:outline-none"
    refute_includes class_tokens, "focus-visible:ring-2"
    refute_includes class_tokens, "focus-visible:ring-offset-2"
    refute_includes class_tokens, "border-input"
    refute_includes button.native.to_html, 'class="h-4 w-4"'
  end

  def test_renders_with_next_button
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_next { "Next" }
    end

    assert_selector "button[data-shadcn--carousel-target='nextButton']", text: "Next"
  end

  def test_next_button_has_action
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_next { "Next" }
    end

    assert_selector "button[data-action='click->shadcn--carousel#next']"
  end

  def test_next_button_has_aria_label
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_next { "Next" }
    end

    assert_selector "button[aria-label='Next slide']"
  end

  def test_next_button_uses_new_york_v4_button_tokens
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_next
    end

    button = page.find("button[data-slot='carousel-next']")
    classes = button[:class]
    class_tokens = classes.split

    assert_includes classes, "absolute"
    assert_includes classes, "size-8"
    assert_includes classes, "rounded-full"
    assert_includes classes, "top-1/2"
    assert_includes classes, "-right-12"
    assert_includes classes, "-translate-y-1/2"
    assert_includes classes, "shadow-xs"
    assert_includes classes, "focus-visible:ring-[3px]"
    assert_includes classes, "focus-visible:ring-ring/50"
    assert_includes classes, "[&_svg:not([class*='size-'])]:size-4"

    refute_includes class_tokens, "h-8"
    refute_includes class_tokens, "w-8"
    refute_includes class_tokens, "focus-visible:outline-none"
    refute_includes class_tokens, "focus-visible:ring-2"
    refute_includes class_tokens, "focus-visible:ring-offset-2"
    refute_includes class_tokens, "border-input"
    refute_includes button.native.to_html, 'class="h-4 w-4"'
  end

  def test_vertical_navigation_uses_new_york_v4_position_tokens
    render_inline(Shadcn::CarouselComponent.new(orientation: :vertical)) do |carousel|
      carousel.with_previous
      carousel.with_next
    end

    previous_classes = page.find("button[data-slot='carousel-previous']")[:class]
    next_classes = page.find("button[data-slot='carousel-next']")[:class]

    assert_includes previous_classes, "-top-12"
    assert_includes previous_classes, "left-1/2"
    assert_includes previous_classes, "-translate-x-1/2"
    assert_includes previous_classes, "rotate-90"
    assert_includes next_classes, "-bottom-12"
    assert_includes next_classes, "left-1/2"
    assert_includes next_classes, "-translate-x-1/2"
    assert_includes next_classes, "rotate-90"
  end

  # Default icons
  def test_previous_button_renders_default_icon
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_previous
    end

    assert_selector "button svg"
  end

  def test_next_button_renders_default_icon
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_next
    end

    assert_selector "button svg"
  end

  # Custom class
  def test_renders_with_custom_class
    render_inline(Shadcn::CarouselComponent.new(class_name: "my-carousel"))

    assert_selector "div.my-carousel"
  end

  # Complete carousel
  def test_renders_complete_carousel
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_slides do |slides|
        slides.with_item { "Slide 1" }
        slides.with_item { "Slide 2" }
      end
      carousel.with_previous { "Prev" }
      carousel.with_next { "Next" }
    end

    assert_selector "[data-controller='shadcn--carousel']"
    assert_selector "[data-shadcn--carousel-target='item']", count: 2
    assert_selector "[data-shadcn--carousel-target='prevButton']"
    assert_selector "[data-shadcn--carousel-target='nextButton']"
  end
end
