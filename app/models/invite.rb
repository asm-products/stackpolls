class Invite < ActiveRecord::Base
  belongs_to :survey
  has_one :response
  
  before_validation :generate_token_if_necessary
  
  validates :survey, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false, scope: :survey_id }
  validates :token, presence: true, uniqueness: { case_sensitive: false }
  
  def generate_token_if_necessary
    return unless self.token.blank?
    self.token = loop do
      token = SecureRandom.urlsafe_base64
      break token unless Invite.exists?(token: token)
    end
  end
  
  def to_param
    self.token
  end
end
