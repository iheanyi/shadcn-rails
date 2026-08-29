# frozen_string_literal: true

# @label Context Menu
# @display bg_color "#ffffff"
class ContextMenuComponentPreview < ViewComponent::Preview
  # @label Default
  # Right-click the target to open the menu
  def default
    render(Shadcn::ContextMenuComponent.new) do |menu|
      menu.with_trigger do
        '<div class="flex h-32 w-64 items-center justify-center rounded-md border border-dashed text-sm">Right click here</div>'.html_safe
      end
      menu.with_menu do |content|
        content.with_item(href: "#back") { "Back" }
        content.with_item(href: "#forward", disabled: true) { "Forward" }
        content.with_item(href: "#reload") { "Reload" }
        content.with_separator
        content.with_item(href: "#print") { "Print" }
      end
    end
  end
end
