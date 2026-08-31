# frozen_string_literal: true

# @label Card
# @display bg_color "#f4f4f5"
class CardComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic card with all sections
  def default
    render(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Card Title" }
        header.with_description { "Card description goes here" }
      end
      card.with_content_slot do
        "This is the main content of the card. You can put any content here."
      end
      card.with_footer do
        '<button class="inline-flex items-center justify-center rounded-md text-sm font-medium bg-primary text-primary-foreground h-9 px-4 py-2">Action</button>'.html_safe
      end
    end
  end

  # @label Simple
  # Simple card with just content
  def simple
    render(Shadcn::CardComponent.new) do |card|
      card.with_content_slot do
        "A simple card with just content, no header or footer."
      end
    end
  end

  # @label Image Header
  # Card with an image header
  def image_header
    render(Shadcn::CardComponent.new(class_name: "overflow-hidden")) do |card|
      card.with_content_slot do
        '<img src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80" alt="Photo" class="w-full aspect-video object-cover -mt-6 -mx-6 mb-4 rounded-t-xl" />
        <h3 class="font-semibold">Beautiful Landscape</h3>
        <p class="text-sm text-muted-foreground mt-2">A stunning view captured in the mountains during golden hour.</p>'.html_safe
      end
    end
  end

  # @label Notification
  # Card styled as a notification
  def notification
    render(Shadcn::CardComponent.new) do |card|
      card.with_header do |header|
        header.with_title { "Notifications" }
        header.with_description { "You have 3 unread messages." }
      end
      card.with_content_slot do
        '<div class="space-y-4">
          <div class="flex items-start gap-4">
            <span class="flex h-2 w-2 translate-y-1.5 rounded-full bg-blue-500" />
            <div class="space-y-1">
              <p class="text-sm font-medium leading-none">Your call has been confirmed.</p>
              <p class="text-sm text-muted-foreground">1 hour ago</p>
            </div>
          </div>
          <div class="flex items-start gap-4">
            <span class="flex h-2 w-2 translate-y-1.5 rounded-full bg-blue-500" />
            <div class="space-y-1">
              <p class="text-sm font-medium leading-none">You have a new message!</p>
              <p class="text-sm text-muted-foreground">2 hours ago</p>
            </div>
          </div>
        </div>'.html_safe
      end
      card.with_footer do
        '<button class="inline-flex items-center justify-center rounded-md text-sm font-medium bg-primary text-primary-foreground h-9 px-4 py-2 w-full">Mark all as read</button>'.html_safe
      end
    end
  end

  # @label Form
  # Card containing a form
  def form
    render(Shadcn::CardComponent.new(class_name: "w-[350px]")) do |card|
      card.with_header do |header|
        header.with_title { "Create project" }
        header.with_description { "Deploy your new project in one-click." }
      end
      card.with_content_slot do
        '<form>
          <div class="grid w-full items-center gap-4">
            <div class="flex flex-col space-y-1.5">
              <label class="text-sm font-medium leading-none" for="name">Name</label>
              <input class="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm" id="name" placeholder="Name of your project" />
            </div>
            <div class="flex flex-col space-y-1.5">
              <label class="text-sm font-medium leading-none" for="framework">Framework</label>
              <select class="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm">
                <option>Select</option>
                <option value="next">Next.js</option>
                <option value="rails">Rails</option>
                <option value="remix">Remix</option>
              </select>
            </div>
          </div>
        </form>'.html_safe
      end
      card.with_footer do
        '<div class="flex justify-between w-full">
          <button class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-input bg-background h-9 px-4 py-2">Cancel</button>
          <button class="inline-flex items-center justify-center rounded-md text-sm font-medium bg-primary text-primary-foreground h-9 px-4 py-2">Deploy</button>
        </div>'.html_safe
      end
    end
  end
end
