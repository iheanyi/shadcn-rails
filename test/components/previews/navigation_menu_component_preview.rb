# frozen_string_literal: true

# @label Navigation Menu
# @display bg_color "#ffffff"
class NavigationMenuComponentPreview < ViewComponent::Preview
  # @label Default
  # Navigation menu with a dropdown and direct link
  def default
    render(Shadcn::NavigationMenuComponent.new) do |navigation|
      navigation.with_list do |list|
        list.with_item do |item|
          item.with_trigger { "Getting Started" }
          item.with_dropdown do
            <<~HTML.html_safe
              <ul class="grid w-[320px] gap-3 p-4">
                <li><a href="#introduction" class="block rounded-md p-3 hover:bg-accent">Introduction</a></li>
                <li><a href="#installation" class="block rounded-md p-3 hover:bg-accent">Installation</a></li>
              </ul>
            HTML
          end
        end
        list.with_item do |item|
          item.with_link(href: "/docs") { "Documentation" }
        end
      end
    end
  end
end
