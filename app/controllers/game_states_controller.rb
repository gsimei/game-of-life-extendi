class GameStatesController < ApplicationController
  before_action :set_game_state, only: [ :show ]
  def index
    @game_states = current_user.game_states.order(created_at: :desc)
  end

  def show; end

  private

  def set_game_state
    @game_state = current_user.game_states.find(params[:id])
  end
end
