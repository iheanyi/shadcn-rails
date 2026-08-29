# frozen_string_literal: true

# @label Item
# @display bg_color "#ffffff"
class ItemComponentPreview < ViewComponent::Preview
  # @label Default
  # Item with media, content, and an action
  def default
    render(Shadcn::ItemComponent.new(variant: :outline, class_name: "w-[360px]")) do |item|
      item.with_media(variant: :icon) do
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16v16H4z"></path><path d="M8 8h8"></path><path d="M8 12h8"></path><path d="M8 16h4"></path></svg>'.html_safe
      end
      item.with_content do |content|
        content.with_title { "Project brief" }
        content.with_description { "Updated just now" }
      end
      item.with_actions do
        '<button type="button" class="inline-flex h-8 items-center justify-center rounded-md border border-input bg-background px-3 text-xs font-medium shadow-xs hover:bg-accent hover:text-accent-foreground">Open</button>'.html_safe
      end
    end
  end
end
