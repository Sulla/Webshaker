# coding: utf-8

class Admin::SchoolsController < Admin::AdminController
  before_filter :set_menu
  
  def index
    @schools = School.order(:name)
  end
  
  def show
    @school = School.find(params[:id])
  end
  
  def visibility
    @school = School.find(params[:id])
    
    if @school.validated
      @school.update_attribute(:validated, false)
    else
      @school.update_attribute(:validated, true)      
    end 
    
    render :json => { :validated => "#{@school.validated}" }
  end
  
  private
  
  def set_menu
    @current_menu = 'schools'
  end
end