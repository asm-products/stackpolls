class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :googleid
      t.string :name
      t.string :email
      t.string :picurl
      t.boolean :superuser

      t.timestamps
    end
    add_index :users, :googleid
    add_index :users, :email
    add_index :users, :superuser
  end
end
