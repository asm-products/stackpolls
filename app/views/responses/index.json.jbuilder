json.array!(@responses) do |response|
  json.extract! response, :id, :survey_id, :invite_id, :email, :name, :comments
  json.url response_url(response, format: :json)
end
