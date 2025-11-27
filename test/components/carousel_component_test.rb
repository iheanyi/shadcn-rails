# frozen_string_literal: true

require "test_helper"

class CarouselComponentTest < ViewComponent::TestCase
  # Basic rendering
  def test_renders_carousel_container
    render_inline(Shadcn::CarouselComponent.new)

    assert_selector "div[data-controller='shadcn--carousel']"
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
    assert_selector "[data-shadcn--carousel-target='content']"
    assert_selector "[data-shadcn--carousel-target='item']", count: 2
  end

  def test_slide_items_have_group_role
    render_inline(Shadcn::CarouselComponent.new) do |carousel|
      carousel.with_slides do |slides|
        slides.with_item { "Slide 1" }
      end
    end

    assert_selector "[role='group'][aria-roledescription='slide']"
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
