class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.references :user, index: true
      t.string :title
      t.string :permalink
      t.string :headline
      t.text :subheader
      t.string :thanks_headline
      t.text :thanks_subheader
      t.string :thanks_continue_url
      t.boolean :invite_required

      t.timestamps
    end
    add_index :surveys, :permalink
    add_index :surveys, :invite_required
    add_index :surveys, :created_at
    add_index :surveys, :updated_at
  end
end
