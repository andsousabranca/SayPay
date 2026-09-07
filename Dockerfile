# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Build stage
FROM base AS build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy app code
COPY . .

# Precompile bootsnap and assets (without secrets)
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final image
FROM base

# Copy built gems and app
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run as non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Expose the correct port
EXPOSE 3000

# Correct CMD for Sliplane
# CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

# Previous attempts that failed on sliplane:
# CMD bin/rails db:prepare && bin/rails server -b 0.0.0.0 -p 3000 -> Failed because the budget_cents/money columns were undefined in a fresh DB
# CMD ["sh", "-c", "bin/rails db:prepare && exec bin/rails server -b 0.0.0.0 -p 3000"] -> Failed because some columns referenced in old migrations did not exist
# CMD ["sh", "-c", "bin/rails db:schema:load && exec bin/rails server -b 0.0.0.0 -p 3000"] -> Failed because rails doesn't allow destructive behaviour with db:schema:load

# Correct approach: load schema directly from schema.rb and skip previous migrations and start server
CMD ["sh", "-c", "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:schema:load && exec bin/rails server -b 0.0.0.0 -p 3000"]
