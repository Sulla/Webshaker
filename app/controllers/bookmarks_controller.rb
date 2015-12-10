# coding: utf-8

class BookmarksController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @bookmarks = current_user.bookmarks
  end
  
  def create
    unless current_user
      render :status => :forbidden and return
    end
    
    exists = Bookmark.where(:user_id => current_user.id, :bookmarkable_id => params[:id], :bookmarkable_type => params[:type])
    if exists.count == 0
      bookmark = Bookmark.create do |b|
        b.user_id = current_user.id
        b.bookmarkable_id = params[:id]
        b.bookmarkable_type = params[:type]
      end
      Activity.create(:noticeable_type => 'Bookmark', :noticeable_id => bookmark.id, :from_user_id => current_user.id, :to_user_id => bookmark.try(:ressource_owner).try(:id))
      #Alert.notify(bookmark)
    else
      exists = exists.first
      a = Activity.where(:noticeable_type => 'Bookmark', :noticeable_id => exists.id, :from_user_id => current_user.id, :to_user_id => exists.try(:ressource_owner).try(:id)).first
      a.destroy if a
      exists.destroy
    end
    
    head :ok
  end
  
end