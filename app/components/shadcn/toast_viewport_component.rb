# frozen_string_literal: true

module Shadcn
  # Toast Viewport (container for all toasts)
  class ToastViewportComponent < BaseComponent
    BASE_CLASSES = "fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]"

    def call
      content_tag(:ol, content, class: merge_classes(BASE_CLASSES), tabindex: "-1", "data-shadcn--toaster-target": "viewport")
    end
  end
end
