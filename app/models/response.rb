class Response < ActiveRecord::Base
  belongs_to :survey
  belongs_to :invite
  belongs_to :user
  has_many :item_ranks
  
  validates :survey, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, scope: :survey_id }
  validates :name, presence: true
  
  accepts_nested_attributes_for :item_ranks
  
  # FIXME TODO seems like a bug within rails to have to call this from the controller
  def fixme_hack_ensure_item_ranks_belong_to_me
    self.item_ranks.each { |ir| if ir.response.nil? then ir.response = self end }
  end
  
  def autofill_name_and_email_from_invite(template_invite = self.invite)
    self.name  = template_invite.name  if self.name.blank?
    self.email = template_invite.email if self.email.blank?
  end
  
  def autofill_user_name_and_email_from_user(usr)
    self.user  = usr       if self.user.blank?
    self.name  = usr.name  if self.name.blank?
    self.email = usr.email if self.email.blank?
  end
  
  def build_item_ranks_from_survey_if_needed
    return false if self.item_ranks.any? || self.survey.blank?
    
    self.survey.survey_items.shuffle.each_with_index do |survey_item, idx|
      self.item_ranks.build(survey_item: survey_item, rank: idx)
    end
  end
  
  
end
