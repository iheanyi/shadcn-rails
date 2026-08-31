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
    BASE_CLASSES = [
      "group/input-group relative flex w-full items-center rounded-md border border-input shadow-xs transition-[color,box-shadow] outline-none dark:bg-input/30",
      "h-9 min-w-0 has-[>textarea]:h-auto",
      "has-[>[data-align=inline-start]]:[&>input]:pl-2",
      "has-[>[data-align=inline-end]]:[&>input]:pr-2",
      "has-[>[data-align=block-start]]:h-auto has-[>[data-align=block-start]]:flex-col has-[>[data-align=block-start]]:[&>input]:pb-3",
      "has-[>[data-align=block-end]]:h-auto has-[>[data-align=block-end]]:flex-col has-[>[data-align=block-end]]:[&>input]:pt-3",
      "has-[[data-slot=input-group-control]:focus-visible]:border-ring has-[[data-slot=input-group-control]:focus-visible]:ring-[3px] has-[[data-slot=input-group-control]:focus-visible]:ring-ring/50",
      "has-[[data-slot][aria-invalid=true]]:border-destructive has-[[data-slot][aria-invalid=true]]:ring-destructive/20 dark:has-[[data-slot][aria-invalid=true]]:ring-destructive/40"
    ].join(" ")

    INPUT_CLASSES = "flex-1 rounded-none border-0 bg-transparent shadow-none focus-visible:ring-0 dark:bg-transparent"
    TEXTAREA_CLASSES = "flex-1 resize-none rounded-none border-0 bg-transparent py-3 shadow-none focus-visible:ring-0 dark:bg-transparent"

    # Prefix addon slot
    renders_one :prefix, lambda { |align: :inline_start, **options|
      AddonComponent.new(align: align, **options)
    }

    # Input slot
    renders_one :input, lambda { |**options|
      # Remove border, ring, rounded corners and shadow from input since the group handles it
      options[:class_name] = cn(
        INPUT_CLASSES,
        options[:class_name]
      )
      options[:data] = (options[:data] || {}).merge(slot: "input-group-control")
      Shadcn::InputComponent.new(**options)
    }

    # Textarea slot
    renders_one :textarea, lambda { |**options|
      options[:class_name] = cn(
        TEXTAREA_CLASSES,
        options[:class_name]
      )
      options[:data] = (options[:data] || {}).merge(slot: "input-group-control")
      Shadcn::TextareaComponent.new(**options)
    }

    # Suffix addon slot
    renders_one :suffix, lambda { |align: :inline_end, **options|
      AddonComponent.new(align: align, **options)
    }

    def call
      tag.div(class: merge_classes(BASE_CLASSES), **html_options.merge(build_data(slot: "input-group"), role: "group")) do
        safe_join([prefix, input, textarea, suffix].compact)
      end
    end

    # Addon subcomponent for prefix/suffix
    class AddonComponent < BaseComponent
      BASE_CLASSES = "flex h-auto cursor-text items-center justify-center gap-2 py-1.5 text-sm font-medium text-muted-foreground select-none group-data-[disabled=true]/input-group:opacity-50 [&>kbd]:rounded-[calc(var(--radius)-5px)] [&>svg:not([class*='size-'])]:size-4"
      ALIGN_CLASSES = {
        inline_start: "order-first pl-3 has-[>button]:ml-[-0.45rem] has-[>kbd]:ml-[-0.35rem]",
        inline_end: "order-last pr-3 has-[>button]:mr-[-0.45rem] has-[>kbd]:mr-[-0.35rem]",
        block_start: "order-first w-full justify-start px-3 pt-3 group-has-[>input]/input-group:pt-2.5 [.border-b]:pb-3",
        block_end: "order-last w-full justify-start px-3 pb-3 group-has-[>input]/input-group:pb-2.5 [.border-t]:pt-3"
      }.freeze

      def initialize(align: :inline_start, **options)
        super(**options)
        @align = align.to_s.tr("-", "_").to_sym
      end

      def call
        tag.div(content, class: addon_classes, **html_options.merge(build_data(slot: "input-group-addon", align: data_align), role: "group"))
      end

      private

      def addon_classes
        merge_classes(cn(BASE_CLASSES, ALIGN_CLASSES.fetch(@align)))
      end

      def data_align
        @align.to_s.tr("_", "-")
      end
    end

    class InputGroupButtonComponent < BaseComponent
      BASE_CLASSES = "flex items-center gap-2 text-sm shadow-none"
      SIZE_CLASSES = {
        xs: "h-6 gap-1 rounded-[calc(var(--radius)-5px)] px-2 has-[>svg]:px-2 [&>svg:not([class*='size-'])]:size-3.5",
        sm: "h-8 gap-1.5 rounded-md px-2.5 has-[>svg]:px-2.5",
        icon_xs: "size-6 rounded-[calc(var(--radius)-5px)] p-0 has-[>svg]:p-0",
        icon_sm: "size-8 p-0 has-[>svg]:p-0"
      }.freeze

      def initialize(type: "button", variant: :ghost, size: :xs, **options)
        super(**options)
        @type = type
        @variant = variant
        @size = size.to_s.tr("-", "_").to_sym
      end

      def call
        render ::Shadcn::ButtonComponent.new(
          type: @type,
          variant: @variant,
          class_name: cn(BASE_CLASSES, SIZE_CLASSES.fetch(@size), class_name),
          data: data.merge(size: data_size),
          **html_options
        ) do
          content
        end
      end

      private

      def data_size
        @size.to_s.tr("_", "-")
      end
    end

    class InputGroupTextComponent < BaseComponent
      BASE_CLASSES = "flex items-center gap-2 text-sm text-muted-foreground [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4"

      def call
        tag.span(content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
      end
    end
  end
end
