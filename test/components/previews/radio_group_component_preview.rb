# frozen_string_literal: true

# @label Radio Group
# @display bg_color "#ffffff"
class RadioGroupComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic radio group with vertical layout
  def default
    render(Shadcn::RadioGroupComponent.new(name: "plan", value: "pro")) do |group|
      %(
        <div class="flex items-center space-x-2">
          #{group.item(value: "free", id: "free")}
          #{label_html("free", "Free")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "pro", id: "pro")}
          #{label_html("pro", "Pro")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "enterprise", id: "enterprise")}
          #{label_html("enterprise", "Enterprise")}
        </div>
      ).html_safe
    end
  end

  # @label Horizontal Layout
  # Radio group with horizontal orientation
  def horizontal
    render(Shadcn::RadioGroupComponent.new(name: "size", value: "medium", orientation: :horizontal)) do |group|
      %(
        <div class="flex items-center space-x-2">
          #{group.item(value: "small", id: "size-small")}
          #{label_html("size-small", "Small")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "medium", id: "size-medium")}
          #{label_html("size-medium", "Medium")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "large", id: "size-large")}
          #{label_html("size-large", "Large")}
        </div>
      ).html_safe
    end
  end

  # @label With Descriptions
  # Radio group with detailed descriptions for each option
  def with_descriptions
    render(Shadcn::RadioGroupComponent.new(name: "notification", value: "all")) do |group|
      %(
        <div class="flex items-start space-x-2 py-2">
          <div class="pt-0.5">
            #{group.item(value: "all", id: "notify-all")}
          </div>
          <div class="flex-1">
            #{label_html("notify-all", "All notifications", "cursor-pointer")}
            <p class="text-sm text-muted-foreground">Receive notifications for all activity</p>
          </div>
        </div>
        <div class="flex items-start space-x-2 py-2">
          <div class="pt-0.5">
            #{group.item(value: "mentions", id: "notify-mentions")}
          </div>
          <div class="flex-1">
            #{label_html("notify-mentions", "Mentions only", "cursor-pointer")}
            <p class="text-sm text-muted-foreground">Only receive notifications when mentioned</p>
          </div>
        </div>
        <div class="flex items-start space-x-2 py-2">
          <div class="pt-0.5">
            #{group.item(value: "none", id: "notify-none")}
          </div>
          <div class="flex-1">
            #{label_html("notify-none", "No notifications", "cursor-pointer")}
            <p class="text-sm text-muted-foreground">Don't receive any notifications</p>
          </div>
        </div>
      ).html_safe
    end
  end

  # @label Disabled State
  # Radio group with disabled option
  def disabled
    render(Shadcn::RadioGroupComponent.new(name: "subscription", value: "basic")) do |group|
      %(
        <div class="flex items-center space-x-2">
          #{group.item(value: "basic", id: "sub-basic")}
          #{label_html("sub-basic", "Basic")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "premium", id: "sub-premium")}
          #{label_html("sub-premium", "Premium")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "ultimate", id: "sub-ultimate", disabled: true)}
          #{label_html("sub-ultimate", "Ultimate (Coming Soon)")}
        </div>
      ).html_safe
    end
  end

  # @label Card Layout
  # Radio group styled as selectable cards
  def card_layout
    render(Shadcn::RadioGroupComponent.new(name: "pricing", value: "hobby", class_name: "gap-4")) do |group|
      %(
        <div class="flex items-center space-x-3 rounded-md border border-input p-4 hover:bg-accent cursor-pointer">
          #{group.item(value: "hobby", id: "plan-hobby")}
          <div class="flex-1">
            #{label_html("plan-hobby", "Hobby", "cursor-pointer font-medium")}
            <p class="text-sm text-muted-foreground">Perfect for side projects</p>
            <p class="text-sm font-semibold mt-1">$0/month</p>
          </div>
        </div>
        <div class="flex items-center space-x-3 rounded-md border border-input p-4 hover:bg-accent cursor-pointer">
          #{group.item(value: "pro", id: "plan-pro")}
          <div class="flex-1">
            #{label_html("plan-pro", "Pro", "cursor-pointer font-medium")}
            <p class="text-sm text-muted-foreground">For professional developers</p>
            <p class="text-sm font-semibold mt-1">$29/month</p>
          </div>
        </div>
        <div class="flex items-center space-x-3 rounded-md border border-input p-4 hover:bg-accent cursor-pointer">
          #{group.item(value: "team", id: "plan-team")}
          <div class="flex-1">
            #{label_html("plan-team", "Team", "cursor-pointer font-medium")}
            <p class="text-sm text-muted-foreground">For collaborative teams</p>
            <p class="text-sm font-semibold mt-1">$99/month</p>
          </div>
        </div>
      ).html_safe
    end
  end

  # @label Required Field
  # Radio group marked as required
  def required
    render(Shadcn::RadioGroupComponent.new(name: "accept", required: true)) do |group|
      %(
        <div class="space-y-3">
          <div class="flex items-center space-x-2">
            #{group.item(value: "yes", id: "accept-yes")}
            #{label_html("accept-yes", "I accept the terms and conditions", "cursor-pointer", required: true)}
          </div>
          <div class="flex items-center space-x-2">
            #{group.item(value: "no", id: "accept-no")}
            #{label_html("accept-no", "I do not accept")}
          </div>
        </div>
      ).html_safe
    end
  end

  # @label Color Picker
  # Radio group for selecting colors
  def color_picker
    render(Shadcn::RadioGroupComponent.new(name: "color", value: "blue", orientation: :horizontal)) do |group|
      %(
        <div class="flex items-center space-x-2">
          #{group.item(value: "red", id: "color-red")}
          #{label_html("color-red", "Red", "cursor-pointer")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "blue", id: "color-blue")}
          #{label_html("color-blue", "Blue", "cursor-pointer")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "green", id: "color-green")}
          #{label_html("color-green", "Green", "cursor-pointer")}
        </div>
        <div class="flex items-center space-x-2">
          #{group.item(value: "yellow", id: "color-yellow")}
          #{label_html("color-yellow", "Yellow", "cursor-pointer")}
        </div>
      ).html_safe
    end
  end

  # @label Form Example
  # Radio group in a realistic form context
  def form_example
    %(
      <div class="w-full max-w-md space-y-6 rounded-lg border p-6">
        <div>
          <h3 class="text-lg font-medium">Delivery Method</h3>
          <p class="text-sm text-muted-foreground mt-1">Choose how you want to receive your order</p>
        </div>
        #{render(Shadcn::RadioGroupComponent.new(name: "delivery", value: "standard", class_name: "mt-4")) do |group|
          %(
            <div class="flex items-start space-x-3 rounded-md border border-input p-4">
              <div class="pt-0.5">
                #{group.item(value: "standard", id: "delivery-standard")}
              </div>
              <div class="flex-1">
                #{label_html("delivery-standard", "Standard Shipping", "cursor-pointer font-medium")}
                <p class="text-sm text-muted-foreground">5-7 business days</p>
                <p class="text-sm font-semibold mt-1">$5.00</p>
              </div>
            </div>
            <div class="flex items-start space-x-3 rounded-md border border-input p-4">
              <div class="pt-0.5">
                #{group.item(value: "express", id: "delivery-express")}
              </div>
              <div class="flex-1">
                #{label_html("delivery-express", "Express Shipping", "cursor-pointer font-medium")}
                <p class="text-sm text-muted-foreground">2-3 business days</p>
                <p class="text-sm font-semibold mt-1">$15.00</p>
              </div>
            </div>
            <div class="flex items-start space-x-3 rounded-md border border-input p-4">
              <div class="pt-0.5">
                #{group.item(value: "overnight", id: "delivery-overnight")}
              </div>
              <div class="flex-1">
                #{label_html("delivery-overnight", "Overnight Shipping", "cursor-pointer font-medium")}
                <p class="text-sm text-muted-foreground">Next business day</p>
                <p class="text-sm font-semibold mt-1">$25.00</p>
              </div>
            </div>
          ).html_safe
        end}
        <div class="flex justify-end">
          #{button_html(:default, "Continue to Payment")}
        </div>
      </div>
    ).html_safe
  end

  private

  def label_html(for_id, text, extra_class = nil, required: false)
    base_classes = "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
    classes = [base_classes, extra_class].compact.join(" ")
    required_indicator = required ? ' <span class="text-destructive" aria-hidden="true">*</span>' : ""
    %(<label for="#{for_id}" class="#{classes}">#{text}#{required_indicator}</label>).html_safe
  end

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
