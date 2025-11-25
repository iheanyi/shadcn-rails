# frozen_string_literal: true

# ViewComponent configuration
Rails.application.config.view_component.preview_paths << Rails.root.join("test/components/previews")
Rails.application.config.view_component.show_previews = true
