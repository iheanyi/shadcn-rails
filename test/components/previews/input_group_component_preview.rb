# frozen_string_literal: true

# @label Input Group
# @display bg_color "#ffffff"
class InputGroupComponentPreview < ViewComponent::Preview
  # @label Default
  # Input group with a URL prefix
  def default
    render(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "https://" }
      group.with_input(placeholder: "example.com")
    end
  end

  # @label With Prefix
  # Input with prefix addon (URL prefix)
  def with_prefix
    render(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "https://" }
      group.with_input(placeholder: "example.com")
    end
  end

  # @label With Suffix
  # Input with suffix addon (email domain)
  def with_suffix
    render(Shadcn::InputGroupComponent.new) do |group|
      group.with_input(type: :text, placeholder: "username")
      group.with_suffix { "@example.com" }
    end
  end

  # @label With Both
  # Input with both prefix and suffix
  def with_both
    render(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "$" }
      group.with_input(type: :number, placeholder: "0.00")
      group.with_suffix { "USD" }
    end
  end

  # @label Currency Input
  # Currency input with symbol prefix
  def currency
    render(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "$" }
      group.with_input(type: :number, placeholder: "0.00")
    end
  end

  # @label Search Input
  # Search input with icon prefix
  def search
    render(Shadcn::InputGroupComponent.new) do |group|
      group.with_prefix { "Search" }
      group.with_input(type: :search, placeholder: "Search components...")
    end
  end
end
