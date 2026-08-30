# frozen_string_literal: true

module Shadcn
  module Rails
    module Helpers
      # URL helpers for server-driven data tables.
      module DataTableHelper
        extend ActiveSupport::Concern

        SORT_ASCENDING = "asc"
        SORT_DESCENDING = "desc"
        SORT_DIRECTIONS = [SORT_ASCENDING, SORT_DESCENDING].freeze
        UNSET_SORT_VALUE = Object.new.freeze

        def shadcn_data_table_sort_url(
          column,
          params: nil,
          path: nil,
          sort_param: :sort,
          dir_param: :dir,
          page_param: :page,
          reset_page: true,
          sort: UNSET_SORT_VALUE,
          dir: UNSET_SORT_VALUE
        )
          query = shadcn_data_table_params_hash(params)
          sort_key = column.to_s
          next_direction = shadcn_data_table_next_sort_direction(
            sort_key,
            sort: sort.equal?(UNSET_SORT_VALUE) ? query[sort_param.to_s] : sort,
            dir: dir.equal?(UNSET_SORT_VALUE) ? query[dir_param.to_s] : dir
          )

          query.delete(page_param.to_s) if reset_page

          if next_direction
            query[sort_param.to_s] = sort_key
            query[dir_param.to_s] = next_direction
          else
            query.delete(sort_param.to_s)
            query.delete(dir_param.to_s)
          end

          shadcn_data_table_url_for(query, path: path)
        end

        def shadcn_data_table_next_sort_direction(column, sort:, dir:)
          return SORT_ASCENDING unless sort.to_s == column.to_s

          case shadcn_data_table_normalize_direction(dir)
          when SORT_ASCENDING
            SORT_DESCENDING
          when SORT_DESCENDING
            nil
          else
            SORT_ASCENDING
          end
        end

        def shadcn_data_table_aria_sort(column, sort:, dir:)
          return "none" unless sort.to_s == column.to_s

          case shadcn_data_table_normalize_direction(dir)
          when SORT_ASCENDING
            "ascending"
          when SORT_DESCENDING
            "descending"
          else
            "none"
          end
        end

        private

        def shadcn_data_table_params_hash(params)
          source =
            if params.nil? && respond_to?(:request) && request
              request.query_parameters
            else
              params || {}
            end

          hash =
            if source.respond_to?(:to_unsafe_h)
              source.to_unsafe_h
            elsif source.respond_to?(:to_h)
              source.to_h
            else
              {}
            end

          hash.deep_stringify_keys
        end

        def shadcn_data_table_url_for(query, path:)
          base_path = path
          base_path ||= request.path if respond_to?(:request) && request

          query_string = query.compact.to_query
          return base_path.presence || "?" if query_string.blank?

          "#{base_path.presence}?#{query_string}"
        end

        def shadcn_data_table_normalize_direction(direction)
          value = direction.to_s
          SORT_DIRECTIONS.include?(value) ? value : nil
        end
      end
    end
  end
end
