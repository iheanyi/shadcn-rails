# frozen_string_literal: true

module Shadcn
  module Rails
    # Utility class for merging CSS classes intelligently
    # Handles Tailwind CSS class conflicts similar to tailwind-merge
    class ClassMerger
      # Class groups that conflict with each other
      # Later classes in the same group override earlier ones
      CLASS_GROUPS = {
        # Display
        display: %w[block inline-block inline flex inline-flex grid inline-grid hidden],

        # Position
        position: %w[static fixed absolute relative sticky],

        # Overflow
        overflow: %w[overflow-auto overflow-hidden overflow-visible overflow-scroll],
        overflow_x: %w[overflow-x-auto overflow-x-hidden overflow-x-visible overflow-x-scroll],
        overflow_y: %w[overflow-y-auto overflow-y-hidden overflow-y-visible overflow-y-scroll],

        # Flex direction
        flex_direction: %w[flex-row flex-row-reverse flex-col flex-col-reverse],

        # Flex wrap
        flex_wrap: %w[flex-wrap flex-wrap-reverse flex-nowrap],

        # Justify content
        justify: %w[justify-start justify-end justify-center justify-between justify-around justify-evenly],

        # Align items
        items: %w[items-start items-end items-center items-baseline items-stretch],

        # Align content
        content: %w[content-start content-end content-center content-between content-around content-evenly],

        # Align self
        self: %w[self-auto self-start self-end self-center self-stretch],

        # Font size
        font_size: %w[text-xs text-sm text-base text-lg text-xl text-2xl text-3xl text-4xl text-5xl text-6xl text-7xl text-8xl text-9xl],

        # Font weight
        font_weight: %w[font-thin font-extralight font-light font-normal font-medium font-semibold font-bold font-extrabold font-black],

        # Text align
        text_align: %w[text-left text-center text-right text-justify],

        # Whitespace
        whitespace: %w[whitespace-normal whitespace-nowrap whitespace-pre whitespace-pre-line whitespace-pre-wrap],

        # Text decoration
        text_decoration: %w[underline overline line-through no-underline],

        # Border style
        border_style: %w[border-solid border-dashed border-dotted border-double border-none],

        # Cursor
        cursor: %w[cursor-auto cursor-default cursor-pointer cursor-wait cursor-text cursor-move cursor-not-allowed]
      }.freeze

      # Regex patterns for conflicting classes
      CONFLICT_PATTERNS = {
        # Spacing (margin, padding)
        /^m-/ => :margin,
        /^mx-/ => :margin_x,
        /^my-/ => :margin_y,
        /^mt-/ => :margin_top,
        /^mr-/ => :margin_right,
        /^mb-/ => :margin_bottom,
        /^ml-/ => :margin_left,
        /^p-/ => :padding,
        /^px-/ => :padding_x,
        /^py-/ => :padding_y,
        /^pt-/ => :padding_top,
        /^pr-/ => :padding_right,
        /^pb-/ => :padding_bottom,
        /^pl-/ => :padding_left,

        # Sizing
        /^w-/ => :width,
        /^min-w-/ => :min_width,
        /^max-w-/ => :max_width,
        /^h-/ => :height,
        /^min-h-/ => :min_height,
        /^max-h-/ => :max_height,
        /^size-/ => :size,

        # Colors
        /^bg-/ => :background,
        /^text-(?!left|center|right|justify|xs|sm|base|lg|xl|2xl|3xl|4xl|5xl|6xl|7xl|8xl|9xl)/ => :text_color,
        /^border-(?!solid|dashed|dotted|double|none|[0-9])/ => :border_color,
        /^ring-(?!offset)/ => :ring_color,
        /^ring-offset-(?!\d)/ => :ring_offset_color,

        # Border radius
        /^rounded(?:-|$)/ => :border_radius,
        /^rounded-t(?:-|$)/ => :border_radius_top,
        /^rounded-r(?:-|$)/ => :border_radius_right,
        /^rounded-b(?:-|$)/ => :border_radius_bottom,
        /^rounded-l(?:-|$)/ => :border_radius_left,
        /^rounded-tl(?:-|$)/ => :border_radius_top_left,
        /^rounded-tr(?:-|$)/ => :border_radius_top_right,
        /^rounded-bl(?:-|$)/ => :border_radius_bottom_left,
        /^rounded-br(?:-|$)/ => :border_radius_bottom_right,

        # Border width
        /^border(?:-[0-9]|$)/ => :border_width,
        /^border-t(?:-[0-9]|$)/ => :border_width_top,
        /^border-r(?:-[0-9]|$)/ => :border_width_right,
        /^border-b(?:-[0-9]|$)/ => :border_width_bottom,
        /^border-l(?:-[0-9]|$)/ => :border_width_left,

        # Opacity
        /^opacity-/ => :opacity,

        # Z-index
        /^z-/ => :z_index,

        # Gap
        /^gap-/ => :gap,
        /^gap-x-/ => :gap_x,
        /^gap-y-/ => :gap_y,

        # Grid
        /^grid-cols-/ => :grid_cols,
        /^grid-rows-/ => :grid_rows,
        /^col-span-/ => :col_span,
        /^row-span-/ => :row_span,

        # Shadow
        /^shadow(?:-|$)/ => :shadow,

        # Transition
        /^transition(?:-|$)/ => :transition,
        /^duration-/ => :duration,
        /^ease-/ => :ease,

        # Transform
        /^scale-/ => :scale,
        /^rotate-/ => :rotate,
        /^translate-x-/ => :translate_x,
        /^translate-y-/ => :translate_y
      }.freeze

      class << self
        # Merge CSS classes, handling conflicts
        # @param args [Array] Classes to merge (strings, hashes, arrays, or nil)
        # @return [String] Merged class string
        def merge(*args)
          classes = flatten_classes(args)
          dedupe_classes(classes).join(" ")
        end

        private

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

        # Remove duplicate/conflicting classes, keeping last occurrence
        def dedupe_classes(classes)
          class_groups = {}
          result = []

          classes.each do |klass|
            # Strip responsive/state prefixes for conflict detection
            base_class = strip_prefixes(klass)
            group = find_conflict_group(base_class)

            if group
              # Get the prefix (like "sm:", "hover:", etc.)
              prefix = klass.sub(base_class, "")

              # Create a unique key combining prefix and group
              key = "#{prefix}:#{group}"

              # If we've seen this group before, remove the old class
              if class_groups[key]
                result.delete(class_groups[key])
              end

              class_groups[key] = klass
            end

            result << klass
          end

          result.uniq
        end

        # Strip responsive and state prefixes
        def strip_prefixes(klass)
          klass.gsub(/^(?:sm:|md:|lg:|xl:|2xl:|hover:|focus:|active:|disabled:|dark:|group-hover:|peer-\w+:)+/, "")
        end

        # Find the conflict group for a class
        def find_conflict_group(klass)
          # Check static groups first
          CLASS_GROUPS.each do |group, classes|
            return group if classes.include?(klass)
          end

          # Check pattern-based groups
          CONFLICT_PATTERNS.each do |pattern, group|
            return group if klass.match?(pattern)
          end

          nil
        end
      end
    end
  end
end
