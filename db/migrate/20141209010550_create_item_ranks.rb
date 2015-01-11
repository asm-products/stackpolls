class CreateItemRanks < ActiveRecord::Migration
  def change
    create_table :item_ranks do |t|
      t.references :response, index: true
      t.references :survey_item, index: true
      t.integer :rank

      t.timestamps
    end
    add_index :item_ranks, :rank
    add_index :item_ranks, [:response_id, :rank]
  end
end
