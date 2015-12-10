# coding: utf-8

class WorkersController < ApplicationController
  
  before_filter :authenticate_user!  
  before_filter :check_admin, :except => [:create, :admin_request]
  
  def create
    worker = Worker.where(:user_id => current_user.id, :company_id => params[:company_id]).first
    if !worker
      worker = Worker.create(:user_id => current_user.id, :company_id => params[:company_id])
    end
    redirect_to worker.company, :notice => t('workers.request')
  end
  
  def update
    admin = false
    admin = true if params[:worker][:admin] == 'checked'
    
    if admin
      Activity.create(:noticeable_type => 'Admin', :noticeable_id => @worker.company_id, :from_user_id => @worker.user_id)
      Notifier.new_admin(@worker).deliver
    end
    
    @worker.admin = admin
    @worker.save
    head :ok
  end
  
  def destroy
    @worker.destroy if @worker.removable
    head :ok    
  end
  
  def accept
    @worker.update_attribute(:validated, true)
    Notifier.accept_worker(@worker).deliver
    render :json => { :worker_id => @worker.id, :id => @worker.user.id, :name => @worker.user.fullname, :title => @worker.title }
  end
  
  def refuse
    Notifier.refuse_worker(@worker).deliver    
    @worker.destroy
    head :ok
  end
  
  def admin_request
    worker = Worker.where(:company_id => params[:company_id], :user_id => current_user.id).first
    if worker
      if worker.company.admin
        begin
          Notifier.new_admin_request(worker).deliver
        rescue
          logger.info "Unable to send check_admin email"
        end
        
        redirect_to worker.company, :notice => "You request has been sended and will be validated soon!"
      else
        worker.admin = true
        worker.validated = false
        worker.save
      
        begin
          Notifier.check_admin(worker.user.email, worker.company).deliver
        rescue
          logger.info "Unable to send check_admin email"
        end
      
        redirect_to worker.company, :notice => "You can now admin this company, your request will be validated soon!"
      end
    else
      redirect_to company
    end
  end
  
  private
  
  def check_admin
    @worker = Worker.find(params[:id]) 
    redirect_to root_url unless current_user.can_admin_company?(@worker.company_id)
  end
  
end