module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        wrap_parameters false  # Desabilita a criação do param "session"
        respond_to :json

        def create
          user_params = params.require(:user).permit(:email, :password)
          user = User.find_by(email: user_params[:email])

          if user&.valid_password?(user_params[:password])
            warden.set_user(user, scope: :api_v1_user)

            token = request.env["warden-jwt_auth.token"]

            unless token
              token, _ = Warden::JWTAuth::UserEncoder.new.call(user, :api_v1_user, nil)
            end

            render json: { user: user, token: token }, status: :ok
          else
            render json: { error: "Email ou senha inválidos" }, status: :unauthorized
          end
        end

        private

        def respond_with(resource, _opts = {})
          render json: {
            user: resource,
            token: request.env["warden-jwt_auth.token"]
          }, status: :ok
        end

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end
