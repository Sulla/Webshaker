# coding: utf-8

class Comment < ActiveRecord::Base
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  after_create :send_notifications
  
  def title
    if commentable
      if commentable_type == 'Post'
        commentable.title 
      else
        ""
      end
    end
  end
  
  private
  
  def send_notifications
    comments = Comment.find_by_sql("SELECT DISTINCT user_id FROM comments WHERE commentable_id = #{self.commentable_id} AND commentable_type = '#{self.commentable_type}' AND notification = 1 AND user_id != #{self.id}")
    users = User.find(comments.collect(&:user_id))
    users.each do |user|
      Notifier.new_comment(user, self).deliver if user.id != self.user.id
    end
  end
  
end


# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  content          :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  notification     :boolean(1)      default(FALSE)
#

