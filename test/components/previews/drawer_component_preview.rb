# frozen_string_literal: true

# @label Drawer
# @display bg_color "#ffffff"
class DrawerComponentPreview < ViewComponent::Preview
  # @label Default (Bottom)
  # Basic drawer sliding from bottom
  def default
    render(Shadcn::DrawerComponent.new) do |drawer|
      drawer.with_trigger do
        button_html(:outline, "Open Drawer")
      end
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Edit profile" }
          header.with_description { "Make changes to your profile here. Click save when you're done." }
        end
        <<~HTML.html_safe
          <div class="p-4">
            <div class="grid gap-4">
              <div class="grid gap-2">
                <label for="name" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Name</label>
                <input type="text" id="name" value="John Doe" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
              </div>
              <div class="grid gap-2">
                <label for="email" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Email</label>
                <input type="email" id="email" value="john@example.com" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
              </div>
            </div>
          </div>
        HTML
        body.with_footer do
          <<~HTML.html_safe
            #{button_html(:outline, "Cancel", "mr-2")}
            #{button_html(:default, "Save changes")}
          HTML
        end
      end
    end
  end

  # @label Right Side
  # Drawer sliding from right side
  def right
    render(Shadcn::DrawerComponent.new(direction: :right)) do |drawer|
      drawer.with_trigger do
        button_html(:outline, "Open Right Drawer")
      end
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Shopping Cart" }
          header.with_description { "Review your items before checkout." }
        end
        <<~HTML.html_safe
          <div class="p-4 space-y-4">
            <div class="flex items-center gap-4">
              <div class="h-16 w-16 bg-muted rounded-md"></div>
              <div class="flex-1">
                <p class="font-medium">Product Name</p>
                <p class="text-sm text-muted-foreground">$29.99</p>
              </div>
            </div>
            <div class="flex items-center gap-4">
              <div class="h-16 w-16 bg-muted rounded-md"></div>
              <div class="flex-1">
                <p class="font-medium">Another Product</p>
                <p class="text-sm text-muted-foreground">$49.99</p>
              </div>
            </div>
          </div>
        HTML
        body.with_footer do
          <<~HTML.html_safe
            <div class="w-full">
              <div class="flex justify-between mb-4">
                <span class="font-medium">Total</span>
                <span class="font-medium">$79.98</span>
              </div>
              #{button_html(:default, "Checkout", "w-full")}
            </div>
          HTML
        end
      end
    end
  end

  # @label Left Side
  # Drawer sliding from left side
  def left
    render(Shadcn::DrawerComponent.new(direction: :left)) do |drawer|
      drawer.with_trigger do
        button_html(:outline, "Open Left Drawer")
      end
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Navigation" }
          header.with_description { "Browse application sections." }
        end
        <<~HTML.html_safe
          <nav class="p-4">
            <ul class="space-y-2">
              <li><a href="#" class="block px-4 py-2 text-sm rounded-md hover:bg-accent">Dashboard</a></li>
              <li><a href="#" class="block px-4 py-2 text-sm rounded-md hover:bg-accent">Products</a></li>
              <li><a href="#" class="block px-4 py-2 text-sm rounded-md hover:bg-accent">Orders</a></li>
              <li><a href="#" class="block px-4 py-2 text-sm rounded-md hover:bg-accent">Customers</a></li>
              <li><a href="#" class="block px-4 py-2 text-sm rounded-md hover:bg-accent">Settings</a></li>
            </ul>
          </nav>
        HTML
      end
    end
  end

  # @label Top
  # Drawer sliding from top
  def top
    render(Shadcn::DrawerComponent.new(direction: :top)) do |drawer|
      drawer.with_trigger do
        button_html(:outline, "Open Top Drawer")
      end
      drawer.with_body do |body|
        body.with_header do |header|
          header.with_title { "Notifications" }
          header.with_description { "You have 3 unread messages." }
        end
        <<~HTML.html_safe
          <div class="p-4 space-y-4">
            <div class="flex items-start gap-4 p-3 bg-accent rounded-md">
              <div class="h-8 w-8 bg-primary rounded-full flex items-center justify-center text-primary-foreground text-xs">JD</div>
              <div class="flex-1">
                <p class="text-sm font-medium">New comment</p>
                <p class="text-xs text-muted-foreground">John Doe commented on your post</p>
              </div>
            </div>
            <div class="flex items-start gap-4 p-3 bg-accent rounded-md">
              <div class="h-8 w-8 bg-primary rounded-full flex items-center justify-center text-primary-foreground text-xs">AB</div>
              <div class="flex-1">
                <p class="text-sm font-medium">New follower</p>
                <p class="text-xs text-muted-foreground">Alice Brown started following you</p>
              </div>
            </div>
          </div>
        HTML
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
    else
      "bg-primary text-primary-foreground hover:bg-primary/90"
    end

    classes = [base_classes, variant_classes, extra_class].compact.join(" ")
    %(<button type="button" class="#{classes}">#{text}</button>).html_safe
  end
end
