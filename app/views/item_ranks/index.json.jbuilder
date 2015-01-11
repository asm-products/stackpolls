json.array!(@item_ranks) do |item_rank|
  json.extract! item_rank, :id, :response_id, :survey_item_id, :rank
  json.url item_rank_url(item_rank, format: :json)
end
