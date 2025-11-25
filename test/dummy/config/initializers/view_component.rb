# frozen_string_literal: true

# ViewComponent configuration
if defined?(ViewComponent)
  Rails.application.configure do
    config.view_component.preview_paths = [Rails.root.join("test/components/previews")]
    config.view_component.show_previews = true
  end
end
