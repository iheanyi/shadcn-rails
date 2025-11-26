# frozen_string_literal: true

module Shadcn
  # Table component for displaying tabular data
  # Matches shadcn/ui Table component
  #
  # @example Basic table
  #   <%= render Shadcn::TableComponent.new do |table| %>
  #     <% table.with_header do |header| %>
  #       <% header.with_row do |row| %>
  #         <% row.with_head { "Name" } %>
  #         <% row.with_head { "Email" } %>
  #         <% row.with_head { "Role" } %>
  #       <% end %>
  #     <% end %>
  #     <% table.with_body do |body| %>
  #       <% @users.each do |user| %>
  #         <% body.with_row do |row| %>
  #           <% row.with_cell { user.name } %>
  #           <% row.with_cell { user.email } %>
  #           <% row.with_cell { user.role } %>
  #         <% end %>
  #       <% end %>
  #     <% end %>
  #   <% end %>
  #
  class TableComponent < BaseComponent
    BASE_CLASSES = "w-full caption-bottom text-sm"

    renders_one :caption, lambda { |**options|
      TableCaptionComponent.new(**options)
    }
    renders_one :header, lambda { |**options|
      TableHeaderComponent.new(**options)
    }
    renders_one :body, lambda { |**options|
      TableBodyComponent.new(**options)
    }
    renders_one :footer, lambda { |**options|
      TableFooterComponent.new(**options)
    }

    def call
      content_tag(:div, table_element, class: "relative w-full overflow-auto")
    end

    private

    def table_element
      content_tag(:table, table_content, class: merge_classes(BASE_CLASSES))
    end

    def table_content
      safe_join([caption, header, body, footer, content].compact)
    end
  end

  # Table Header component
  class TableHeaderComponent < BaseComponent
    BASE_CLASSES = "[&_tr]:border-b"

    renders_many :rows, lambda { |**options, &block|
      TableRowComponent.new(**options, &block)
    }

    def call
      content_tag(:thead, safe_join([rows, content].compact.flatten), class: merge_classes(BASE_CLASSES))
    end
  end

  # Table Body component
  class TableBodyComponent < BaseComponent
    BASE_CLASSES = "[&_tr:last-child]:border-0"

    renders_many :rows, lambda { |**options, &block|
      TableRowComponent.new(**options, &block)
    }

    def call
      content_tag(:tbody, safe_join([rows, content].compact.flatten), class: merge_classes(BASE_CLASSES))
    end
  end

  # Table Footer component
  class TableFooterComponent < BaseComponent
    BASE_CLASSES = "border-t bg-muted/50 font-medium [&>tr]:last:border-b-0"

    renders_many :rows, lambda { |**options, &block|
      TableRowComponent.new(**options, &block)
    }

    def call
      content_tag(:tfoot, safe_join([rows, content].compact.flatten), class: merge_classes(BASE_CLASSES))
    end
  end

  # Table Row component
  class TableRowComponent < BaseComponent
    BASE_CLASSES = "border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted"

    renders_many :heads, lambda { |**options, &block|
      TableHeadComponent.new(**options, &block)
    }
    renders_many :cells, lambda { |**options, &block|
      TableCellComponent.new(**options, &block)
    }

    # @param selected [Boolean] Whether row is selected
    def initialize(selected: false, **options)
      super(**options)
      @selected = selected
    end

    def call
      content_tag(:tr, row_content, row_attributes)
    end

    private

    def row_content
      safe_join([heads, cells, content].compact.flatten)
    end

    def row_attributes
      attrs = {
        class: merge_classes(BASE_CLASSES),
        "data-state": @selected ? "selected" : nil
      }
      attrs.merge!(html_options)
      attrs.compact
    end
  end

  # Table Head component
  class TableHeadComponent < BaseComponent
    BASE_CLASSES = "h-10 px-2 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]"

    def call
      content_tag(:th, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end

  # Table Cell component
  class TableCellComponent < BaseComponent
    BASE_CLASSES = "p-2 align-middle [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]"

    def call
      content_tag(:td, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end

  # Table Caption component
  class TableCaptionComponent < BaseComponent
    BASE_CLASSES = "mt-4 text-sm text-muted-foreground"

    def call
      content_tag(:caption, content, class: merge_classes(BASE_CLASSES), **html_options)
    end
  end
end
