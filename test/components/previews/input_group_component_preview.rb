# frozen_string_literal: true

# @label Input Group
# @display bg_color "#ffffff"
class InputGroupComponentPreview < ViewComponent::Preview
  # @label With Prefix
  # Input with prefix addon (URL prefix)
  def with_prefix
    render_with_template
  end

  # @label With Suffix
  # Input with suffix addon (email domain)
  def with_suffix
    render_with_template
  end

  # @label With Both
  # Input with both prefix and suffix
  def with_both
    render_with_template
  end

  # @label Currency Input
  # Currency input with symbol prefix
  def currency
    render_with_template
  end

  # @label Search Input
  # Search input with icon prefix
  def search
    render_with_template
  end
end
