# coding: utf-8

class CommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    comment = Comment.new
    comment.user = current_user
    comment.content = params[:content]
    comment.notification = params[:notification]    
    comment.commentable_type = 'Post'
    comment.commentable_id = params[:post_id]
    comment.save
    
    Alert.notify(comment)
    
    render :partial => 'comments/comment', :locals => { :comment => comment }
  end
  
end