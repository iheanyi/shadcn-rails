# frozen_string_literal: true

# @label Kbd
# @display bg_color "#ffffff"
class KbdComponentPreview < ViewComponent::Preview
  # @label Default
  # Default keyboard shortcut display
  def default
    render(Shadcn::KbdComponent.new) { "K" }
  end

  # @label Shortcut Combination
  # Display a keyboard shortcut combination
  def combination
    render(Shadcn::KbdComponent.new) { "Ctrl + K" }
  end

  # @label Command Key
  # Display command/meta key
  def command_key
    render(Shadcn::KbdComponent.new) { "⌘" }
  end

  # @label Full Shortcut
  # Common shortcut patterns
  def shortcuts
    render(Shadcn::KbdComponent.new) { "Ctrl + Shift + P" }
  end
end
