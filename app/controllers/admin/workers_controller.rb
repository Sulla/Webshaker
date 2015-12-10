# coding: utf-8

class Admin::WorkersController < Admin::AdminController
  before_filter :set_menu
    
  def index
    @workers = Worker.where(:validated => false).order(:created_at)
  end
  
  def create
    worker = Worker.find(params[:id])
    worker.update_attribute(:validated, true)    
    Notifier.accept_worker(worker).deliver
    head :ok
  end
  
  def destroy
    worker = Worker.find(params[:id])
    Notifier.refuse_worker(worker).deliver
    worker.destroy
    head :ok
  end
  
  private
  
  def set_menu
    @current_menu = 'workers'
  end
end