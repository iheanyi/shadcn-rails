# frozen_string_literal: true

module Shadcn
  # Server-first data table recipe built from Table, Empty, and Pagination.
  class DataTableComponent < BaseComponent
    include Shadcn::Rails::Helpers::DataTableHelper

    BASE_CLASSES = "space-y-4"
    EMPTY_CELL_CLASSES = "h-32 p-0"
    SORT_INDICATOR_CLASSES = "text-[0.65rem] font-medium uppercase tracking-wide text-muted-foreground"

    renders_one :toolbar
    renders_one :empty_state
    renders_one :footer

    def initialize(
      rows:,
      sort: nil,
      dir: nil,
      params: nil,
      path: nil,
      caption: nil,
      empty_title: "No results",
      empty_description: "Try adjusting your filters or search terms.",
      sort_param: :sort,
      dir_param: :dir,
      page_param: :page,
      reset_page_on_sort: true,
      sort_url_builder: nil,
      **options
    )
      super(**options)
      @rows = rows
      @sort = sort
      @dir = dir
      @params = params
      @path = path
      @caption = caption
      @empty_title = empty_title
      @empty_description = empty_description
      @sort_param = sort_param
      @dir_param = dir_param
      @page_param = page_param
      @reset_page_on_sort = reset_page_on_sort
      @sort_url_builder = sort_url_builder
    end

    def with_column(key, **options, &block)
      DataTableColumnComponent.new(key, **options, &block).tap do |column|
        columns << column
      end
    end

    def columns
      @columns ||= []
    end

    def before_render
      content
    end

    private

    def wrapper_classes
      merge_classes(BASE_CLASSES)
    end

    def table_rows
      @table_rows ||= @rows.to_a
    end

    def column_count
      [columns.count, 1].max
    end

    def render_sortable_header(column)
      content_tag(
        :a,
        safe_join([column.label, sort_indicator_for(column)]),
        href: sort_href_for(column),
        class: column.header_link_classes
      )
    end

    def sort_href_for(column)
      next_direction = shadcn_data_table_next_sort_direction(column.sort_key, sort: @sort, dir: @dir)

      if @sort_url_builder
        return @sort_url_builder.call(column.sort_key, next_direction)
      end

      shadcn_data_table_sort_url(
        column.sort_key,
        params: @params,
        path: @path,
        sort_param: @sort_param,
        dir_param: @dir_param,
        page_param: @page_param,
        reset_page: @reset_page_on_sort,
        sort: @sort,
        dir: @dir
      )
    end

    def aria_sort_for(column)
      shadcn_data_table_aria_sort(column.sort_key, sort: @sort, dir: @dir)
    end

    def sort_indicator_for(column)
      label =
        case aria_sort_for(column)
        when "ascending"
          "asc"
        when "descending"
          "desc"
        else
          "sort"
        end

      content_tag(:span, label, class: SORT_INDICATOR_CLASSES, "aria-hidden": true)
    end

    def render_empty_state
      return empty_state if empty_state

      render Shadcn::EmptyComponent.new(class_name: "py-10") do |empty|
        empty.with_header do |header|
          header.with_title { @empty_title }
          header.with_description { @empty_description }
        end
      end
    end
  end
end
