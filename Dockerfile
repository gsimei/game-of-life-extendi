# syntax=docker/dockerfile:1

# ====== Base Stage ========
FROM ruby:3.3.6-slim AS base

# Declare the ARG after the FROM so the base stage can access it
ARG RAILS_ENV=development

# Set the working directory
WORKDIR /rails

# Set environment variables
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT=""

# Conditional for production
RUN if [ "$RAILS_ENV" = "production" ]; then \
      export BUNDLE_WITHOUT="development"; \
    fi

RUN apt-get update -qq && \
apt-get install --no-install-recommends -y \
  curl libjemalloc2 libvips postgresql-client git build-essential libpq-dev pkg-config && \
rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy dependency files
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# ====== Development Stage ========
FROM base AS development

# Set environment variables specific to development
ENV RAILS_ENV=development

# Copy application code
COPY . .

# Command for development
CMD ["bin/dev"]

# ====== Production Stage ========
FROM base AS production

# Set environment variables specific to production
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development"

# Copy application code
COPY . .

# Precompile assets
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ====== Final Stage ========
FROM production AS final

# Set appropriate permissions
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER 1000:1000

# Expose Rails and YARD server ports
EXPOSE 3000 8808

# Execution command based on the environment
CMD ["bash", "-c", "if [ \"$RAILS_ENV\" = \"production\" ]; then \
      ./bin/thrust ./bin/rails server -b 0.0.0.0 -p ${PORT:-3000}; \
    else \
      rm -f tmp/pids/server.pid && bundle exec yard server --host 0.0.0.0 --port 8808 & bin/dev; \
    fi"]
