json.array!(@surveys) do |survey|
  json.extract! survey, :id, :user_id, :permalink, :title, :headline, :subheader, :thanks_headline, :thanks_subheader, :thanks_continue_url, :invite_required
  json.url survey_url(survey, format: :json)
end
