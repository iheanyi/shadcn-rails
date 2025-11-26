# frozen_string_literal: true

module Shadcn
  # Dropdown Menu component
  # Matches shadcn/ui DropdownMenu component
  # Uses Stimulus for interactivity
  #
  # @example Basic dropdown
  #   <%= render Shadcn::DropdownMenuComponent.new do |menu| %>
  #     <% menu.with_trigger do %>
  #       <%= render Shadcn::ButtonComponent.new(variant: :outline) { "Open Menu" } %>
  #     <% end %>
  #     <% menu.with_content do |content| %>
  #       <% content.with_label { "My Account" } %>
  #       <% content.with_separator %>
  #       <% content.with_item(href: "/profile") { "Profile" } %>
  #       <% content.with_item(href: "/settings") { "Settings" } %>
  #       <% content.with_separator %>
  #       <% content.with_item(variant: :destructive) { "Log out" } %>
  #     <% end %>
  #   <% end %>
  #
  class DropdownMenuComponent < BaseComponent
    renders_one :trigger
    renders_one :menu, lambda { |**options|
      DropdownMenuContentComponent.new(**options)
    }

    # @param open [Boolean] Whether dropdown starts open
    # @param align [Symbol] Content alignment (:start, :center, :end)
    # @param side [Symbol] Side to show content (:top, :right, :bottom, :left)
    def initialize(open: false, align: :end, side: :bottom, **options)
      super(**options)
      @open = open
      @align = align
      @side = side
    end

    def call
      content_tag(:div, dropdown_content, dropdown_attributes)
    end

    private

    def dropdown_content
      safe_join([
        trigger_wrapper,
        menu
      ].compact)
    end

    def trigger_wrapper
      return unless trigger

      content_tag(:div, trigger, {
        "data-shadcn--dropdown-target": "trigger",
        "data-action": "click->shadcn--dropdown#toggle"
      })
    end

    def dropdown_attributes
      attrs = {
        class: cn("relative inline-block", class_name),
        "data-controller": "shadcn--dropdown",
        "data-shadcn--dropdown-open-value": @open.to_s,
        "data-shadcn--dropdown-align-value": @align.to_s,
        "data-shadcn--dropdown-side-value": @side.to_s,
        "data-action": "keydown.escape->shadcn--dropdown#close clickOutside->shadcn--dropdown#close"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Dropdown Menu Content component
  class DropdownMenuContentComponent < BaseComponent
    BASE_CLASSES = "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"

    renders_many :items, lambda { |**options, &block|
      DropdownMenuItemComponent.new(**options, &block)
    }
    renders_many :labels, lambda { |**options, &block|
      DropdownMenuLabelComponent.new(**options, &block)
    }
    renders_many :separators, lambda { |**options|
      DropdownMenuSeparatorComponent.new(**options)
    }
    renders_many :groups, lambda { |**options, &block|
      DropdownMenuGroupComponent.new(**options, &block)
    }

    def call
      content_tag(:div, menu_content, menu_attributes)
    end

    private

    def menu_content
      # If items/labels/separators are used, render them
      # Otherwise render the block content
      if items.any? || labels.any? || separators.any? || groups.any?
        safe_join([labels, items, separators, groups, content].flatten.compact)
      else
        content
      end
    end

    def menu_attributes
      {
        class: merge_classes(BASE_CLASSES),
        role: "menu",
        "aria-orientation": "vertical",
        "data-shadcn--dropdown-target": "content",
        "data-state": "closed",
        "data-side": "bottom",
        hidden: true
      }
    end
  end

  # Dropdown Menu Item component
  class DropdownMenuItemComponent < BaseComponent
    BASE_CLASSES = "relative flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&>svg]:size-4 [&>svg]:shrink-0"

    VARIANTS = {
      default: "",
      destructive: "text-destructive focus:bg-destructive focus:text-destructive-foreground"
    }.freeze

    renders_one :shortcut, lambda { |**options|
      DropdownMenuShortcutComponent.new(**options)
    }

    # @param href [String, nil] Link URL
    # @param variant [Symbol] Item variant (:default, :destructive)
    # @param disabled [Boolean] Whether item is disabled
    # @param inset [Boolean] Whether to add left padding for icons
    def initialize(href: nil, variant: :default, disabled: false, inset: false, **options)
      super(**options)
      @href = href
      @variant = variant.to_sym
      @disabled = disabled
      @inset = inset
    end

    def call
      tag_name = @href ? :a : :div
      content_tag(tag_name, item_content, item_attributes)
    end

    private

    def item_content
      safe_join([content, shortcut].compact)
    end

    def item_classes
      cn(
        BASE_CLASSES,
        VARIANTS[@variant],
        @inset ? "pl-8" : "",
        class_name
      )
    end

    def item_attributes
      attrs = {
        class: item_classes,
        role: "menuitem",
        tabindex: @disabled ? nil : "-1",
        href: @href,
        "data-disabled": @disabled ? "" : nil,
        "data-action": "click->shadcn--dropdown#selectItem"
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Dropdown Menu Label component
  class DropdownMenuLabelComponent < BaseComponent
    BASE_CLASSES = "px-2 py-1.5 text-sm font-semibold"

    # @param inset [Boolean] Whether to add left padding
    def initialize(inset: false, **options)
      super(**options)
      @inset = inset
    end

    def call
      content_tag(:div, content, class: cn(BASE_CLASSES, @inset ? "pl-8" : "", class_name))
    end
  end

  # Dropdown Menu Separator component
  class DropdownMenuSeparatorComponent < BaseComponent
    BASE_CLASSES = "-mx-1 my-1 h-px bg-muted"

    def call
      content_tag(:div, "", class: merge_classes(BASE_CLASSES), role: "separator")
    end
  end

  # Dropdown Menu Group component
  class DropdownMenuGroupComponent < BaseComponent
    def call
      content_tag(:div, content, role: "group", **html_options)
    end
  end

  # Dropdown Menu Shortcut component
  class DropdownMenuShortcutComponent < BaseComponent
    BASE_CLASSES = "ml-auto text-xs tracking-widest opacity-60"

    def call
      content_tag(:span, content, class: merge_classes(BASE_CLASSES))
    end
  end
end
