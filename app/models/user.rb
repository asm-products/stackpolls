class User < ActiveRecord::Base
  has_many :surveys
  has_many :responses
  has_many :editors
  
  validates :googleid, presence: true, uniqueness: { case_sensitive: false }
  
  def self.create_or_update_user_from_omniauth(omniauth_auth)
    existing_user = User.find_by_googleid(omniauth_auth['uid'])
    if existing_user
      existing_user.update_attributes(
        name: omniauth_auth['info']['name'],
        email: omniauth_auth['info']['email'],
        picurl: omniauth_auth['info']['image']
      )
    else
      existing_user = User.create(
        googleid: omniauth_auth['uid'],
        name: omniauth_auth['info']['name'],
        email: omniauth_auth['info']['email'],
        picurl: omniauth_auth['info']['image']
      )
    end
    existing_user
  end
  
  # Return a survey that's editable, or nil
  def find_editable_survey_from_surveypermalink(surveypermalink)
    owned_survey = self.surveys.where(permalink: surveypermalink).first
    if owned_survey
      return owned_survey
    end
    
    survey = Survey.find_by_permalink(surveypermalink)
    if survey
      editor = self.editors.where(survey_id: survey.id).first
      if editor
        return survey
      end
    end
    
    nil
  end
  
  # Can this user edit this survey
  def can_edit_surveypermalink?(surveypermalink)
    return true if self.superuser # supers can do anything!
    return false if surveypermalink.blank? # ignore blanks
    
    survey = Survey.where(permalink: surveypermalink).first
    return false if survey.nil? # actual survey
    return true if survey.user.id == self.id
    return true if !survey.editors.where(user_id: self.id).first.nil?
  end  
  
end
