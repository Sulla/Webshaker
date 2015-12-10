# coding: utf-8

class CompaniesController < ApplicationController
  
  #before_filter :check_owner, :only => [:new, :create]
  before_filter :authenticate_user!, :only => [:edit, :update, :reset_avatar, :employees]
  before_filter :check_admin, :only => [:edit, :update, :reset_avatar, :employees]
  
  #before_filter :authenticate_user!, :except => [:show]
  
  def new
    @company = Company.new
  end
  
  def create
    if request.xhr?
      if params[:name].present?
        exists = Company.where(:name => params[:name])
        if exists.size == 0
          company = Company.new(:name => params[:name])
          company.save(false)
        
          if params[:owner] == '0' and params[:email].present?
            Notifier.invite_admin(params[:email], company).deliver
          end
        
          render :json => { :company_id => company.id, :company_name => company.name }
        else
          render :json => { :company_id => 0 }
        end
      else
        render :json => { :company_id => 0 }
      end
    else
      @company = Company.new(params[:company])
      
      if @company.save
        @company.set_owner(current_user)
        @company.set_coordinates
        redirect_to @company, :notice => t('companies.created')
      else
        render 'new'
      end
    end
  end
  
  def edit
    @company = Company.find(params[:id])
    @requests = @company.work_requests
    @link_types = LinkType.all
    @links = @company.links
  end
  
  def update
    @company = Company.find(params[:id])    
    @link_types = LinkType.all
    @requests = @company.work_requests
    @links = @company.links
    if @company.update_attributes(params[:company])
      @company.set_coordinates      
      redirect_to @company, :notice => t('companies.updated')
    else
      render 'edit'
    end
  end
  
  def show
    @company = Company.with_users.find(params[:id])
    @current_menu = 'directory'
  end
  
  def top
    if params[:role_id].present?
      @users = User.top(params[:role_id])
    else      
      @companies = Company.top
    end
  end
  
  def reset_avatar
    @company = Company.find(params[:id])
    @company.avatar.destroy 
    @company.update_attribute(:avatar_file_name, '')
    redirect_to edit_company_url(@company), :notice => t('companies.updated')
  end
  
  def has_admin
    @company = Company.find(params[:id])
    
    has_admin = 'false'
    if @company.admins_ids.size == 0
      has_admin = 'true'
    end
    
    render :json => { :has_admin => has_admin }
  end
  
  def employees
    @company = Company.find(params[:id])
    @requests = @company.work_requests
    @link_types = LinkType.all
    @links = @company.links
  end
  
  def invite
    ok = ""
    if params[:email].present?
      if User.where(:email => params[:email]).first
        ok = "This email already exists on WebShaker!"
      else
        Notifier.invitation(current_user, params[:email]).deliver
        ok = "Invitation sent"
      end
    else
      ok = "Please insert a valid email address!"
    end
    render :text => ok
  end
  
  private
  
  def check_owner
    redirect_to root_url unless current_user.can_create_company?
  end
  
  def check_admin
    redirect_to root_url unless current_user.can_admin_company?(params[:id])
  end  
  
end