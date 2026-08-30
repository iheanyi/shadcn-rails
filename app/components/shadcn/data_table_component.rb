# frozen_string_literal: true

module Shadcn
  # Server-first data table recipe built from Table, Empty, and Pagination.
  class DataTableComponent < BaseComponent
    include Shadcn::Rails::Helpers::DataTableHelper

    BASE_CLASSES = "space-y-4"
    EMPTY_CELL_CLASSES = "h-32 p-0"
    SORT_INDICATOR_CLASSES = "ml-2 inline-flex shrink-0 text-foreground"
    SORT_INDICATOR_MUTED_CLASSES = "text-muted-foreground opacity-50"
    SORT_ICON_CLASSES = "h-4 w-4"

    renders_many :columns, lambda { |key, **options, &block|
      DataTableColumnComponent.new(key, **options, &block)
    }
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
      current_sort = current_sort_value
      current_dir = current_dir_value
      next_direction = shadcn_data_table_next_sort_direction(column.sort_key, sort: current_sort, dir: current_dir)

      if @sort_url_builder
        return @sort_url_builder.call(column.sort_key, next_direction)
      end

      options = {
        params: @params,
        path: @path,
        sort_param: @sort_param,
        dir_param: @dir_param,
        page_param: @page_param,
        reset_page: @reset_page_on_sort
      }
      options[:current_sort] = current_sort unless current_sort.nil?
      options[:current_dir] = current_dir unless current_dir.nil?

      shadcn_data_table_sort_url(
        column.sort_key,
        **options
      )
    end

    def aria_sort_for(column)
      shadcn_data_table_aria_sort(column.sort_key, sort: current_sort_value, dir: current_dir_value)
    end

    def current_sort_value
      return @sort unless @sort.nil?

      current_params[@sort_param.to_s]
    end

    def current_dir_value
      return @dir unless @dir.nil?

      current_params[@dir_param.to_s]
    end

    def current_params
      @current_params ||= shadcn_data_table_params_hash(@params)
    end

    def sort_indicator_for(column)
      sort_state = aria_sort_for(column)
      icon_name, icon_paths, state_classes =
        case sort_state
        when "ascending"
          ["arrow-up", arrow_up_icon_paths, nil]
        when "descending"
          ["arrow-down", arrow_down_icon_paths, nil]
        else
          ["chevrons-up-down", chevrons_up_down_icon_paths, SORT_INDICATOR_MUTED_CLASSES]
        end

      content_tag(
        :span,
        sort_icon(icon_name, icon_paths),
        class: prefix_classes(cn(SORT_INDICATOR_CLASSES, state_classes)),
        "aria-hidden": true
      )
    end

    def sort_icon(name, paths)
      content_tag(
        :svg,
        safe_join(paths.map { |path| tag.path(d: path) }),
        xmlns: "http://www.w3.org/2000/svg",
        width: "24",
        height: "24",
        viewBox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: prefix_classes(SORT_ICON_CLASSES),
        "data-sort-icon": name
      )
    end

    def arrow_up_icon_paths
      ["m5 12 7-7 7 7", "M12 19V5"]
    end

    def arrow_down_icon_paths
      ["M12 5v14", "m19 12-7 7-7-7"]
    end

    def chevrons_up_down_icon_paths
      ["m7 15 5 5 5-5", "m7 9 5-5 5 5"]
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
