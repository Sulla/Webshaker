# coding: utf-8

class Admin::CodesController < Admin::AdminController
  before_filter :set_menu
    
  def index
    @codes = Code.all
  end
  
  def new
    s = ""
    6.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    
    @code = Code.new(:code => s)
  end
  
  def create
    @code = Code.new(params[:code])
    
    if @code.save
      redirect_to admin_codes_url, :notice => "Le code a été créé avec succès!"
    else
      render 'new'
    end
  end
  
  def destroy
    Code.find(params[:id]).destroy
    head :ok
  end
  
  private
  
  def set_menu
    @current_menu = 'codes'
  end
end