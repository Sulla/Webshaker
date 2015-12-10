# coding: utf-8

class Profile < ActiveRecord::Base
  
  belongs_to :user
  has_many :links, :as => :linkable
  
  def likes
    Like.where(:likable_id => self.id, :likable_type => 'Profile').count
  end
  
  def id
    i = read_attribute(:id)
    
    if i && self.user && self.user.fullname.present?
      "#{read_attribute(:id)}-#{self.user.fullname.gsub(' ','-').gsub('?','').gsub('!','').gsub('é','e').gsub('è','e').gsub('ê','e').gsub('ù','u').gsub('à','a').gsub('ç','c').gsub('\'','').gsub('"','').gsub('î','').gsub('ô','').gsub('û','').gsub('ü','').gsub('ë','').gsub('ï','').gsub('(','').gsub(')','').gsub('€','').gsub('$','').gsub('*','').gsub(',','').gsub('.','').gsub('/','').gsub('+','').gsub('@','').gsub('&','').gsub('§','').gsub('%','').gsub('£','').gsub(';','').gsub(':','')}".downcase
    end
  end
  
end

# == Schema Information
#
# Table name: profiles
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  summary    :text
#  created_at :datetime
#  updated_at :datetime
#

