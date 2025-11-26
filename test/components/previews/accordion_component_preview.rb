# frozen_string_literal: true

# @label Accordion
# @display bg_color "#ffffff"
class AccordionComponentPreview < ViewComponent::Preview
  # @label Default (Single)
  # Single accordion with collapsible items
  def default
    render(Shadcn::AccordionComponent.new(type: :single, collapsible: true)) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Is it accessible?" }
        item.with_body { "Yes. It adheres to the WAI-ARIA design pattern." }
      end
      accordion.with_item(value: "item-2") do |item|
        item.with_trigger { "Is it styled?" }
        item.with_body { "Yes. It comes with default styles that you can customize." }
      end
      accordion.with_item(value: "item-3") do |item|
        item.with_trigger { "Is it animated?" }
        item.with_body { "Yes. It's animated by default, but you can disable it if you prefer." }
      end
    end
  end

  # @label Single (Always One Open)
  # Single accordion without collapsible - always one item open
  def single_non_collapsible
    render(Shadcn::AccordionComponent.new(type: :single, collapsible: false, default_value: "item-1")) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Account" }
        item.with_body do
          content_tag(:div, class: "space-y-2") do
            content_tag(:p, "Manage your account settings and preferences.") +
            content_tag(:p, "You can update your profile, change password, and more.", class: "text-sm text-muted-foreground")
          end
        end
      end
      accordion.with_item(value: "item-2") do |item|
        item.with_trigger { "Security" }
        item.with_body do
          content_tag(:div, class: "space-y-2") do
            content_tag(:p, "Configure security settings for your account.") +
            content_tag(:p, "Enable two-factor authentication and manage devices.", class: "text-sm text-muted-foreground")
          end
        end
      end
      accordion.with_item(value: "item-3") do |item|
        item.with_trigger { "Notifications" }
        item.with_body do
          content_tag(:div, class: "space-y-2") do
            content_tag(:p, "Choose what notifications you want to receive.") +
            content_tag(:p, "You can customize email and push notification preferences.", class: "text-sm text-muted-foreground")
          end
        end
      end
    end
  end

  # @label Multiple Selection
  # Accordion that allows multiple items open at once
  def multiple
    render(Shadcn::AccordionComponent.new(type: :multiple)) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "Getting Started" }
        item.with_body { "Learn the basics of using our platform. This section covers initial setup and configuration." }
      end
      accordion.with_item(value: "item-2") do |item|
        item.with_trigger { "Advanced Features" }
        item.with_body { "Discover powerful features for advanced users. Includes API access, webhooks, and automation." }
      end
      accordion.with_item(value: "item-3") do |item|
        item.with_trigger { "Troubleshooting" }
        item.with_body { "Common issues and their solutions. Find answers to frequently asked questions." }
      end
    end
  end

  # @label With Default Value
  # Accordion with a pre-expanded item
  def with_default_value
    render(Shadcn::AccordionComponent.new(type: :single, collapsible: true, default_value: "item-2")) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "What is shadcn-rails?" }
        item.with_body { "shadcn-rails is a Ruby port of shadcn/ui for Rails applications using ViewComponent." }
      end
      accordion.with_item(value: "item-2") do |item|
        item.with_trigger { "How do I install it?" }
        item.with_body do
          content_tag(:div, class: "space-y-2") do
            content_tag(:p, "Add the gem to your Gemfile and run the install generator:") +
            content_tag(:pre, "rails generate shadcn:install", class: "bg-muted p-2 rounded text-sm mt-2")
          end
        end
      end
      accordion.with_item(value: "item-3") do |item|
        item.with_trigger { "Is it customizable?" }
        item.with_body { "Yes! All components are fully customizable with Tailwind CSS classes and theme variables." }
      end
    end
  end

  # @label Multiple With Default Values
  # Multiple accordion with pre-expanded items
  def multiple_with_defaults
    render(Shadcn::AccordionComponent.new(type: :multiple, default_value: ["item-1", "item-3"])) do |accordion|
      accordion.with_item(value: "item-1") do |item|
        item.with_trigger { "React" }
        item.with_body { "A JavaScript library for building user interfaces. Created by Facebook." }
      end
      accordion.with_item(value: "item-2") do |item|
        item.with_trigger { "Vue" }
        item.with_body { "A progressive JavaScript framework for building user interfaces. Created by Evan You." }
      end
      accordion.with_item(value: "item-3") do |item|
        item.with_trigger { "Rails" }
        item.with_body { "A server-side web application framework written in Ruby. Convention over configuration." }
      end
    end
  end

  # @label FAQ Example
  # Real-world FAQ use case
  def faq_example
    render(Shadcn::AccordionComponent.new(type: :single, collapsible: true)) do |accordion|
      accordion.with_item(value: "shipping") do |item|
        item.with_trigger { "What are the shipping options?" }
        item.with_body do
          content_tag(:div, class: "space-y-2 text-sm") do
            content_tag(:p, "We offer several shipping options:") +
            content_tag(:ul, class: "list-disc list-inside space-y-1 mt-2") do
              content_tag(:li, "Standard (5-7 business days) - Free") +
              content_tag(:li, "Express (2-3 business days) - $9.99") +
              content_tag(:li, "Overnight (1 business day) - $24.99")
            end
          end
        end
      end
      accordion.with_item(value: "returns") do |item|
        item.with_trigger { "What is your return policy?" }
        item.with_body { "We accept returns within 30 days of purchase. Items must be unused and in original packaging. Refunds are processed within 5-7 business days." }
      end
      accordion.with_item(value: "payment") do |item|
        item.with_trigger { "What payment methods do you accept?" }
        item.with_body { "We accept all major credit cards (Visa, Mastercard, American Express), PayPal, Apple Pay, and Google Pay." }
      end
    end
  end
end
