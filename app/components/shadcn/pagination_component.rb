# frozen_string_literal: true

module Shadcn
  # Pagination component for navigating paged content
  # Matches shadcn/ui Pagination component
  #
  # @example Basic pagination
  #   <%= render Shadcn::PaginationComponent.new do |pagination| %>
  #     <% pagination.with_pagination_content do |content| %>
  #       <% content.with_previous(href: "/page/1") %>
  #       <% content.with_item(href: "/page/1") { "1" } %>
  #       <% content.with_item(href: "/page/2", active: true) { "2" } %>
  #       <% content.with_item(href: "/page/3") { "3" } %>
  #       <% content.with_ellipsis %>
  #       <% content.with_next(href: "/page/3") %>
  #     <% end %>
  #   <% end %>
  #
  class PaginationComponent < BaseComponent
    BASE_CLASSES = "mx-auto flex w-full justify-center"

    renders_one :pagination_content, lambda { |**options|
      PaginationContentComponent.new(**options)
    }

    def call
      content_tag(:nav, build_pagination_content, pagination_attributes)
    end

    private

    def build_pagination_content
      pagination_content || ""
    end

    def pagination_attributes
      attrs = {
        role: "navigation",
        "aria-label": "pagination",
        class: merge_classes(BASE_CLASSES)
      }
      attrs.merge!(html_options)
      attrs.merge!(build_data)
      attrs.compact
    end
  end

  # Pagination Content component - container for items
  class PaginationContentComponent < BaseComponent
    BASE_CLASSES = "flex flex-row items-center gap-1"

    renders_many :items, ->(href: nil, active: false, disabled: false, **options, &block) do
      PaginationItemComponent.new(
        href: href,
        active: active,
        disabled: disabled,
        **options,
        &block
      )
    end

    renders_one :previous, lambda { |href: nil, disabled: false, **options|
      PaginationPreviousComponent.new(href: href, disabled: disabled, **options)
    }

    renders_one :next_page, lambda { |href: nil, disabled: false, **options|
      PaginationNextComponent.new(href: href, disabled: disabled, **options)
    }

    renders_many :ellipses, lambda { |**options|
      PaginationEllipsisComponent.new(**options)
    }

    def call
      content_tag(:ul, list_content, class: merge_classes(BASE_CLASSES))
    end

    private

    def list_content
      safe_join([
        previous,
        items.map(&:to_s),
        ellipses.map(&:to_s),
        next_page,
        content
      ].flatten.compact)
    end
  end

  # Pagination Item component - wrapper for links
  class PaginationItemComponent < BaseComponent
    LINK_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-9 w-9"
    ACTIVE_CLASSES = "border border-input bg-background shadow-sm"

    def initialize(href: nil, active: false, disabled: false, **options)
      super(**options)
      @href = href
      @active = active
      @disabled = disabled
    end

    def call
      content_tag(:li) do
        link_element
      end
    end

    private

    def link_element
      classes = cn(LINK_CLASSES, @active ? ACTIVE_CLASSES : "", class_name)

      if @href
        content_tag(:a, content, link_attributes(classes))
      else
        content_tag(:span, content, span_attributes(classes))
      end
    end

    def link_attributes(classes)
      attrs = {
        href: @href,
        class: classes,
        "aria-current": @active ? "page" : nil
      }
      attrs.merge!(html_options)
      attrs.compact
    end

    def span_attributes(classes)
      attrs = {
        class: classes,
        "aria-current": @active ? "page" : nil
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end

  # Pagination Previous button
  class PaginationPreviousComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2 gap-1 pl-2.5"

    def initialize(href: nil, disabled: false, **options)
      super(**options)
      @href = href
      @disabled = disabled
    end

    def call
      content_tag(:li) do
        link_content
      end
    end

    private

    def link_content
      inner = safe_join([chevron_left, "Previous"])

      if @href && !@disabled
        content_tag(:a, inner, href: @href, class: merge_classes(BASE_CLASSES), "aria-label": "Go to previous page")
      else
        content_tag(:span, inner, class: cn(merge_classes(BASE_CLASSES), "pointer-events-none opacity-50"), "aria-disabled": "true")
      end
    end

    def chevron_left
      content_tag(:svg,
        content_tag(:path, nil, d: "m15 18-6-6 6-6"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "h-4 w-4"
      )
    end
  end

  # Pagination Next button
  class PaginationNextComponent < BaseComponent
    BASE_CLASSES = "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2 gap-1 pr-2.5"

    def initialize(href: nil, disabled: false, **options)
      super(**options)
      @href = href
      @disabled = disabled
    end

    def call
      content_tag(:li) do
        link_content
      end
    end

    private

    def link_content
      inner = safe_join(["Next", chevron_right])

      if @href && !@disabled
        content_tag(:a, inner, href: @href, class: merge_classes(BASE_CLASSES), "aria-label": "Go to next page")
      else
        content_tag(:span, inner, class: cn(merge_classes(BASE_CLASSES), "pointer-events-none opacity-50"), "aria-disabled": "true")
      end
    end

    def chevron_right
      content_tag(:svg,
        content_tag(:path, nil, d: "m9 18 6-6-6-6"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: "h-4 w-4"
      )
    end
  end

  # Pagination Ellipsis component
  class PaginationEllipsisComponent < BaseComponent
    BASE_CLASSES = "flex h-9 w-9 items-center justify-center"

    def call
      content_tag(:li) do
        content_tag(:span, ellipsis_content, class: merge_classes(BASE_CLASSES), "aria-hidden": "true")
      end
    end

    private

    def ellipsis_content
      content_tag(:svg,
        content_tag(:circle, nil, cx: "12", cy: "12", r: "1") +
        content_tag(:circle, nil, cx: "19", cy: "12", r: "1") +
        content_tag(:circle, nil, cx: "5", cy: "12", r: "1"),
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewBox: "0 0 24 24",
        fill: "currentColor",
        class: "h-4 w-4"
      ) + content_tag(:span, "More pages", class: "sr-only")
    end
  end
end
