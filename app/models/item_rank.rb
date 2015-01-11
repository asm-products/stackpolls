class ItemRank < ActiveRecord::Base
  belongs_to :response
  belongs_to :survey_item
  
  validates :survey_item, presence: true, uniqueness: { scope: :response_id }
  validates :response, presence: true
  validates :rank, presence: true, uniqueness: { scope: :response_id }, numericality: { only_integer: true }
  
end
