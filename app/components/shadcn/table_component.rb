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
end
