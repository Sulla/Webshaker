# coding: utf-8

class ApplicationController < ActionController::Base
  
  before_filter :check_beta  
  before_filter :count_users
  
  private
  
  def check_beta
    #if Rails.env == 'production'
    #  if session[:beta].blank? || session[:beta] != 'go'
    #    if cookies[:beta].blank?
    #      redirect_to '/beta'
    #    end
    #  end
    #end
  end
  
  def count_users
    @nb_students = User.students.count
    @nb_employees = User.employees.count
    @nb_others = User.others.count
    @nb_freelances = User.freelances.count
    @nb_companies = Company.with_users.count
    
    if current_user
      @activities = current_user.my_activities    
    end
    
    @current_menu = ''
  end
  
end
