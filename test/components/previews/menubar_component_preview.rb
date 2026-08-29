# frozen_string_literal: true

# @label Menubar
# @display bg_color "#ffffff"
class MenubarComponentPreview < ViewComponent::Preview
  # @label Default
  # Desktop-style menubar with file and edit menus
  def default
    render(Shadcn::MenubarComponent.new) do |menubar|
      menubar.with_menu do |menu|
        menu.with_trigger { "File" }
        menu.with_menu do |content|
          content.with_item(href: "#new") { "New Tab" }
          content.with_item(href: "#window") { "New Window" }
          content.with_separator
          content.with_item(href: "#close") { "Close" }
        end
      end
      menubar.with_menu do |menu|
        menu.with_trigger { "Edit" }
        menu.with_menu do |content|
          content.with_item(href: "#undo") { "Undo" }
          content.with_item(href: "#redo") { "Redo" }
        end
      end
    end
  end
end
