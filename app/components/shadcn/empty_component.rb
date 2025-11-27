# frozen_string_literal: true

module Shadcn
  # Empty state component for displaying placeholder content when no data is available
  # Matches shadcn/ui Empty component
  #
  # @example Basic empty state
  #   <%= render Shadcn::EmptyComponent.new do |empty| %>
  #     <% empty.with_header do |header| %>
  #       <% header.with_media(variant: :icon) do %>
  #         <svg>...</svg>
  #       <% end %>
  #       <% header.with_title { "No Projects Yet" } %>
  #       <% header.with_description { "Get started by creating your first project." } %>
  #     <% end %>
  #     <% empty.with_content do %>
  #       <%= render Shadcn::ButtonComponent.new { "Create Project" } %>
  #     <% end %>
  #   <% end %>
  #
  # @example With outline style
  #   <%= render Shadcn::EmptyComponent.new(class_name: "border border-dashed") do |empty| %>
  #     ...
  #   <% end %>
  #
  class EmptyComponent < BaseComponent
    BASE_CLASSES = "flex flex-col items-center justify-center gap-6 py-16 text-center"

    # Header slot containing media, title, and description
    renders_one :header, lambda { |**options|
      EmptyHeaderComponent.new(**options)
    }

    # Content slot for action buttons
    renders_one :content_slot, lambda { |**options|
      EmptyContentComponent.new(**options)
    }

    # Alias for more intuitive API
    alias_method :with_content, :with_content_slot

    def call
      content_tag(:div, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data)) do
        safe_join([header, content_slot, content].compact)
      end
    end
  end
end
