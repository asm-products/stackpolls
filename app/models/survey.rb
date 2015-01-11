class Survey < ActiveRecord::Base
  belongs_to :user
  has_many :survey_items
  has_many :invites
  has_many :editors
  has_many :responses
  
  validates :permalink, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true
  
  before_validation :autofill_permalink_if_blank
  
  # Can this user edit this survey
  def user_can_edit?(user)
    return false unless user
    return false if user.id.blank? # ignore new records
    
    return true if user.superuser # supers can do anything!
    return !self.editors.where(user_id: user.id).first.nil?
  end  
  
  # Can this user respond to this survey
  def user_can_respond?(user)
    return false unless user
    return false if user.id.blank? # ignore new records
    
    return true if user.superuser # supers can do anything!
    return !self.editors.where(user_id: user.id).first.nil? # editors can, even without invites
  end 
  
  # Can this invite respond to this survey
  def invitetoken_can_respond?(invitetoken)
    return false if invitetoken.blank? # need a token!
    return !self.invites.where(token: invitetoken).first.nil?
  end 

  # Override to send permalink as params[:id]
  def to_param
    permalink
  end
  
  def autofill_permalink_if_blank
    # Bypass if permalink is already set
    return true unless self.permalink.blank?
    
    self.permalink = self.class.cleaned_deduped_permalink(self.title)
  end
  
  
  def self.default_thanks_headline
    "Thanks for taking the survey!"
  end
  
  def self.default_thanks_subheader
    "Your response has been recorded and we have notified the author of the survey."
  end
  
  def self.cleaned_permalink(str)
    # Not especially nice, but other things (like PermalinkFu plugin and iconv
    # in general) didn't work properly (some chars were incorrectly converted to
    # '-'
    permalink = str.dup.downcase
    permalink = permalink.strip
    permalink.gsub!(/[\/\.\:\@]/, " ")
    permalink.gsub!(/[àáâãäåāăÀÁÂÃÄÅĀĂ]/, 'a')
    permalink.gsub!(/æÆ/, 'ae')
    permalink.gsub!(/[ďđĎĐ]/, 'd')
    permalink.gsub!(/[çćčĉċÇĆČĈĊ]/, 'c')
    permalink.gsub!(/[èéêëēęěĕėÈÉÊËĒĘĚĔĖ]/, 'e')
    permalink.gsub!(/ƒƑ/, 'f')
    permalink.gsub!(/[ĝğġģĜĞĠĢ]/, 'g')
    permalink.gsub!(/[ĥħĤĦ]/, 'h')
    permalink.gsub!(/[ììíîïīĩĭÌÌÍÎÏĪĨĬ]/, 'i')
    permalink.gsub!(/[įıĳĵĮIĲĴ]/, 'j')
    permalink.gsub!(/[ķĸĶĸ]/, 'k')
    permalink.gsub!(/[łľĺļŀŁĽĹĻĿ]/, 'l')
    permalink.gsub!(/[ñńňņŉŋÑŃŇŅŉŊ]/, 'n')
    permalink.gsub!(/[òóôõöøōőŏŏÒÓÔÕÖØŌŐŎŎ]/, 'o')
    permalink.gsub!(/œŒ/, 'oe')
    permalink.gsub!(/ąĄ/, 'q')
    permalink.gsub!(/[ŕřŗŔŘŖ]/, 'r')
    permalink.gsub!(/[śšşŝșŚŠŞŜȘ]/, 's')
    permalink.gsub!(/[ťţŧțŤŢŦȚ]/, 't')
    permalink.gsub!(/[ùúûüūůűŭũųÙÚÛÜŪŮŰŬŨŲ]/, 'u')
    permalink.gsub!(/ŵŴ/, 'w')
    permalink.gsub!(/[ýÿŷÝŸŶ]/, 'y')
    permalink.gsub!(/[žżźŽŻŹ]/, 'z')
    permalink.gsub!(/[^a-z0-9_-]/i, '-')
    permalink.gsub!(/_+/, '_')
    permalink.gsub!(/ +/, '-')
    permalink.gsub!(/^-+/, '')
    permalink.gsub!(/-+/, '-')
    permalink
  end
  
  # Autofix duplication of permalinks
  def self.cleaned_deduped_permalink(candidate_permalink)
    candidate_permalink = cleaned_permalink(candidate_permalink)
    n = where(permalink: candidate_permalink).count

    if n > 0
      links = where(["permalink LIKE ?", "#{candidate_permalink}%"]).order(:id)

      number = 0

      links.each_with_index do |link, index|
        if link.permalink =~ /#{candidate_permalink}-\d*\.?\d+?$/
          new_number = link.permalink.match(/-(\d*\.?\d+?)$/)[1].to_i
          number = new_number if new_number > number
        end
      end
      return resolve_duplication(candidate_permalink, number + 1)
    else
      return candidate_permalink
    end
  end

  def self.resolve_duplication(permalink, number)
    "#{permalink}-#{number}"
  end
end
