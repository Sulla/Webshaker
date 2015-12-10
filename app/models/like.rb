# coding: utf-8

class Like < ActiveRecord::Base
  
  belongs_to :likable, :polymorphic => true
  belongs_to :user
  
  def ressource_owner
    if likable.respond_to?(:user)
      likable.user
    else
      nil
    end
  end
  
  def title
    if likable_type == 'Post'
      likable.try(:title)
    elsif likable_type == 'Company'
      likable.try(:name)
    elsif likable_type == 'Profile'
      likable.try(:user).try(:fullname)
    end
  end

  def link
    path = ""
    if likable_type == 'Post'
      path += "/posts/"
    elsif likable_type == 'Company'
      path += "/companies/"
    elsif likable_type == 'Profile'
      path += '/profiles/'
    end
    
    path += "#{self.likable_id}"
  end
  
end

# == Schema Information
#
# Table name: likes
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  likable_id   :integer(4)
#  likable_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

