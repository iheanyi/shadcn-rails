# frozen_string_literal: true

require "tailwind_merge"

module Shadcn
  module Rails
    # Utility class for merging CSS classes with tailwind_merge.
    class ClassMerger
      class << self
        # Merge CSS classes, handling conflicts
        # @param args [Array] Classes to merge (strings, hashes, arrays, or nil)
        # @return [String] Merged class string
        def merge(*args)
          class_string = flatten_classes(args).join(" ")
          return "" if class_string.empty?

          merged = merger.merge(class_string)
          tailwind_prefix.empty? ? merged : prefixed_tailwind_merger.merge(merged)
        end

        private

        def merger
          @merger ||= TailwindMerge::Merger.new
        end

        def prefixed_tailwind_merger
          prefix = tailwind_prefix
          merger_prefix = prefix.empty? ? nil : prefix

          if @prefixed_tailwind_merger_prefix != prefix
            @prefixed_tailwind_merger_prefix = prefix
            @prefixed_tailwind_merger = TailwindMerge::Merger.new(config: { prefix: merger_prefix })
          end

          @prefixed_tailwind_merger
        end

        def tailwind_prefix
          Shadcn::Rails.configuration.tailwind_prefix.to_s.delete_suffix("-")
        end

        # Flatten nested arrays and handle conditional hashes
        def flatten_classes(args)
          args.flat_map do |arg|
            case arg
            when nil, false
              []
            when String
              arg.split
            when Array
              flatten_classes(arg)
            when Hash
              arg.filter_map { |klass, condition| klass.to_s if condition }
            else
              arg.to_s.split
            end
          end
        end
      end
    end
  end
end
