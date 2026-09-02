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
          return merged if tailwind_prefix.empty?

          denormalize_prefixed_classes(
            prefixed_tailwind_merger.merge(normalize_prefixed_classes(merged))
          )
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

        def normalize_prefixed_classes(classes)
          prefixed_class_prefix = "#{tailwind_prefix}-"

          classes.split.map do |class_name|
            variant_prefix, utility = split_variant_prefix(class_name)
            important = utility.start_with?("!") ? "!" : ""
            utility = utility.delete_prefix("!")
            negative = utility.start_with?("-") ? "-" : ""
            utility = utility.delete_prefix("-")

            next class_name unless utility.start_with?(prefixed_class_prefix)

            "#{tailwind_prefix}:#{variant_prefix}#{important}#{negative}#{utility.delete_prefix(prefixed_class_prefix)}"
          end.join(" ")
        end

        def denormalize_prefixed_classes(classes)
          classes.split.map { |class_name| denormalize_prefixed_class(class_name) }.join(" ")
        end

        def denormalize_prefixed_class(class_name)
          prefixed_variant = "#{tailwind_prefix}:"
          return class_name unless class_name.start_with?(prefixed_variant)

          variant_prefix, utility = split_variant_prefix(class_name.delete_prefix(prefixed_variant))
          important = utility.delete_prefix!("!") ? "!" : ""
          negative = utility.delete_prefix!("-") ? "-" : ""

          "#{variant_prefix}#{important}#{negative}#{tailwind_prefix}-#{utility}"
        end

        def split_variant_prefix(class_name)
          bracket_depth = 0
          split_at = nil

          class_name.each_char.with_index do |char, index|
            bracket_depth += 1 if char == "["
            bracket_depth -= 1 if char == "]"
            split_at = index if char == ":" && bracket_depth.zero?
          end

          return ["", class_name] unless split_at

          [class_name[0..split_at], class_name[(split_at + 1)..]]
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
