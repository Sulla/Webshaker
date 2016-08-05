# coding: utf-8

class PostsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new, :submit, :create]
  before_filter :set_menu
  
  def index
    session[:who] = 'all' unless session[:who].present?
    session[:who] = params[:who] if params[:who].present?
    
    @page = params[:page].to_i
    @page = 0 if @page.blank?
    
    if session[:who].blank? || session[:who] == 'all'
      ids = Post.find_by_sql("SELECT p.* FROM posts p, users u WHERE p.user_id = u.id AND u.role_id = 1 AND p.post_type_id = 2").map(&:id)
      if ids.size > 0
        post = Post.arel_table
        @posts = Post.where(post[:id].not_in(ids)).offset(@page * 10).limit(10).order('created_at desc')      
      else
        @posts = Post.offset(@page * 10).limit(10).order('created_at desc')      
      end
    else
      ids = []
      if current_user
        profiles = current_user.bookmarks.where(:bookmarkable_type => 'Profile').map(&:bookmarkable_id)
        ids = Profile.find(profiles).map(&:user_id)
      end
      @posts = Post.where(:user_id => ids).offset(@page * 10).limit(10).order('created_at desc')      
    end
    
    if params[:post_type_id] == '0'
      cookies[:post_type_id] = nil
      params[:post_type_id] = nil
    end
    
    if cookies[:post_type_id].present? && params[:post_type_id].nil?
      @posts = @posts.where(:post_type_id => cookies[:post_type_id].split('_'))
    end
    
    if params[:post_type_id].present?
      @posts = @posts.where(:post_type_id => params[:post_type_id].split('_'))
      cookies[:post_type_id] = { :value => params[:post_type_id], :expires => 1.year.from_now }
    end
    
    @posts.all
    
    respond_to do |format|
      format.html
      format.json do 
        html = render_to_string :partial => 'posts/posts.html.erb', :locals => { :posts => @posts } 
        render :json => {
         :html => html, :size => @posts.size
        }, :layout => nil
      end
    end
  end
  
  def submit
    @post = Post.new
    
    if current_user.is_student?
      @post.post_type_id = 3
    else
      @post.post_type_id = 1
    end
  end
  
  def new
    render :partial => 'posts/forms/form', :locals => { :post => Post.new, :post_type_id => params[:post_type_id].to_i }
  end
  
  def create
    @post = Post.create_from_type(params, current_user)
    
    if @post.associated_data_valid?
      if current_user.is_admin?
        @post.create_activity
        Alert.notify(@post)
      else
        Notifier.new_post(@post).deliver
      end
    
      redirect_to "/profiles/posts", :notice => "Thanks for your post, we will validate it as soon as possible"
    else
      render 'submit'
    end
  end
  
  def edit
    @post = Post.send(:with_exclusive_scope) { Post.where(:user_id => current_user.id, :id => params[:id]).first }
    @post.unsaved_associated_model = @post.associated_model
  end
  
  def update
    @post = Post.send(:with_exclusive_scope) { Post.where(:user_id => current_user.id, :id => params[:id]).first }
    if @post.update_from_type(params, current_user)
      if params[:repost] == 'true'
        @post.refused_at = nil
        @post.save
        redirect_to "/profiles/posts", :notice => "Your post has been re-submitted, it will be validated soon!"
      else
        redirect_to @post, :notice => "Your post has successfully been updated"
      end
    else
      render 'edit'
    end
  end
  
  def show
    @post = Post.send(:with_exclusive_scope) { Post.find(params[:id]) }
    if !@post.validated && @post.user != current_user
      @post = Post.find(params[:id])
    end
    @current_menu = 'jobs' if @post.post_type_id == 4   
  end
  
  def top
  end
  
  def visibility
    @post = Post.send(:with_exclusive_scope) { Post.where(:user_id => current_user.id, :id => params[:id]).first }
    
    if @post.online
      @post.update_attribute(:online, false)
    else
      @post.update_attribute(:online, true)      
    end 
    
    render :json => { :validated => "#{@post.online}" }
  end
  
  private
  
  def set_menu
    @current_menu = 'shaker'
  end
  
end