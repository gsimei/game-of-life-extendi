class AddAlivedCellsCountToGameStates < ActiveRecord::Migration[8.0]
  def change
    add_column :game_states, :alived_cells_count, :integer
  end
end
