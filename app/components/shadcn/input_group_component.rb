# frozen_string_literal: true

module Shadcn
  # Input Group component for inputs with prefix/suffix addons
  # Matches shadcn/ui Input Group pattern
  #
  # @example With prefix icon
  #   <%= render Shadcn::InputGroupComponent.new do |group| %>
  #     <% group.with_prefix do %>
  #       <svg><!-- search icon --></svg>
  #     <% end %>
  #     <% group.with_input(placeholder: "Search...") %>
  #   <% end %>
  #
  # @example With suffix icon
  #   <%= render Shadcn::InputGroupComponent.new do |group| %>
  #     <% group.with_input(type: :email, placeholder: "Email") %>
  #     <% group.with_suffix do %>
  #       <svg><!-- mail icon --></svg>
  #     <% end %>
  #   <% end %>
  #
  # @example With prefix text
  #   <%= render Shadcn::InputGroupComponent.new do |group| %>
  #     <% group.with_prefix { "https://" } %>
  #     <% group.with_input(placeholder: "example.com") %>
  #   <% end %>
  #
  # @example With both prefix and suffix
  #   <%= render Shadcn::InputGroupComponent.new do |group| %>
  #     <% group.with_prefix { "$" } %>
  #     <% group.with_input(type: :number, placeholder: "0.00") %>
  #     <% group.with_suffix { "USD" } %>
  #   <% end %>
  #
  class InputGroupComponent < BaseComponent
    BASE_CLASSES = "flex items-center rounded-md border border-input ring-offset-background focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2"

    # Prefix addon slot
    renders_one :prefix, "AddonComponent"

    # Input slot
    renders_one :input, lambda { |**options|
      # Remove border, ring, rounded corners and shadow from input since the group handles it
      options[:class_name] = cn(
        "border-0 rounded-none shadow-none focus-visible:ring-0 focus-visible:ring-offset-0 focus:ring-0 focus:outline-none",
        options[:class_name]
      )
      Shadcn::InputComponent.new(**options)
    }

    # Suffix addon slot
    renders_one :suffix, "AddonComponent"

    def call
      tag.div(class: merge_classes(BASE_CLASSES), **html_options.merge(build_data)) do
        safe_join([prefix, input, suffix].compact)
      end
    end

    # Addon subcomponent for prefix/suffix
    class AddonComponent < BaseComponent
      BASE_CLASSES = "flex items-center justify-center px-3 text-sm text-muted-foreground"

      def call
        tag.span(content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
      end
    end
  end
end
