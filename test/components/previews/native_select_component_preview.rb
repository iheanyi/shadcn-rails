# frozen_string_literal: true

# @label Native Select
# @display bg_color "#ffffff"
class NativeSelectComponentPreview < ViewComponent::Preview
  # @label Default
  # Basic native select
  def default
    render_with_template
  end

  # @label With Optgroups
  # Native select with grouped options
  def with_optgroups
    render_with_template
  end

  # @label Disabled
  # Disabled native select
  def disabled
    render_with_template
  end

  # @label Required
  # Required native select
  def required
    render_with_template
  end

  # @label Form Example
  # Native select in a form context
  def form_example
    render_with_template
  end
end
