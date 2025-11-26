# frozen_string_literal: true

# @label Tabs
# @display bg_color "#ffffff"
class TabsComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic tabs with two panels
  def default
    render(Shadcn::TabsComponent.new(default_value: "account", class_name: "w-[400px]")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "account") { "Account" }
        list.with_trigger(value: "password") { "Password" }
      end
      tabs.with_panel(value: "account") do
        <<~HTML.html_safe
          <div class="space-y-2">
            <h3 class="text-lg font-medium">Account</h3>
            <p class="text-sm text-muted-foreground">Make changes to your account here. Click save when you're done.</p>
            <div class="space-y-4 pt-4">
              <div class="space-y-2">
                <label for="name" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Name</label>
                <input type="text" id="name" value="Pedro Duarte" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
              </div>
              <div class="space-y-2">
                <label for="username" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Username</label>
                <input type="text" id="username" value="@peduarte" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
              </div>
            </div>
          </div>
        HTML
      end
      tabs.with_panel(value: "password") do
        <<~HTML.html_safe
          <div class="space-y-2">
            <h3 class="text-lg font-medium">Password</h3>
            <p class="text-sm text-muted-foreground">Change your password here. After saving, you'll be logged out.</p>
            <div class="space-y-4 pt-4">
              <div class="space-y-2">
                <label for="current" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Current password</label>
                <input type="password" id="current" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
              </div>
              <div class="space-y-2">
                <label for="new" class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">New password</label>
                <input type="password" id="new" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
              </div>
            </div>
          </div>
        HTML
      end
    end
  end

  # @label With Cards
  # Tabs with card content - simplified version
  def with_cards
    render(Shadcn::TabsComponent.new(default_value: "account", class_name: "w-[400px]")) do |tabs|
      tabs.with_list do |list|
        list.with_trigger(value: "account") { "Account" }
        list.with_trigger(value: "password") { "Password" }
      end
      tabs.with_panel(value: "account") do
        <<~HTML.html_safe
          <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="flex flex-col space-y-1.5 p-6">
              <h3 class="text-2xl font-semibold leading-none tracking-tight">Account</h3>
              <p class="text-sm text-muted-foreground">Make changes to your account here.</p>
            </div>
            <div class="p-6 pt-0">
              <div class="space-y-2">
                <label for="name2" class="text-sm font-medium leading-none">Name</label>
                <input type="text" id="name2" value="Pedro Duarte" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm">
              </div>
            </div>
            <div class="flex items-center p-6 pt-0">
              <button class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">Save changes</button>
            </div>
          </div>
        HTML
      end
      tabs.with_panel(value: "password") do
        <<~HTML.html_safe
          <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="flex flex-col space-y-1.5 p-6">
              <h3 class="text-2xl font-semibold leading-none tracking-tight">Password</h3>
              <p class="text-sm text-muted-foreground">Change your password here.</p>
            </div>
            <div class="p-6 pt-0">
              <div class="space-y-4">
                <div class="space-y-2">
                  <label for="current2" class="text-sm font-medium leading-none">Current password</label>
                  <input type="password" id="current2" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm">
                </div>
                <div class="space-y-2">
                  <label for="new2" class="text-sm font-medium leading-none">New password</label>
                  <input type="password" id="new2" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm">
                </div>
              </div>
            </div>
            <div class="flex items-center p-6 pt-0">
              <button class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">Save password</button>
            </div>
          </div>
        HTML
      end
    end
  end
end
