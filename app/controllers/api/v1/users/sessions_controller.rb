module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        wrap_parameters false  # Desabilita a criação do param "session"
        respond_to :json

        def create
          Rails.logger.info "🚀 [DEBUG] Iniciando autenticação"
          binding.irb
          authenticated_user = warden.authenticate!(:database_authenticatable, scope: :api_v1_user)
          token = request.env["warden-jwt_auth.token"] || Warden::JWTAuth::UserEncoder.new.call(authenticated_user, :api_v1_user, nil)[0]

          Rails.logger.info "✅ [DEBUG] Usuário autenticado: #{authenticated_user.email}"
          Rails.logger.info "✅ [DEBUG] Token JWT: #{token}"

          render json: { user: authenticated_user, token: token }, status: :ok
        end

        private

        def respond_with(resource, _opts = {})
          token = request.env["warden-jwt_auth.token"]
          render json: {
            user: resource,
            token: token
          }, status: :ok
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end
