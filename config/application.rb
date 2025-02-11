require_relative "boot"

# Carregar apenas os módulos necessários para uma API-only application:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"

# Não carregar view rendering modules, por exemplo:
# require "sprockets/railtie"

Bundler.require(*Rails.groups)

module GameOfLifeExtendi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0
    config.api_only = true

    # Configure CORS to handle cross-origin requests
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "http://localhost:3000" # Modifique de acordo com a URL do seu frontend
        resource "*",
          headers: :any,
          methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
          credentials: true
      end
    end

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Middleware para APIs pode ser necessário, especialmente se estiver usando autenticação
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Outras configurações necessárias para sua aplicação
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
