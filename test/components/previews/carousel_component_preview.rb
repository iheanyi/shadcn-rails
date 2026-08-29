# frozen_string_literal: true

# @label Carousel
# @display bg_color "#ffffff"
class CarouselComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic carousel with previous and next controls
  def default
    render(Shadcn::CarouselComponent.new(class_name: "w-[280px]")) do |carousel|
      carousel.with_slides do |slides|
        3.times do |index|
          slides.with_item do
            %(<div class="flex aspect-square items-center justify-center rounded-md border bg-muted text-4xl font-semibold">#{index + 1}</div>).html_safe
          end
        end
      end
      carousel.with_previous
      carousel.with_next
    end
  end
end
