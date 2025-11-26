# frozen_string_literal: true

# @label Sheet
# @display bg_color "#ffffff"
class SheetComponentPreview < ViewComponent::Preview
  # @label Default (Right)
  # Basic sheet sliding from the right side - click to open
  def default
    render(Shadcn::SheetComponent.new(side: :right)) do |sheet|
      sheet.with_trigger do
        button_html(:outline, "Open Sheet")
      end
      sheet.with_body do |content|
        content.with_header do |header|
          header.with_title { "Edit Profile" }
          header.with_description { "Make changes to your profile here. Click save when you're done." }
        end
        <<~HTML.html_safe
          <div class="py-4">
            <div class="grid gap-4">
              <div class="grid grid-cols-4 items-center gap-4">
                <label for="name" class="text-right text-sm font-medium leading-none">Name</label>
                <input type="text" id="name" value="John Doe" class="col-span-3 flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
              </div>
              <div class="grid grid-cols-4 items-center gap-4">
                <label for="username" class="text-right text-sm font-medium leading-none">Username</label>
                <input type="text" id="username" value="@johndoe" class="col-span-3 flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
              </div>
            </div>
          </div>
        HTML
        content.with_footer do
          button_html(:default, "Save changes")
        end
      end
    end
  end

  # @label Left Side
  # Sheet sliding from the left side
  def left_side
    render(Shadcn::SheetComponent.new(side: :left)) do |sheet|
      sheet.with_trigger do
        button_html(:outline, "Open Left Sheet")
      end
      sheet.with_body do |content|
        content.with_header do |header|
          header.with_title { "Navigation" }
          header.with_description { "Quick access to navigation items." }
        end
        <<~HTML.html_safe
          <nav class="py-4">
            <ul class="space-y-2">
              <li><a href="#" class="block px-2 py-1.5 text-sm hover:bg-accent rounded-md">Dashboard</a></li>
              <li><a href="#" class="block px-2 py-1.5 text-sm hover:bg-accent rounded-md">Projects</a></li>
              <li><a href="#" class="block px-2 py-1.5 text-sm hover:bg-accent rounded-md">Team</a></li>
              <li><a href="#" class="block px-2 py-1.5 text-sm hover:bg-accent rounded-md">Settings</a></li>
            </ul>
          </nav>
        HTML
      end
    end
  end

  # @label Top Side
  # Sheet sliding from the top
  def top_side
    render(Shadcn::SheetComponent.new(side: :top)) do |sheet|
      sheet.with_trigger do
        button_html(:outline, "Open Top Sheet")
      end
      sheet.with_body do |content|
        content.with_header do |header|
          header.with_title { "Notification Center" }
          header.with_description { "You have 3 unread notifications." }
        end
        <<~HTML.html_safe
          <div class="py-4 space-y-4">
            <div class="flex items-start gap-4 p-3 rounded-md hover:bg-accent">
              <div class="h-2 w-2 translate-y-1.5 rounded-full bg-blue-500"></div>
              <div class="flex-1 space-y-1">
                <p class="text-sm font-medium">New message received</p>
                <p class="text-sm text-muted-foreground">5 minutes ago</p>
              </div>
            </div>
            <div class="flex items-start gap-4 p-3 rounded-md hover:bg-accent">
              <div class="h-2 w-2 translate-y-1.5 rounded-full bg-green-500"></div>
              <div class="flex-1 space-y-1">
                <p class="text-sm font-medium">Your profile was updated</p>
                <p class="text-sm text-muted-foreground">1 hour ago</p>
              </div>
            </div>
          </div>
        HTML
        content.with_footer do
          button_html(:outline, "Mark all as read")
        end
      end
    end
  end

  # @label Bottom Side
  # Sheet sliding from the bottom
  def bottom_side
    render(Shadcn::SheetComponent.new(side: :bottom)) do |sheet|
      sheet.with_trigger do
        button_html(:outline, "Open Bottom Sheet")
      end
      sheet.with_body do |content|
        content.with_header do |header|
          header.with_title { "Share this page" }
          header.with_description { "Anyone with the link can view this page." }
        end
        <<~HTML.html_safe
          <div class="py-4">
            <div class="flex items-center space-x-2">
              <input type="text" value="https://example.com/share/12345" readonly class="flex h-10 w-full rounded-md border border-input bg-muted px-3 py-2 text-sm">
              #{button_html(:default, "Copy")}
            </div>
          </div>
        HTML
      end
    end
  end

  # @label Simple Content
  # Sheet with minimal content, no header or footer
  def simple
    render(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_trigger do
        button_html(:outline, "Open Simple Sheet")
      end
      sheet.with_body do |content|
        <<~HTML.html_safe
          <div class="py-4">
            <p class="text-sm">This is a simple sheet with just content. No header or footer needed for quick actions.</p>
          </div>
        HTML
      end
    end
  end

  # @label With Long Form
  # Sheet containing a longer form with multiple fields
  def with_form
    render(Shadcn::SheetComponent.new) do |sheet|
      sheet.with_trigger do
        button_html(:outline, "Create Account")
      end
      sheet.with_body do |content|
        content.with_header do |header|
          header.with_title { "Create Account" }
          header.with_description { "Enter your information to create a new account." }
        end
        <<~HTML.html_safe
          <div class="py-4">
            <form class="space-y-4">
              <div class="space-y-2">
                <label class="text-sm font-medium leading-none">Full Name</label>
                <input type="text" placeholder="John Doe" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
              </div>
              <div class="space-y-2">
                <label class="text-sm font-medium leading-none">Email</label>
                <input type="email" placeholder="john@example.com" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
              </div>
              <div class="space-y-2">
                <label class="text-sm font-medium leading-none">Password</label>
                <input type="password" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
              </div>
              <div class="space-y-2">
                <label class="text-sm font-medium leading-none">Role</label>
                <select class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
                  <option>User</option>
                  <option>Admin</option>
                  <option>Manager</option>
                </select>
              </div>
            </form>
          </div>
        HTML
        content.with_footer do
          <<~HTML.html_safe
            #{button_html(:outline, "Cancel", "mr-2")}
            #{button_html(:default, "Create Account")}
          HTML
        end
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
