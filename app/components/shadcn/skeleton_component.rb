# frozen_string_literal: true

module Shadcn
  # Skeleton component for loading placeholders
  # Matches shadcn/ui Skeleton component
  #
  # @example Basic skeleton
  #   <%= render Shadcn::SkeletonComponent.new(class_name: "h-4 w-[250px]") %>
  #
  # @example Circle skeleton (for avatars)
  #   <%= render Shadcn::SkeletonComponent.new(class_name: "h-12 w-12 rounded-full") %>
  #
  # @example Card skeleton
  #   <div class="flex flex-col space-y-3">
  #     <%= render Shadcn::SkeletonComponent.new(class_name: "h-[125px] w-[250px] rounded-xl") %>
  #     <div class="space-y-2">
  #       <%= render Shadcn::SkeletonComponent.new(class_name: "h-4 w-[250px]") %>
  #       <%= render Shadcn::SkeletonComponent.new(class_name: "h-4 w-[200px]") %>
  #     </div>
  #   </div>
  #
  class SkeletonComponent < BaseComponent
    BASE_CLASSES = "animate-pulse rounded-md bg-primary/10"

    def call
      content_tag(:div, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
