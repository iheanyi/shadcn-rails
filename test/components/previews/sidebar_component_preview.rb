# frozen_string_literal: true

# @label Sidebar
# @display bg_color "#ffffff"
class SidebarComponentPreview < ViewComponent::Preview
  # @label Default
  # Sidebar with header, menu group, and footer
  def default
    render(Shadcn::SidebarComponent.new(collapsible: :icon, class_name: "relative block h-[320px]")) do |sidebar|
      sidebar.with_header do
        '<div class="px-4 py-2 text-sm font-semibold">Acme Inc.</div>'.html_safe
      end
      sidebar.with_sidebar_content do |content|
        content.with_group do |group|
          group.with_label { "Platform" }
          group.with_group_content do |group_content|
            group_content.with_menu do |menu|
              menu.with_item do |item|
                item.with_button(href: "#dashboard", is_active: true) { "Dashboard" }
              end
              menu.with_item do |item|
                item.with_button(href: "#settings") { "Settings" }
              end
            end
          end
        end
      end
      sidebar.with_footer do
        '<div class="px-4 py-2 text-xs text-muted-foreground">Signed in as demo@example.com</div>'.html_safe
      end
    end
  end
end
