json.array!(@editors) do |editor|
  json.extract! editor, :id, :user_id, :survey_id, :email, :inviter_id, :accepted_at
  json.url editor_url(editor, format: :json)
end
