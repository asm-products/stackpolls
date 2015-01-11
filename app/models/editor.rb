class Editor < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :inviter, class_name: "User"
  
  attr_accessor :accepted, :editing_user
  
  before_validation :change_editing_user_to_user_if_accepted
  before_validation :change_accepted_to_accepted_at
  
  validates :survey, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, scope: :survey_id }
  validates :user, uniqueness: { scope: :survey_id, allow_blank: true }
  
  def change_editing_user_to_user_if_accepted
    return true if !self.user.blank?
    
    if self.accepted && self.editing_user
      self.user = self.editing_user
    end
    
    return true
  end
  
  def change_accepted_to_accepted_at
    return true if !self.accepted_at.blank?
    
    if self.accepted
      self.accepted_at = Time.now
    end
    
    true
  end
  
  def to_param
    self.email.gsub(/\./, "%2E")
  end
end
