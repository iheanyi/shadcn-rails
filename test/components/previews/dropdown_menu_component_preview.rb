# frozen_string_literal: true

# @label Dropdown Menu
# @display bg_color "#ffffff"
class DropdownMenuComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic dropdown menu with trigger button - click to open
  def default
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        button_html(:outline, "Open Menu")
      end
      menu.with_menu do |content|
        content.with_label { "My Account" }
        content.with_separator
        content.with_item(href: "#profile") { "Profile" }
        content.with_item(href: "#settings") { "Settings" }
        content.with_separator
        content.with_item { "Log out" }
      end
    end
  end

  # @label With Shortcuts
  # Dropdown menu with keyboard shortcuts displayed
  def with_shortcuts
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        button_html(:outline, "Actions")
      end
      menu.with_menu do |content|
        content.with_label { "Actions" }
        content.with_separator
        content.with_item(href: "#new") do |item|
          item.with_shortcut { "⌘N" }
          "New File"
        end
        content.with_item(href: "#open") do |item|
          item.with_shortcut { "⌘O" }
          "Open File"
        end
        content.with_item(href: "#save") do |item|
          item.with_shortcut { "⌘S" }
          "Save"
        end
      end
    end
  end

  # @label Destructive Actions
  # Dropdown menu with destructive variant items
  def destructive
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        button_html(:outline, "More Options")
      end
      menu.with_menu do |content|
        content.with_item(href: "#edit") { "Edit" }
        content.with_item(href: "#duplicate") { "Duplicate" }
        content.with_separator
        content.with_item(variant: :destructive, href: "#delete") { "Delete" }
        content.with_item(variant: :destructive, href: "#archive") { "Archive" }
      end
    end
  end

  # @label With Icons
  # Dropdown menu items with icons
  def with_icons
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        button_html(:outline, "File Menu")
      end
      menu.with_menu do |content|
        content.with_label { "File" }
        content.with_separator
        content.with_item(href: "#") do
          %(
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M5 12h14"/><path d="M12 5v14"/>
            </svg>
            <span>New File</span>
          ).html_safe
        end
        content.with_item(href: "#") do
          %(
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
            </svg>
            <span>Open File</span>
          ).html_safe
        end
        content.with_item(href: "#") do
          %(
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/>
            </svg>
            <span>Save</span>
          ).html_safe
        end
      end
    end
  end

  # @label Disabled Items
  # Dropdown menu with disabled items
  def disabled_items
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        button_html(:outline, "Options")
      end
      menu.with_menu do |content|
        content.with_item(href: "#copy") { "Copy" }
        content.with_item(href: "#cut") { "Cut" }
        content.with_item(href: "#paste", disabled: true) { "Paste (disabled)" }
        content.with_separator
        content.with_item(href: "#undo", disabled: true) { "Undo (disabled)" }
        content.with_item(href: "#redo") { "Redo" }
      end
    end
  end

  # @label With Inset
  # Dropdown menu with inset items for icon alignment
  def with_inset
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        button_html(:outline, "View Options")
      end
      menu.with_menu do |content|
        content.with_label(inset: true) { "View" }
        content.with_separator
        content.with_item(inset: true, href: "#") { "Show Sidebar" }
        content.with_item(inset: true, href: "#") { "Show Toolbar" }
        content.with_item(inset: true, href: "#") { "Show Status Bar" }
      end
    end
  end

  # @label Alignment Options
  # Dropdown menu with different alignment options
  # @param align select { choices: [start, center, end] }
  # @param side select { choices: [top, right, bottom, left] }
  def alignment(align: :end, side: :bottom)
    render(Shadcn::DropdownMenuComponent.new(align: align.to_sym, side: side.to_sym)) do |menu|
      menu.with_trigger do
        button_html(:outline, "Aligned Menu")
      end
      menu.with_menu do |content|
        content.with_label { "Alignment: #{align} / #{side}" }
        content.with_separator
        content.with_item(href: "#") { "Item 1" }
        content.with_item(href: "#") { "Item 2" }
        content.with_item(href: "#") { "Item 3" }
      end
    end
  end

  # @label User Menu Example
  # Real-world example of a user account menu
  def user_menu
    render(Shadcn::DropdownMenuComponent.new) do |menu|
      menu.with_trigger do
        %(
          <button type="button" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 w-10">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
              <circle cx="12" cy="7" r="4"/>
            </svg>
          </button>
        ).html_safe
      end
      menu.with_menu do |content|
        content.with_label { "My Account" }
        content.with_separator
        content.with_item(href: "#profile") do |item|
          item.with_shortcut { "⇧⌘P" }
          "Profile"
        end
        content.with_item(href: "#billing") { "Billing" }
        content.with_item(href: "#settings") do |item|
          item.with_shortcut { "⌘S" }
          "Settings"
        end
        content.with_separator
        content.with_item(href: "#team") { "Team" }
        content.with_item(href: "#invite") { "Invite users" }
        content.with_separator
        content.with_item(variant: :destructive, href: "#logout") { "Log out" }
      end
    end
  end

  private

  def button_html(variant, text, extra_class = nil)
    base_classes = "inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2"

    variant_classes = case variant
    when :default
      "bg-primary text-primary-foreground hover:bg-primary/90"
    when :destructive
      "bg-destructive text-destructive-foreground hover:bg-destructive/90"
    when :outline
      "border border-input bg-background hover:bg-accent hover:text-accent-foreground"
    when :secondary
      "bg-secondary text-secondary-foreground hover:bg-secondary/80"
    when :ghost
      "hover:bg-accent hover:text-accent-foreground"
    when :link
      "text-primary underline-offset-4 hover:underline"
    else
      "bg-primary text-primary-foreground hover:bg-primary/90"
    end

    classes = [base_classes, variant_classes, extra_class].compact.join(" ")
    %(<button type="button" class="#{classes}">#{text}</button>).html_safe
  end
end
