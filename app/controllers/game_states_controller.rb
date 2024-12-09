class GameStatesController < ApplicationController
  before_action :set_game_state, only: [ :show ]

  def index
    @game_states = current_user.game_states.order(created_at: :desc)
  end

  def show; end

  def new_upload; end

  def create_from_file
    @game_state = current_user.game_states.new(input_file: params[:input_file])
    return handle_creation_error(@game_state) unless @game_state.save

    handle_successful_creation(@game_state)
  end

  private

  def set_game_state
    @game_state = current_user.game_states.find(params[:id])
  end

  def handle_successful_creation(game_state)
    flash[:notice] = "Game State created successfully!"
    redirect_to game_state_path(game_state)
  end

  def handle_creation_error(game_state)
    flash[:alert] = "Error saving GameState: #{game_state.errors.full_messages.join(', ')}"
    redirect_to new_upload_game_states_path
  end
end
