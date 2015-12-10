# coding: utf-8

class Admin::AdminController < ActionController::Base
  layout 'admin'
  
  before_filter :authenticate_user!
  before_filter :require_admin!
  
  private
  
  def require_admin!
    render :file => "#{Rails.root}/public/404.html", :layout => nil and return unless current_user.is_admin?
  end
  
end
