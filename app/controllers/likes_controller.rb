# coding: utf-8

class LikesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show]
  
  def index
    @likes = current_user.likes
  end
  
  def create
    unless current_user
      render :status => :forbidden and return
    end
    
    exists = Like.where(:user_id => current_user.id, :likable_id => params[:id], :likable_type => params[:type]).first
    if exists.nil?
      like = Like.create do |l|
        l.user_id = current_user.id
        l.likable_id = params[:id]
        l.likable_type = params[:type]
      end
      Activity.create(:noticeable_type => 'Like', :noticeable_id => like.id, :from_user_id => current_user.id, :to_user_id => like.try(:ressource_owner).try(:id))
      #Alert.notify(like)
    else
      a = Activity.where(:noticeable_type => 'Like', :noticeable_id => exists.id, :from_user_id => current_user.id, :to_user_id => exists.try(:ressource_owner).try(:id)).first
      a.destroy if a
      exists.destroy
    end
    head :ok
  end
  
  def show
    @likes = Like.where(:likable_id => params[:id], :likable_type => params[:type])
  end
  
end