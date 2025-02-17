# syntax=docker/dockerfile:1

# ================== Base Image =====================
FROM ruby:3.3.6-slim-bullseye AS base

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_PATH="/usr/local/bundle"

WORKDIR /rails

# 1. Force the use of HTTPS in repositories (fixes GPG signature error)
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates && \
    sed -i "s/http:\/\/deb.debian.org/https:\/\/deb.debian.org/g" /etc/apt/sources.list && \
    sed -i "s/http:\/\/security.debian.org/https:\/\/security.debian.org/g" /etc/apt/sources.list && \
    apt-get update -qq

# 2. Install system dependencies
RUN apt-get install --no-install-recommends -y \
    curl build-essential libpq-dev git && \
    rm -rf /var/lib/apt/lists/*

# 3. Copy Gemfile and Gemfile.lock first (to reuse cache)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 4. Copy the remaining code
COPY . .

# ================== Development =====================
FROM base AS development
ENV RAILS_ENV=development

EXPOSE 3000

# Command for the development environment
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bin/rails db:create db:migrate && bin/rails s -b 0.0.0.0 -p 3000"]

# ================== Production =====================
FROM base AS production
ENV RAILS_ENV=production

# (API-only: no assets to precompile, but if needed, enable below)
# RUN SECRET_KEY_BASE=DUMMY_KEY bin/rails assets:precompile

# Expose port
EXPOSE 3000

# If you want to create a non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/sh && \
    chown -R rails:rails /rails

USER 1000:1000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bin/rails db:migrate && bin/rails s -b 0.0.0.0 -p ${PORT:-3000}"]
