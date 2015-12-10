# coding: utf-8

class Admin::UsersController < Admin::AdminController
  before_filter :set_menu
    
  def index
    @users = User.order('id desc')
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
    @profile = @user.profile
    @link_types = LinkType.all
    @links = @profile.links
    #render '/profiles/edit.html.erb'
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to [:admin, @user], :notice => "Saved"
    else
      render 'edit'
    end      
  end
  
  def destroy
    User.destroy(params[:id])
    head :ok
  end
  
  private
  
  def set_menu
    @current_menu = 'users'
  end
end