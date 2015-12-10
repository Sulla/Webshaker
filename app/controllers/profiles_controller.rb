# coding: utf-8

class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_data, :only => [:edit, :update]
  
  def edit
    
  end
  
  def update
    saved = false
    
    if params[:profile]
      saved = update_profile params
    end
    
    if params[:user]
      saved = update_user(params) && saved
    end
    
    if saved
      redirect_to 'http://vps.webinti.com/webshaker/profiles/1/edit', :notice => t('profiles.updated')
    else
      render 'profiles/edit'
    end
  end
  
  def show
    @profile = Profile.find(params[:id])
    @current_menu = 'directory'
    
    if @profile.user.is_student?
      @posts = @profile.user.posts.where(:post_type_id => [1,3])
    else
      @posts = @profile.user.posts
    end
  end
  
  def submit
    @user = current_user
    if request.post?
      @post = Post.create_from_type(params, current_user)

      if @post.associated_data_valid?
        @post.create_activity
        @post.validated = true
        @post.save

        redirect_to "http://vps.webinti.com/webshaker/profiles/#{@post.user.profile.id}", :notice => "Your project has successfully been added to your portfolio!"
      else
        render 'submit'
      end
    else
      @post = Post.new
      @post.post_type_id = 2
    end
  end
  
  def upload_avatar
    current_user.avatar = params[:user][:avatar]
    current_user.save
    redirect_to profile_path(current_user.profile), :notice => t('profiles.updated')
  end
  
  def reset_avatar
    current_user.avatar.destroy 
    current_user.update_attribute(:avatar_file_name, '')
    redirect_to edit_profile_url(current_user.profile), :notice => t('profiles.updated')    
  end
  
  def posts
    if current_user.is_student?
      @posts = Post.send(:with_exclusive_scope) { Post.where(:user_id => current_user.id, :post_type_id => [1,3]).order('created_at desc') }
    else
      @posts = Post.send(:with_exclusive_scope) { Post.where(:user_id => current_user.id).order('created_at desc') }
    end
  end
  
  def project
    @post = Post.find(params[:project])
    @current_menu = 'jobs' if @post.post_type_id == 4
    render 'http://vps.webinti.com/webshaker/posts/show'
  end
  
  private
  
  def update_user(params)
  	if params[:user][:avatar]
  		@user.avatar = params[:user][:avatar]
  	end
  
    @user.update_attributes(params[:user])
    
    @user.save
  end
  
  def update_profile(params)
    @profile.update_attributes(params[:profile])
  end
  
  def find_data
    @user = current_user
    @profile = current_user.profile
    @link_types = LinkType.all
    @links = @profile.links
  end
  
end