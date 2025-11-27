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
    BASE_CLASSES = 'pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border bg-muted px-1.5 font-mono text-[10px] font-medium text-muted-foreground opacity-100'

    private

    def kbd_classes
      merge_classes(BASE_CLASSES)
    end
  end
end
