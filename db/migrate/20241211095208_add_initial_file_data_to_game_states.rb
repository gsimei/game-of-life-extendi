class AddInitialFileDataToGameStates < ActiveRecord::Migration[8.0]
  def change
    add_column :game_states, :initial_file_data, :jsonb, default: {}
  end
end
