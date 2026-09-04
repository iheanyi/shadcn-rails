# frozen_string_literal: true

module Shadcn
  # Command Dialog component - command palette in a modal dialog
  # Combines Dialog and Command components
  #
  # @example Basic command dialog
  #   <%= render Shadcn::CommandDialogComponent.new do |dialog| %>
  #     <% dialog.with_trigger do %>
  #       <button>Open Command</button>
  #     <% end %>
  #     <% dialog.with_command do |command| %>
  #       <% command.with_input(placeholder: "Type a command...") %>
  #       <% command.with_list do |list| %>
  #         <% list.with_empty { "No results found." } %>
  #         <% list.with_group(heading: "Suggestions") do |group| %>
  #           <% group.with_item(value: "calendar") { "Calendar" } %>
  #         <% end %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class CommandDialogComponent < BaseComponent
    OVERLAY_CLASSES = "fixed inset-0 z-50 bg-black/50"
    CONTENT_CLASSES = "fixed left-[50%] top-[50%] z-50 translate-x-[-50%] translate-y-[-50%] overflow-hidden p-0 shadow-lg"
    COMMAND_CLASSES = "**:data-[slot=command-input-wrapper]:h-12 [&_[cmdk-group-heading]]:px-2 [&_[cmdk-group-heading]]:font-medium [&_[cmdk-group-heading]]:text-muted-foreground [&_[cmdk-group]]:px-2 [&_[cmdk-group]:not([hidden])_~[cmdk-group]]:pt-0 [&_[cmdk-input-wrapper]_svg]:h-5 [&_[cmdk-input-wrapper]_svg]:w-5 [&_[cmdk-input]]:h-12 [&_[cmdk-item]]:px-2 [&_[cmdk-item]]:py-3 [&_[cmdk-item]_svg]:h-5 [&_[cmdk-item]_svg]:w-5"

    # Trigger slot - simple wrapper that renders content
    renders_one :trigger, lambda { |**options, &block|
      content_tag(:div, data: { "shadcn--command-dialog-target": "trigger", action: "click->shadcn--command-dialog#open" }, **options, &block)
    }

    # Command slot
    renders_one :command, lambda { |**options|
      CommandComponent.new(class_name: COMMAND_CLASSES, **options)
    }

    # @param shortcut [String] Keyboard shortcut to open (e.g., "k" for Cmd+K)
    def initialize(shortcut: nil, **options)
      super(**options)
      @shortcut = shortcut
    end

    def call
      content_tag(:div, dialog_content, **dialog_attributes)
    end

    private

    def dialog_content
      safe_join([
        trigger,
        dialog_template
      ].compact)
    end

    def dialog_template
      content_tag(:template, data: { "shadcn--command-dialog-target": "template" }) do
        safe_join([
          content_tag(:div, "", class: OVERLAY_CLASSES, data: { "shadcn--command-dialog-target": "overlay", action: "click->shadcn--command-dialog#close" }),
          content_tag(:div, command || content, class: CONTENT_CLASSES, data: { "shadcn--command-dialog-target": "content" })
        ])
      end
    end

    def dialog_attributes
      attrs = {
        data: {
          controller: "shadcn--command-dialog",
          "shadcn--command-dialog-shortcut-value": @shortcut
        }.compact
      }
      attrs.merge(html_options).merge(build_data)
    end
  end
end
