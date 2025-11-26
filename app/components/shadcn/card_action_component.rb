# frozen_string_literal: true

module Shadcn
  # Card Action component
  class CardActionComponent < BaseComponent
    def call
      content_tag(:div, content, **html_options)
    end
  end
end
