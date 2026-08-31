# frozen_string_literal: true

module Shadcn
  # Kbd component for displaying keyboard shortcuts
  # Matches shadcn/ui Kbd component
  #
  # @example Basic keyboard shortcut
  #   <%= render Shadcn::KbdComponent.new { "⌘" } %>
  #
  # @example Multiple keys
  #   <%= render Shadcn::KbdComponent.new { "⌘K" } %>
  #
  # @example With key combination
  #   <span class="flex items-center gap-1">
  #     <%= render Shadcn::KbdComponent.new { "Ctrl" } %>
  #     <span>+</span>
  #     <%= render Shadcn::KbdComponent.new { "C" } %>
  #   </span>
  #
  class KbdComponent < BaseComponent
    BASE_CLASSES = "pointer-events-none inline-flex h-5 w-fit min-w-5 items-center justify-center gap-1 rounded-sm bg-muted px-1 font-sans text-xs font-medium text-muted-foreground select-none [&_svg:not([class*='size-'])]:size-3 [[data-slot=tooltip-content]_&]:bg-background/20 [[data-slot=tooltip-content]_&]:text-background dark:[[data-slot=tooltip-content]_&]:bg-background/10"

    private

    def kbd_classes
      merge_classes(BASE_CLASSES)
    end

    def tag_attributes
      attrs = merge_html_attributes({}, slot: "kbd")
      attrs.map { |key, value| "#{key}=\"#{ERB::Util.html_escape_once(value)}\"" if value }.compact.join(" ").html_safe
    end
  end
end
