## GameStatesController manages the CRUD operations for game states.
# It includes actions to create, show, update, and delete game states,
# as well as progressing to the next generation and resetting to the initial state.
class GameStatesController < ApplicationController
  before_action :set_game_state, only: %i[ show next_generation destroy reset_to_initial ]

  # GET /game_states
  # Lists all game states for the current user, ordered by creation date.
  # Redirects to the new game state path if the user has no game states.
  def index
    return redirect_to new_game_state_path unless current_user.game_states.any?

    @game_states = current_user.game_states.order(created_at: :desc)
  end

  # GET /game_states/:id
  # Shows a specific game state.
  def show; end

  # GET /game_states/new
  # Initializes a new game state.
  def new
    @game_state = GameState.new
  end

  # POST /game_states
  # Creates a new game state for the current user.
  # Redirects to the game state if successful, otherwise redirects to the new game state path.
  def create
    @game_state = current_user.game_states.new(game_state_params)
    return handle_creation_error(@game_state) unless @game_state.save

    handle_successful_creation(@game_state)
  end

  # PATCH /game_states/:id/next_generation
  # Progresses the game state to the next generation.
  # Renders the updated game state or redirects with an error message if unsuccessful.
  def next_generation
    @game_state.next_generation!

    flash.now[:notice] = "Game State progressed to generation: #{@game_state.generation}"
    render :update_game_state, formats: :turbo_stream
  rescue => e
    flash[:alert] = "Could not update generation: #{e.message}"
    redirect_to @game_state
  end

  # PATCH /game_states/:id/reset_to_initial
  # Resets the game state to its initial state.
  # Renders the updated game state or returns an error message if unsuccessful.
  def reset_to_initial
    unless @game_state.restore_initial_state!
      flash.now[:alert] = "Could not restore initial state"
      return render :update_game_state, formats: :turbo_stream
    end

    flash.now[:notice] = "Game State restored to initial state"
    render :update_game_state, formats: :turbo_stream
  end
  # DELETE /game_states/:id
  # Deletes a specific game state.
  # Redirects to the game states index with a success message.
  def destroy
    @game_state.destroy
    flash[:notice] = "Game State deleted successfully!"
    redirect_to game_states_path
  end

  private

  # Sets the game state for actions that require a specific game state.
  def set_game_state
    @game_state = current_user.game_states.find(params[:id])
  end

  # Handles successful creation of a game state.
  # Redirects to the created game state with a success message.
  def handle_successful_creation(game_state)
    flash[:notice] = "Game State created successfully!"
    redirect_to game_state
  end

  # Handles errors during the creation of a game state.
  # Redirects to the new game state path with an error message.
  def handle_creation_error(game_state)
    flash[:alert] = "Error saving GameState: #{game_state.errors.full_messages.join(', ')}"
    redirect_to new_game_state_path
  end

  # Permits only the allowed parameters for game state creation.
  def game_state_params
    params.require(:game_state).permit(:input_file)
  end
end
