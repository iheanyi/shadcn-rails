# frozen_string_literal: true

if defined?(Lookbook::Engine)
  Rails.application.configure do
    config.lookbook.project_name = "shadcn-rails"
    config.lookbook.preview_paths = [Rails.root.join("test/components/previews")]
  end
end
