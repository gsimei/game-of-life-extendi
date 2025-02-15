module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        # Sobrescreve o método para permitir nome e senha
        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              message: "Cadastro realizado com sucesso!",
              user: resource,
              token: request.env["warden-jwt_auth.token"] # JWT Token para autenticação automática
            }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
