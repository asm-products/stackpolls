class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :survey, index: true
      t.string :token
      t.string :email
      t.string :name

      t.timestamps
    end
    add_index :invites, :token
    add_index :invites, :email
  end
end
