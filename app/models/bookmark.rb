# coding: utf-8

class Bookmark < ActiveRecord::Base
  
    belongs_to :bookmarkable, :polymorphic => true
    belongs_to :user
    
    def ressource_owner
      if bookmarkable.respond_to?(:user)
        bookmarkable.user
      else
        nil
      end
    end
    
    def title
      if bookmarkable_type == 'Post'
        bookmarkable.title
      elsif bookmarkable_type == 'Company'
        bookmarkable.name
      elsif bookmarkable_type == 'Profile'
        bookmarkable.user.fullname
      end
    end
  
    def link
      path = ""
      if bookmarkable_type == 'Post'
        path += "/posts/"
      elsif bookmarkable_type == 'Company'
        path += "/companies/"
      elsif bookmarkable_type == 'Profile'
        path += "/profiles/"
      end
      
      path += "#{self.bookmarkable_id}"
    end
end

# == Schema Information
#
# Table name: bookmarks
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  bookmarkable_id   :integer(4)
#  bookmarkable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

