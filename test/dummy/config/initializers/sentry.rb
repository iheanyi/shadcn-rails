# frozen_string_literal: true

dsn = ENV["SENTRY_DSN"].presence

if dsn.present?
  Sentry.init do |config|
    config.dsn = dsn
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.send_default_pii = false # public docs site
    config.traces_sample_rate = 0.2
    config.environment = Rails.env
  end
end
