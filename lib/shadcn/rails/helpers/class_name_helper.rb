# frozen_string_literal: true

module Shadcn
  module Rails
    module Helpers
      # Helper module providing the cn() function for merging Tailwind CSS classes
      # This is the Ruby equivalent of shadcn/ui's cn() utility
      module ClassNameHelper
        extend ActiveSupport::Concern

        # Merge CSS classes intelligently, handling Tailwind class conflicts
        # Similar to clsx + tailwind-merge in JavaScript
        #
        # @param args [Array<String, Hash, Array, nil>] Classes to merge
        # @return [String] Merged class string
        #
        # @example Basic usage
        #   cn("px-4 py-2", "bg-blue-500") # => "px-4 py-2 bg-blue-500"
        #
        # @example With conditionals
        #   cn("base-class", { "active" => is_active, "disabled" => is_disabled })
        #
        # @example Overriding classes
        #   cn("px-4", "px-8") # => "px-8" (later class wins for same property)
        #
        def cn(*args)
          Shadcn::Rails::ClassMerger.merge(*args)
        end

        # Alias for cn() for those who prefer the full name
        alias_method :class_names, :cn
      end
    end
  end
end
