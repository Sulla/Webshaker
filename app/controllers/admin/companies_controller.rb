# coding: utf-8

class Admin::CompaniesController < Admin::AdminController
  before_filter :set_menu
  
  def index
    @companies = Company.order(:name)
  end
  
  def show
    @company = Company.find(params[:id])
  end
  
  def edit
    @company = Company.find(params[:id])
    @requests = @company.work_requests
    @link_types = LinkType.all
    @links = @company.links
    render '/companies/edit.html.erb'
  end
  
  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      @company.set_coordinates      
      redirect_to @company, notice => t('companies.updated')
    else
      render '/companies/edit.html.erb'
    end
  end
  
  def destroy
    Company.destroy(params[:id])
    head :ok
  end
  
  def visibility
    @company = Company.find(params[:id])
    
    if @company.validated
      @company.update_attribute(:validated, false)
    else
      @company.update_attribute(:validated, true)      
    end 
    
    render :json => { :validated => "#{@company.validated}" }
  end
  
  private
  
  def set_menu
    @current_menu = 'companies'
  end
end