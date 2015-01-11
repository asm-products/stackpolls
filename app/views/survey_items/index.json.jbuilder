json.array!(@survey_items) do |survey_item|
  json.extract! survey_item, :id, :survey_id, :headline, :description, :thumbnail_url
  json.url polymorphic_url([survey_item.survey, survey_item], format: :json)
end
