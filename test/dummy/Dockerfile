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

# Build the TypeScript Stimulus package so the dummy app consumes the same
# compiled bundle and declarations that npm/importmap users receive.
RUN npm ci && npm run build

# Now set up the dummy app
WORKDIR /rails

# Copy dummy app
COPY test/dummy/ .

# The dummy app's host symlink is relative to test/dummy, but Docker copies
# the app to /rails. Repoint it at the gem CSS tree copied above.
RUN rm -f app/assets/tailwind/shadcn && \
    ln -s /shadcn-rails/app/assets/stylesheets/shadcn app/assets/tailwind/shadcn

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

# Install npm dependencies and build JavaScript from the source dummy app so
# package.json's relative aliases resolve to /shadcn-rails/dist in Docker.
RUN npm ci --prefix /shadcn-rails/test/dummy && \
    npm run build --prefix /shadcn-rails/test/dummy && \
    mkdir -p app/assets/builds && \
    cp -R /shadcn-rails/test/dummy/app/assets/builds/. app/assets/builds/

# Precompile assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Create non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails /shadcn-rails
USER rails:rails

# Start the server
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
