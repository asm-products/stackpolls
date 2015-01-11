class CreateEditors < ActiveRecord::Migration
  def change
    create_table :editors do |t|
      t.references :user, index: true
      t.references :survey, index: true
      t.string :email
      t.references :inviter, index: true
      t.timestamp :accepted_at

      t.timestamps
    end
    add_index :editors, :accepted_at
    add_index :editors, :created_at
    add_index :editors, :email
    add_index :editors, [:email, :accepted_at]
  end
end
