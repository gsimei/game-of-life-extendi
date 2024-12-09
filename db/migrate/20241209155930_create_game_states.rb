class CreateGameStates < ActiveRecord::Migration[8.0]
  def change
    create_table :game_states do |t|
      t.integer :generation
      t.integer :rows
      t.integer :cols
      t.jsonb :state

      t.timestamps
    end
  end
end
