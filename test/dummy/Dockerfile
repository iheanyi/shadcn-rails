# Dockerfile for shadcn-rails documentation site
# Build from repo root: docker build -f test/dummy/Dockerfile -t shadcn-rails-docs .

FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libsqlite3-dev \
    libyaml-dev \
    nodejs \
    npm \
    curl \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set working directory for the gem
WORKDIR /shadcn-rails

# Copy the entire gem first
COPY . .

# Now set up the dummy app
WORKDIR /rails

# Copy dummy app
COPY test/dummy/ .

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Update Gemfile to use the gem path in container and reinstall
RUN sed -i 's|path: "../.."|path: "/shadcn-rails"|' Gemfile && \
    rm -f Gemfile.lock && \
    bundle config set frozen false && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Install npm dependencies and build JavaScript with esbuild
# Note: The esbuild alias in package.json uses relative path ../../app/assets/javascripts/shadcn/index.js
# which works locally but in Docker we need to use the absolute gem path.
# NODE_PATH helps esbuild find @hotwired/stimulus when bundling files from /shadcn-rails/
RUN npm ci && \
    NODE_PATH=/rails/node_modules npx esbuild app/javascript/application.js --bundle --sourcemap \
    --outdir=app/assets/builds --public-path=/assets --loader:.js=jsx \
    --alias:shadcn-rails=/shadcn-rails/app/assets/javascripts/shadcn/index.js

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Create non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails /shadcn-rails
USER rails:rails

# Start the server
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
