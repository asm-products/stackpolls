json.array!(@invites) do |invite|
  json.extract! invite, :id, :survey_id, :token, :email, :name
  json.url invite_url(invite, format: :json)
end
