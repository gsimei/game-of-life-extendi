class GameStatesController < ApplicationController
  before_action :set_game_state, only: %i[ show next_generation destroy reset_to_initial ]

  def index
    @game_states = current_user.game_states.order(created_at: :desc)
  end

  def show; end

  def new
    @game_state = GameState.new
  end

  def create
    @game_state = current_user.game_states.new(game_state_params)
    return handle_creation_error(@game_state) unless @game_state.save

    handle_successful_creation(@game_state)
  end

  def next_generation
    @game_state.next_generation!
    redirect_to @game_state, notice: "Game State progressed to generation #{@game_state.generation}"
  rescue => e
    flash[:alert] = "Could not update generation: #{e.message}"
    redirect_to @game_state
  end

  def reset_to_initial
    if @game_state.restore_initial_state!
      flash[:notice] = "Game state has been reset to its initial version."
    else
      flash[:alert] = "Failed to reset game state."
    end
    redirect_to @game_state
  end

  def destroy
    @game_state.destroy
    flash[:notice] = "Game State deleted successfully!"
    redirect_to game_states_path
  end

  private

  def set_game_state
    @game_state = current_user.game_states.find(params[:id])
  end

  def handle_successful_creation(game_state)
    flash[:notice] = "Game State created successfully!"
    redirect_to game_state
  end

  def handle_creation_error(game_state)
    flash[:alert] = "Error saving GameState: #{game_state.errors.full_messages.join(', ')}"
    redirect_to new_game_state_path
  end

  def game_state_params
    params.require(:game_state).permit(:input_file)
  end
end
