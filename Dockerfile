# syntax=docker/dockerfile:1

# ================== Base Image =====================
FROM ruby:3.3.6-slim AS base

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_PATH="/usr/local/bundle"

WORKDIR /rails

# Dependências do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl build-essential libpq-dev git && \
    rm -rf /var/lib/apt/lists/*

# Copiamos Gemfile e Gemfile.lock antes para aproveitar cache
COPY Gemfile Gemfile.lock ./

# Instalamos as gems
RUN bundle install

# Copiamos o restante do código da aplicação
COPY . .

# ================== Desenvolvimento =====================
FROM base AS development
ENV RAILS_ENV=development

# Nesse ponto, se você tiver alguma configuração extra para dev, adicione aqui.
# Por exemplo, instalar o node se estivesse usando webpack, etc.

EXPOSE 3000

# Comando para ambiente de desenvolvimento
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bin/rails db:create db:migrate && bin/rails s -b 0.0.0.0 -p 3000"]

# ================== Produção (opcional) =====================
FROM base AS production
ENV RAILS_ENV=production

# Caso não haja assets em um projeto API-only, você pode ignorar,
# mas se ainda houver qualquer asset ou pré-compilação necessária, insira aqui:
# RUN SECRET_KEY_BASE=DUMMY_KEY bin/rails assets:precompile

# Expondo a porta
EXPOSE 3000

# Se quiser criar um usuário não-root (bom para produção)
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER 1000:1000

CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bin/rails db:migrate && bin/rails s -b 0.0.0.0 -p 3000"]
