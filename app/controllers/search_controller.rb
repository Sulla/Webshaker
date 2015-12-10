# coding: utf-8

class SearchController < ApplicationController
  
  def index
    if params[:keywords].present? && params[:keywords].size > 1
      @users = User.search(params[:keywords])
      @workers = Worker.search(params[:keywords])
      @users = [@users, @workers.map(&:user)].flatten
      @companies = Company.search(params[:keywords])    
      @posts = Post.search(params[:keywords])
      @jobs = Job.search(params[:keywords])
    end
    
    respond_to do |format|
      format.html
      format.json do 
        html = render_to_string :partial => 'search/live.html.erb'
        render :json => {
         :html => html
        }, :layout => nil
      end
    end
  end
  
  def advanced
    
  end
  
end