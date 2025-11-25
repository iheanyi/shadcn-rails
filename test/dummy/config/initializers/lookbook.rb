# frozen_string_literal: true

if defined?(Lookbook)
  Rails.application.config.lookbook.project_name = "shadcn-rails"
  Rails.application.config.lookbook.preview_paths = [
    Rails.root.join("test/components/previews")
  ]

  # Enable experimental features
  Rails.application.config.lookbook.preview_inspector = true
end
