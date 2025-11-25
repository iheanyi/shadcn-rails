# frozen_string_literal: true

# Autoload component paths
Rails.application.config.autoload_paths << Rails.root.join("app/components")
Rails.application.config.eager_load_paths << Rails.root.join("app/components")
