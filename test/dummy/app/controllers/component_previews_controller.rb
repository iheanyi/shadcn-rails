# frozen_string_literal: true

# Only define this controller if ViewComponent::PreviewsController is available (development/test only)
if defined?(ViewComponent::PreviewsController)
  class ComponentPreviewsController < ViewComponent::PreviewsController
    layout "component_preview"
  end
end
