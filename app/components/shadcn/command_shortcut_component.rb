# frozen_string_literal: true

module Shadcn
  # Command Shortcut component - displays keyboard shortcut hint
  class CommandShortcutComponent < BaseComponent
    BASE_CLASSES = "ml-auto text-xs tracking-widest text-muted-foreground"

    def call
      content_tag(:span, content, class: merge_classes(BASE_CLASSES), **html_options.merge(build_data))
    end
  end
end
