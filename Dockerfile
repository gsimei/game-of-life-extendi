# syntax=docker/dockerfile:1

# ================== Base Image =====================
FROM ruby:3.3.6-slim-bullseye AS base

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_PATH="/usr/local/bundle"

WORKDIR /rails

# 1. Forçar uso de HTTPS nos repositórios (corrige erro de assinaturas GPG)
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates && \
    sed -i "s/http:\/\/deb.debian.org/https:\/\/deb.debian.org/g" /etc/apt/sources.list && \
    sed -i "s/http:\/\/security.debian.org/https:\/\/security.debian.org/g" /etc/apt/sources.list && \
    apt-get update -qq

# 2. Instalar dependências do sistema
RUN apt-get install --no-install-recommends -y \
    curl build-essential libpq-dev git && \
    rm -rf /var/lib/apt/lists/*

# 3. Copiamos Gemfile e Gemfile.lock antes (para aproveitar cache)
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 4. Copiamos o restante do código
COPY . .

# ================== Desenvolvimento =====================
FROM base AS development
ENV RAILS_ENV=development

EXPOSE 3000

# Comando para ambiente de desenvolvimento
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bin/rails db:create db:migrate && bin/rails s -b 0.0.0.0 -p 3000"]

# ================== Produção =====================
FROM base AS production
ENV RAILS_ENV=production

# (API-only: não há assets para precompilar, mas se precisar, habilite abaixo)
# RUN SECRET_KEY_BASE=DUMMY_KEY bin/rails assets:precompile

# Expor a porta
EXPOSE 3000

# Se quiser criar um usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/sh && \
    chown -R rails:rails /rails

USER 1000:1000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bin/rails db:migrate && bin/rails s -b 0.0.0.0 -p ${PORT:-3000}"]
