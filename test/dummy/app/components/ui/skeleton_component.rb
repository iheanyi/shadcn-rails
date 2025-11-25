# frozen_string_literal: true

module Ui
  class SkeletonComponent < BaseComponent
    def initialize(class_name: nil, **html_options)
      @class_name = class_name
      @html_options = html_options
    end

    def call
      tag.div(class: skeleton_classes, **@html_options)
    end

    private

    def skeleton_classes
      cn("animate-pulse rounded-md bg-muted", @class_name)
    end
  end
end
