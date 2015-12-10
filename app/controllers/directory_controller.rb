# coding: utf-8

class DirectoryController < ApplicationController
  
  def index
    session[:sort_param] = 'Random' unless session[:sort_param].present?
    
    @page = params[:page].to_i
    @page = 0 if @page.blank?
    
    if session[:sort_param] == 'Random'
      @companies = Company.send(:with_exclusive_scope) { Company.with_users.order(Company.get_random_sql).limit(12) }
    elsif session[:sort_param] == 'Alphabet'
      @companies = Company.with_users.order(:name).limit(12)
    elsif session[:sort_param] == 'City'
      @companies = Company.with_users.order("IF(ISNULL(city),1,0),city").limit(12)
    elsif session[:sort_param] == 'Most liked'
      @companies = Company.with_users_ordered_by_likes(12)
    end
      
    @users = @companies

    @current_menu = 'directory'
  end
  
  def search
    if params[:sort_param].present?
      session[:sort_param] = params[:sort_param]
    end
    
    @page = params[:page].to_i
    @page = 0 if @page.blank?
    @params = params
    
    if session[:sort_param] != 'Random'
      @params[:treated_ids] = nil
    else
      params[:page] = 0
    end
    
    if params[:role_id] == '5'
      @users = search_by_company
    elsif params[:role_id] == '0'
      @users = search_all
    else
      @users = search_user(params)
    end
    
    respond_to do |format|
      format.html do
        render 'index'
      end
      format.json do 
        content = render_to_string :partial => 'list.html.erb', :locals => { :users => @users }        
        render :json => { 
          :html => content, 
          :size => @users.size,
          :treated_ids => @users.map(&:clean_id).join('_')
        }
      end
    end
  end
  
  def map
    @companies = Company.where(:validated => true).where(Company.arel_table[:lat].not_eq(nil)).all
    @freelances = User.where(:role_id => 3).where(User.arel_table[:lat].not_eq(nil)).all
    @current_menu = 'directory'
  end
  
  private
  
  def search_user(params)
    users = nil
    
    like = "%#{params[:name_filter]}%"
    
    if params[:role_id] == "0"
      users = User.order(:lastname).offset(params[:page].to_i * 12).limit(12)
    elsif params[:role_id] == "3"
      if session[:sort_param] == 'Most liked'
        if params[:name_filter].present?
          users = User.ordered_by_likes_freelance(12, 3, @params[:page].to_i * 12, "freelance_name LIKE '#{like}' OR job_title LIKE '#{like}'")
        else
          users = User.ordered_by_likes(12, 3, @params[:page].to_i * 12)
        end
      else
        users = User.where(:role_id => params[:role_id]).offset(params[:page].to_i * 12).limit(12)
        if params[:name_filter].present?
          users = users.where(["freelance_name LIKE ? OR job_title LIKE ?", like, like])
        end
        
        if session[:sort_param] == 'Random'
          users = users.order(Company.get_random_sql)
        elsif session[:sort_param] == 'Alphabet'
          users = users.order(:freelance_name)
        else
          users = users.order("IF(ISNULL(city),1,0),city")
        end        
        
        
        users = users.where(:directory => true)
      end
    else
      if session[:sort_param] == 'Most liked'
        if params[:name_filter].present?
          users = User.ordered_by_likes(12, params[:role_id], @params[:page].to_i * 12, like)
        else
          users = User.ordered_by_likes(12, params[:role_id], @params[:page].to_i * 12)
        end
      else
        relation = User.where(:role_id => params[:role_id])
        
        if session[:sort_param] == 'Random'
          relation = relation.order(Company.get_random_sql)
        elsif session[:sort_param] == 'Alphabet'
          relation = relation.order("lastname, firstname")
        else
          relation = relation.order("lastname, firstname")
        end        
        
        users = relation.offset(params[:page].to_i * 12).limit(12)
        if params[:name_filter].present?
          users = users.where(["lastname LIKE ? OR firstname LIKE ? OR job_title LIKE ?", like, like, like])
        end
        
        users = users.where(:directory => true)
      end
    end
    
    if @params[:treated_ids].present?
      treated_ids = @params[:treated_ids].split("_")
      treated_ids_int = []
      treated_ids.each do |i|
        treated_ids_int << i.to_i
      end

      arel = User.arel_table
      users = users.where(arel[:id].not_in(treated_ids_int))
    end
    
    users
  end
  
  def search_all
    users = search_by_company
    users << search_user
    users = users.flatten
    
    users
  end
  
  def search_by_company
    if session[:sort_param] == 'Most liked'
      if @params[:name_filter].present?
        users = Company.with_users_ordered_by_likes(12, @params[:page].to_i * 12, "%#{@params[:name_filter]}%")
      else
        users = Company.with_users_ordered_by_likes(12, @params[:page].to_i * 12)
      end
    else
      relation = nil
      
      if session[:sort_param] == 'Random'
        relation = Company.send(:with_exclusive_scope) { Company.with_users(@params[:treated_ids]).order(Company.get_random_sql).limit(12) }
      elsif session[:sort_param] == 'Alphabet'
        relation = Company.send(:with_exclusive_scope) { Company.with_users(@params[:treated_ids]).order(:name).limit(12) }
      else
        relation = Company.send(:with_exclusive_scope) { Company.with_users(@params[:treated_ids]).order("IF(ISNULL(city),1,0),city").limit(12) }
      end
      
      users = relation.offset(@params[:page].to_i * 12).limit(12)
      
      if @params[:name_filter]
        users = users.where(["name LIKE ? OR city LIKE ?", "%#{@params[:name_filter]}%", "%#{@params[:name_filter]}%"])
      end
    end
    users
  end
  
end