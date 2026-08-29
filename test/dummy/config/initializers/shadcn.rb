# frozen_string_literal: true

Shadcn::Rails.configure do |config|
  config.style = "default"
  config.theme = :neutral
  config.radius = "0.5rem"
  config.css_variables = true
  config.dark_mode = :media  # Automatically respect system preferences
  config.tailwind_prefix = ""
end
