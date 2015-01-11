class CreateSurveyItems < ActiveRecord::Migration
  def change
    create_table :survey_items do |t|
      t.references :survey, index: true
      t.string :headline
      t.text :description
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
