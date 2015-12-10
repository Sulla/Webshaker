# coding: utf-8

class JobsController < ApplicationController
  
  before_filter :set_menu
  
  def index
    @jobs = Job.limit(100)
    
    if params[:job_type_id] == '0'
      cookies[:job_type_id] = nil
      params[:job_type_id] = nil
    end
    
    if params[:job_category_id] == '0'
      cookies[:job_category_id] = nil
      params[:job_category_id] = nil
    end
    
    if cookies[:job_type_id].present? && params[:job_type_id].nil?
      job_types = cookies[:job_type_id].split('_')
    end
    
    if params[:job_type_id].present?
      job_types = params[:job_type_id].split('_')
      cookies[:job_type_id] = { :value => params[:job_type_id], :expires => 1.year.from_now }
    end
    
    if job_types.present?
      @jobs = @jobs.where(:job_type_id => job_types) if params[:job_type_id].present?
    end
    
    if cookies[:job_category_id].present? && params[:job_category_id].nil?
      job_categories = cookies[:job_category_id].split('_')
    end
    
    if params[:job_category_id].present?
      job_categories = params[:job_category_id].split('_')
      cookies[:job_category_id] = { :value => params[:job_category_id], :expires => 1.year.from_now }
    end
    
    if job_categories.present?
      @jobs = Job.find_by_sql(["SELECT jobs.* from jobs, job_categories_jobs WHERE jobs.id = job_categories_jobs.job_id AND job_categories_jobs.job_category_id IN (?)", job_categories])
    end
    
    puts "jobs count #{@jobs.count}"
    
    respond_to do |format|
      format.html
      format.json do 
        html = render_to_string :partial => 'jobs/jobs.html.erb', :locals => { :jobs => @jobs } 
        render :json => {
         :html => html
        }, :layout => nil
      end
    end
  end
  
  def map
    @jobs = Job.all
  end
  
  private
  
  def set_menu
    @current_menu = 'jobs'
  end
  
end