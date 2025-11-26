# frozen_string_literal: true

# @label Hover Card
# @display bg_color "#ffffff"
class HoverCardComponentPreview < ViewComponent::Preview
  # @label Default
  # Hover over the link to see the card
  def default
    render(Shadcn::HoverCardComponent.new) do |card|
      card.with_trigger do
        <<~HTML.html_safe
          <a href="#" class="text-sm font-medium underline underline-offset-4">@nextjs</a>
        HTML
      end
      card.with_card_content do
        <<~HTML.html_safe
          <div class="flex justify-between space-x-4">
            <div class="flex-shrink-0">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-sm font-medium">N</span>
            </div>
            <div class="space-y-1">
              <h4 class="text-sm font-semibold">@nextjs</h4>
              <p class="text-sm text-muted-foreground">
                The React Framework - created and maintained by @vercel.
              </p>
              <div class="flex items-center pt-2">
                <span class="text-xs text-muted-foreground">
                  Joined December 2021
                </span>
              </div>
            </div>
          </div>
        HTML
      end
    end
  end

  # @label Top Position
  # Hover card appearing on top
  def top
    render_in_wrapper do
      render(Shadcn::HoverCardComponent.new) do |card|
        card.with_trigger do
          <<~HTML.html_safe
            <a href="#" class="text-sm font-medium underline underline-offset-4">Hover me (top)</a>
          HTML
        end
        card.with_card_content(side: :top) do
          <<~HTML.html_safe
            <div class="space-y-1">
              <h4 class="text-sm font-semibold">Card on top</h4>
              <p class="text-sm text-muted-foreground">
                This card appears above the trigger.
              </p>
            </div>
          HTML
        end
      end
    end
  end

  # @label Custom Delay
  # Hover card with custom open/close delays
  def custom_delay
    render(Shadcn::HoverCardComponent.new(open_delay: 200, close_delay: 100)) do |card|
      card.with_trigger do
        <<~HTML.html_safe
          <a href="#" class="text-sm font-medium underline underline-offset-4">Quick hover</a>
        HTML
      end
      card.with_card_content do
        <<~HTML.html_safe
          <div class="space-y-1">
            <h4 class="text-sm font-semibold">Quick response</h4>
            <p class="text-sm text-muted-foreground">
              This card opens faster (200ms) and closes faster (100ms).
            </p>
          </div>
        HTML
      end
    end
  end

  # @label With Avatar
  # Hover card showing user profile
  def with_avatar
    render(Shadcn::HoverCardComponent.new) do |card|
      card.with_trigger do
        <<~HTML.html_safe
          <span class="inline-flex h-10 w-10 items-center justify-center rounded-full bg-muted cursor-pointer">
            <span class="text-sm font-medium leading-none">JD</span>
          </span>
        HTML
      end
      card.with_card_content do
        <<~HTML.html_safe
          <div class="space-y-2">
            <div class="flex items-center space-x-2">
              <span class="inline-flex h-8 w-8 items-center justify-center rounded-full bg-primary text-primary-foreground">
                <span class="text-xs font-medium leading-none">JD</span>
              </span>
              <div>
                <h4 class="text-sm font-semibold">John Doe</h4>
                <p class="text-xs text-muted-foreground">Software Engineer</p>
              </div>
            </div>
            <p class="text-sm text-muted-foreground">
              Building great user interfaces with React and Rails.
            </p>
            <div class="flex gap-4 text-xs text-muted-foreground">
              <span><strong class="text-foreground">1.2k</strong> followers</span>
              <span><strong class="text-foreground">500</strong> following</span>
            </div>
          </div>
        HTML
      end
    end
  end

  private

  def render_in_wrapper(&block)
    content = capture(&block)
    %(<div class="pt-20">#{content}</div>).html_safe
  end
end
