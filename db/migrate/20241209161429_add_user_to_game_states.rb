class AddUserToGameStates < ActiveRecord::Migration[8.0]
  def change
    add_reference :game_states, :user, null: false, foreign_key: true
  end
end
