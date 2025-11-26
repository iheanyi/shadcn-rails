# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.active_support.deprecation = :log

  # Enable reloading of code in development
  config.enable_reloading = true

  # Explicitly disable template caching for faster development iteration
  config.action_view.cache_template_loading = false

  # ViewComponent configuration
  config.view_component.generate.preview = true
  config.view_component.show_previews = true
  config.view_component.preview_route = "/rails/view_components"

  # Hotwire Livereload - watch parent gem's components directory and docs
  if defined?(Hotwire::Livereload)
    config.hotwire_livereload.listen_paths << Rails.root.join("../../app/components")
    config.hotwire_livereload.listen_paths << Rails.root.join("app/views/docs")
    config.hotwire_livereload.listen_paths << Rails.root.join("app/code_examples")
  end
end
