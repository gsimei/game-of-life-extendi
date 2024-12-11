class DropVersionsTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :versions
  end

  def down
    create_table :versions, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string :whodunnit
      t.datetime :created_at
      t.string :item_id, null: false
      t.string :item_type, null: false
      t.string :event, null: false
      t.text :object
      t.text :object_changes
      t.index [ :item_type, :item_id ], name: "index_versions_on_item_type_and_item_id"
    end
  end
end
