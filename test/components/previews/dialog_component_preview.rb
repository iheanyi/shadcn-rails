# frozen_string_literal: true

# @label Dialog
# @display bg_color "#ffffff"
class DialogComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic dialog with trigger button - click to open
  def default
    render(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_trigger do
        button_html(:outline, "Open Dialog")
      end
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Dialog Title" }
          header.with_description { "This is a description of what this dialog does." }
        end
        <<~HTML.html_safe
          <div class="py-4">
            <p class="text-sm text-muted-foreground">Your dialog content goes here. You can put any content inside a dialog.</p>
          </div>
        HTML
        body.with_footer do
          <<~HTML.html_safe
            #{button_html(:outline, "Cancel", "mr-2")}
            #{button_html(:default, "Continue")}
          HTML
        end
      end
    end
  end

  # @label Alert Dialog
  # Dialog styled as an alert/confirmation - click to open
  def alert
    render(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_trigger do
        button_html(:destructive, "Delete Account")
      end
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Are you absolutely sure?" }
          header.with_description { "This action cannot be undone. This will permanently delete your account and remove your data from our servers." }
        end
        body.with_footer do
          <<~HTML.html_safe
            #{button_html(:outline, "Cancel", "mr-2")}
            #{button_html(:destructive, "Delete Account")}
          HTML
        end
      end
    end
  end

  # @label With Form
  # Dialog with a form inside
  def with_form
    render(Shadcn::DialogComponent.new) do |dialog|
      dialog.with_trigger do
        button_html(:outline, "Edit Profile")
      end
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Edit profile" }
          header.with_description { "Make changes to your profile here. Click save when you're done." }
        end
        <<~HTML.html_safe
          <div class="grid gap-4 py-4">
            <div class="grid grid-cols-4 items-center gap-4">
              <label for="name" class="text-right text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Name</label>
              <input type="text" id="name" value="Pedro Duarte" class="col-span-3 flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
            </div>
            <div class="grid grid-cols-4 items-center gap-4">
              <label for="username" class="text-right text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70">Username</label>
              <input type="text" id="username" value="@peduarte" class="col-span-3 flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
            </div>
          </div>
        HTML
        body.with_footer do
          button_html(:default, "Save changes")
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
