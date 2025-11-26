# frozen_string_literal: true

# Puma configuration for shadcn-rails documentation site

# Specifies the number of `workers` to boot in clustered mode.
workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests.
# Bind to 0.0.0.0 in production for Fly.io
if ENV["RAILS_ENV"] == "production"
  bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}"
else
  port ENV.fetch("PORT") { 3000 }
end

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Run the Puma worker in single-process mode for lower memory in production
# (documentation site doesn't need high concurrency)
if ENV["RAILS_ENV"] == "production"
  workers 0
  threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
  threads threads_count, threads_count
  preload_app!
end
