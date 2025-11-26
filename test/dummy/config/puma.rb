# frozen_string_literal: true

# Puma configuration for shadcn-rails documentation site

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Bind to 0.0.0.0 in production for Fly.io
if ENV["RAILS_ENV"] == "production"
  bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}"
  
  # Single-process mode for lower memory (documentation site doesn't need high concurrency)
  workers 0
  threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
  threads threads_count, threads_count
  preload_app!
else
  # Development settings
  port ENV.fetch("PORT") { 3000 }
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }
  worker_timeout 3600
  
  # Specifies the `pidfile` that Puma will use.
  pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
  
  # Allow puma to be restarted by `bin/rails restart` command.
  plugin :tmp_restart
end
