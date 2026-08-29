# frozen_string_literal: true

# @label Radio Group
# @display bg_color "#ffffff"
class RadioGroupComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic radio group with vertical layout
  def default
    render(Shadcn::RadioGroupComponent.new(name: "plan", value: "pro", items: plan_items))
  end

  # @label Horizontal Layout
  # Radio group with horizontal orientation
  def horizontal
    render(Shadcn::RadioGroupComponent.new(name: "size", value: "medium", orientation: :horizontal, items: size_items))
  end

  # @label With Descriptions
  # Radio group with detailed descriptions for each option
  def with_descriptions
    render(Shadcn::RadioGroupComponent.new(name: "notification", value: "all", items: notification_items))
  end

  # @label Disabled State
  # Radio group with disabled option
  def disabled
    render(Shadcn::RadioGroupComponent.new(name: "subscription", value: "basic", items: subscription_items))
  end

  # @label Card Layout
  # Radio group styled as selectable cards
  def card_layout
    render(Shadcn::RadioGroupComponent.new(name: "pricing", value: "hobby", class_name: "gap-4", items: pricing_items))
  end

  # @label Required Field
  # Radio group marked as required
  def required
    render(Shadcn::RadioGroupComponent.new(name: "accept", required: true, items: accept_items))
  end

  # @label Color Picker
  # Radio group for selecting colors
  def color_picker
    render(Shadcn::RadioGroupComponent.new(name: "color", value: "blue", orientation: :horizontal, items: color_items))
  end

  # @label Form Example
  # Radio group in a realistic form context
  def form_example
    render(Shadcn::RadioGroupComponent.new(name: "delivery", value: "standard", class_name: "mt-4", items: delivery_items))
  end

  private

  def plan_items
    [
      { value: "free", label: "Free" },
      { value: "pro", label: "Pro" },
      { value: "enterprise", label: "Enterprise" }
    ]
  end

  def size_items
    [
      { value: "small", label: "Small" },
      { value: "medium", label: "Medium" },
      { value: "large", label: "Large" }
    ]
  end

  def notification_items
    [
      { value: "all", label: "All notifications" },
      { value: "mentions", label: "Mentions only" },
      { value: "none", label: "No notifications" }
    ]
  end

  def subscription_items
    [
      { value: "basic", label: "Basic" },
      { value: "premium", label: "Premium" },
      { value: "ultimate", label: "Ultimate (Coming Soon)", disabled: true }
    ]
  end

  def pricing_items
    [
      { value: "hobby", label: "Hobby - $0/month" },
      { value: "pro", label: "Pro - $29/month" },
      { value: "team", label: "Team - $99/month" }
    ]
  end

  def accept_items
    [
      { value: "yes", label: "I accept the terms and conditions" },
      { value: "no", label: "I do not accept" }
    ]
  end

  def color_items
    [
      { value: "red", label: "Red" },
      { value: "blue", label: "Blue" },
      { value: "green", label: "Green" },
      { value: "yellow", label: "Yellow" }
    ]
  end

  def delivery_items
    [
      { value: "standard", label: "Standard Shipping - $5.00" },
      { value: "express", label: "Express Shipping - $15.00" },
      { value: "overnight", label: "Overnight Shipping - $25.00" }
    ]
  end

end
