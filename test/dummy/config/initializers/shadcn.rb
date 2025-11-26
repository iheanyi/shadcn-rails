# frozen_string_literal: true

Shadcn::Rails.configure do |config|
  config.style = "default"
  config.base_color = "neutral"
  config.css_variables = true
  config.dark_mode = :media  # Automatically respect system preferences
end
