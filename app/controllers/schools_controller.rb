# coding: utf-8

class SchoolsController < ApplicationController
  
  def create
    if params[:name].present?
      school = School.create(:name => params[:name])
      
      if school.valid?
        render :json => { :school_id => school.id, :school_name => school.name } and return
      end
    end
    
    render :json => { :school_id => 0 }
  end
  
end