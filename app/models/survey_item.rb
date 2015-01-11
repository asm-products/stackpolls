class SurveyItem < ActiveRecord::Base
  belongs_to :survey
  
  validates :survey, presence: true
  validates :headline, presence: true
  
  def rank_score_1x_normalized
    (self.survey.survey_items.count * self.survey.responses.count) - self.rank_score_1x
  end
  
  def rank_score_1x
    @rank_score_1x ||= begin
      running_score = 0
      any_responses = false
      self.survey.responses.each do |response|
        response_item_rank = response.item_ranks.where(survey_item_id: self.id).first
        if response_item_rank
          any_responses = true
          running_score += response_item_rank.rank + 1
        end
      end
      
      any_responses ? running_score : nil 
    end
  end
  
  def rank_mean
    @rank_mean ||= begin
      ranks_sorted_array.inject{ |sum, el| sum + el }.to_f / ranks_sorted_array.size
    end
  end
  
  def rank_median
    @rank_median ||= begin
      len = ranks_sorted_array.length
      (ranks_sorted_array[(len - 1) / 2] + ranks_sorted_array[len / 2]) / 2.0
    end
  end

  
  def rank_mode
    @rank_mode ||= begin
      ranks_sorted_array.max_by { |v| ranks_frequency_hash[v] }
    end
  end
  
  # http://stackoverflow.com/a/412177/370800
  def ranks_frequency_hash
    @ranks_frequency_hash ||= begin
      ranks_sorted_array.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    end
  end
  
  def ranks_sorted_array
    @ranks_sorted_array ||= begin
      collected = []
      self.survey.responses.each do |response|
        response_item_rank = response.item_ranks.where(survey_item_id: self.id).first
        if response_item_rank
          collected << (response_item_rank.rank + 1)
        end
      end
      collected.sort
    end
  end
  
  def rank_score_2x_normalized
    (self.survey.survey_items.count * 2 * self.survey.responses.count) - self.rank_score_2x
  end
  
  def rank_score_2x
    @rank_score_2x ||= begin
      running_score = 0
      any_responses = false
      self.survey.responses.each do |response|
        response_item_rank = response.item_ranks.where(survey_item_id: self.id).first
        if response_item_rank
          any_responses = true
          running_score += 2 * (response_item_rank.rank + 1)
        end
      end
      
      any_responses ? running_score : nil 
    end
  end
end
