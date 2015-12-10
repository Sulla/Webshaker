class Alert < ActiveRecord::Base
  
  belongs_to :user
  
  def self.notify(item)
    if item.class == Post
      model = ''
      if item.is_article?
        model = 'Article'
      elsif item.is_event?
        model = 'Event'
      elsif item.is_project?
        model = 'Project'
      elsif item.is_job?
        model = 'Job'
      elsif item.is_interview?
        model = 'Interview'
      end
      
      Mailing.create(:model => model, :resource_id => item.id)
      system "ruby #{Rails.root}/script/rails runner #{Rails.root}/script/send_mailing.rb &"
    elsif item.class == Bookmark
      if item.bookmarkable_type == 'Profile'
        u = Profile.find(item.bookmarkable_id).user
        alert = Alert.where(:model => 'Bookmark', :user_id => u.id).first
        if alert
          Notifier.new_bookmark(u, item).deliver
        end
      end
    elsif item.class == Like
      if item.likable_type == 'Profile'
        u = Profile.find(item.likable_id).user
        alert = Alert.where(:model => 'Like', :user_id => u.id).first
        if alert
          Notifier.new_like(u, item).deliver
        end
      end
    elsif item.class == Comment
      if item.commentable_type == 'Post'
        post = Post.find(item.commentable_id)
        alert = Alert.where(:model => 'Comment', :user_id => post.user.id).first
        if alert
          Notifier.new_comment(post.user, item).deliver if item.user != post.user
        end
      end
    end
  end
  
end
