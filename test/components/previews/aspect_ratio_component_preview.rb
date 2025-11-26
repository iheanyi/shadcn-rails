# frozen_string_literal: true

# @label Aspect Ratio
# @display bg_color "#ffffff"
class AspectRatioComponentPreview < ViewComponent::Preview
  # @label Default (16:9)
  # Image with 16:9 aspect ratio
  def default
    render(Shadcn::AspectRatioComponent.new(ratio: "16/9", class: "bg-muted")) do
      <<~HTML.html_safe
        <img
          src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80"
          alt="Photo by Drew Beamer"
          class="rounded-md object-cover w-full h-full"
        />
      HTML
    end
  end

  # @label Square (1:1)
  # Image with 1:1 aspect ratio
  def square
    render(Shadcn::AspectRatioComponent.new(ratio: "1/1", class: "bg-muted w-[300px]")) do
      <<~HTML.html_safe
        <img
          src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80"
          alt="Photo by Drew Beamer"
          class="rounded-md object-cover w-full h-full"
        />
      HTML
    end
  end

  # @label Portrait (3:4)
  # Image with 3:4 portrait aspect ratio
  def portrait
    render(Shadcn::AspectRatioComponent.new(ratio: "3/4", class: "bg-muted w-[300px]")) do
      <<~HTML.html_safe
        <img
          src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80"
          alt="Photo by Drew Beamer"
          class="rounded-md object-cover w-full h-full"
        />
      HTML
    end
  end

  # @label Video Embed
  # Video with 16:9 aspect ratio
  def video
    render(Shadcn::AspectRatioComponent.new(ratio: "16/9", class: "bg-muted")) do
      <<~HTML.html_safe
        <iframe
          src="https://www.youtube.com/embed/dQw4w9WgXcQ"
          title="YouTube video player"
          frameborder="0"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
          class="w-full h-full rounded-md"
        ></iframe>
      HTML
    end
  end
end
