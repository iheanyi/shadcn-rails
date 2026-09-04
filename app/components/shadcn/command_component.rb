# frozen_string_literal: true

module Shadcn
  # Command component - a command palette for searching and selecting items
  # Matches shadcn/ui Command component (cmdk pattern)
  #
  # @example Basic command
  #   <%= render Shadcn::CommandComponent.new do |command| %>
  #     <% command.with_input(placeholder: "Type a command...") %>
  #     <% command.with_list do |list| %>
  #       <% list.with_empty { "No results found." } %>
  #       <% list.with_group(heading: "Suggestions") do |group| %>
  #         <% group.with_item(value: "calendar") { "Calendar" } %>
  #         <% group.with_item(value: "search") { "Search" } %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class CommandComponent < BaseComponent
    BASE_CLASSES = "flex h-full w-full flex-col overflow-hidden rounded-md bg-popover text-popover-foreground"

    # Input slot for search
    renders_one :input, lambda { |placeholder: "Type a command or search...", **options|
      CommandInputComponent.new(placeholder: placeholder, **options)
    }

    # List slot containing groups and items
    renders_one :list, lambda { |**options|
      CommandListComponent.new(**options)
    }

    def call
      content_tag(:div, command_content, **command_attributes)
    end

    private

    def command_content
      safe_join([input, list, content].compact)
    end

    def command_attributes
      {
        class: merge_classes(BASE_CLASSES),
        "data-slot": "command",
        data: {
          controller: "shadcn--command",
          action: "keydown->shadcn--command#handleKeydown"
        }
      }.merge(html_options).merge(build_data)
    end
  end
end
