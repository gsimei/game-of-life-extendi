module Api
  module V1
    class GameStatesController < ApplicationController
      before_action :set_game_state, only: %i[show next_generation destroy reset_to_initial]

      # GET /api/v1/game_states
      def index
        Rails.logger.info "🔍 [DEBUG] Usuário autenticado: #{current_user&.email}"

        Rails.logger.info "Cabeçalho Authorization: #{request.headers['Authorization']}"
        Rails.logger.info "Usuário autenticado: #{current_user.inspect}" # ✅ Deve mostrar um usuário válido agora

        @game_states = current_user.game_states.order(created_at: :desc)
        render json: @game_states
      end

      # GET /api/v1/game_states/:id
      def show
        render json: @game_state
      end

      # POST /api/v1/game_states
      def create
        @game_state = current_api_v1_user.game_states.new(game_state_params)
        if @game_state.save
          render json: @game_state, status: :created, location: api_v1_game_state_path(@game_state)
        else
          render json: @game_state.errors, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/game_states/:id/next_generation
      def next_generation
        if @game_state.next_generation!
          render json: @game_state
        else
          render json: @game_state.errors, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/game_states/:id/reset_to_initial
      def reset_to_initial
        if @game_state.restore_initial_state!
          render json: @game_state
        else
          render json: @game_state.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/game_states/:id
      def destroy
        @game_state.destroy
        head :no_content
      end

      private

      def set_game_state
        @game_state = GameState.find(params[:id])
      end

      def game_state_params
        params.require(:game_state).permit(:input_file)
      end
    end
  end
end
