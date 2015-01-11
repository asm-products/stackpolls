class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :survey, index: true
      t.references :invite, index: true
      t.references :user, index: true
      t.string :email
      t.string :name
      t.text :comments

      t.timestamps
    end
    add_index :responses, :email
    add_index :responses, :created_at
  end
end
