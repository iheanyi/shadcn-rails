# frozen_string_literal: true

# @label Alert Dialog
# @display bg_color "#ffffff"
class AlertDialogComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic alert dialog - click button to open
  def default
    render(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_trigger do
        button_html(:outline, "Show Dialog")
      end
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Are you absolutely sure?" }
          header.with_description { "This action cannot be undone. This will permanently delete your account and remove your data from our servers." }
        end
        body.with_footer do |footer|
          footer.with_cancel { "Cancel" }
          footer.with_action { "Continue" }
        end
      end
    end
  end

  # @label Destructive
  # Alert dialog for destructive actions
  def destructive
    render(Shadcn::AlertDialogComponent.new) do |dialog|
      dialog.with_trigger do
        button_html(:destructive, "Delete Account")
      end
      dialog.with_body do |body|
        body.with_header do |header|
          header.with_title { "Delete Account" }
          header.with_description { "Are you sure you want to delete your account? All of your data will be permanently removed. This action cannot be undone." }
        end
        body.with_footer do |footer|
          footer.with_cancel { "Cancel" }
          footer.with_action(variant: :destructive) { "Yes, delete account" }
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
    else
      "bg-primary text-primary-foreground hover:bg-primary/90"
    end

    classes = [base_classes, variant_classes, extra_class].compact.join(" ")
    %(<button type="button" class="#{classes}">#{text}</button>).html_safe
  end
end
