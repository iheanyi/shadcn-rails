# frozen_string_literal: true

module Shadcn
  # Column definition used by DataTableComponent.
  class DataTableColumnComponent < BaseComponent
    ALIGNMENT_CLASSES = {
      start: "",
      center: "text-center",
      end: "text-right"
    }.freeze

    HEADER_LINK_ALIGNMENT_CLASSES = {
      start: "",
      center: "justify-center",
      end: "justify-end"
    }.freeze

    attr_reader :key, :label, :sort_key, :header_class_name, :cell_class_name

    def initialize(
      key,
      label: nil,
      sortable: false,
      sort_key: nil,
      align: :start,
      header_class_name: nil,
      cell_class_name: nil,
      **options,
      &block
    )
      super(**options)
      @key = key.to_sym
      @label = label || key.to_s.humanize
      @sortable = sortable
      @sort_key = (sort_key || key).to_s
      @align = align.to_sym
      @header_class_name = header_class_name
      @cell_class_name = cell_class_name
      @cell_block = block
    end

    def sortable?
      @sortable
    end

    def header_classes
      cn(ALIGNMENT_CLASSES.fetch(@align, ""), @header_class_name)
    end

    def cell_classes
      cn(ALIGNMENT_CLASSES.fetch(@align, ""), @cell_class_name, class_name)
    end

    def header_link_classes
      cn(
        "inline-flex items-center gap-1 rounded-sm underline-offset-4 hover:text-foreground hover:underline focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring",
        HEADER_LINK_ALIGNMENT_CLASSES.fetch(@align, "")
      )
    end

    def value_for(row, renderer)
      return default_value(row) unless @cell_block

      if @cell_block.arity.zero?
        renderer.capture(&@cell_block)
      else
        renderer.capture(row, &@cell_block)
      end
    end

    private

    def default_value(row)
      if row.respond_to?(:[])
        if row.respond_to?(:key?) && row.key?(@key)
          row[@key]
        elsif row.respond_to?(:key?) && row.key?(@key.to_s)
          row[@key.to_s]
        else
          row[@key] || row[@key.to_s]
        end
      elsif row.respond_to?(@key)
        row.public_send(@key)
      end
    end
  end
end
