# coding: utf-8

class Admin::MainController < Admin::AdminController
  
  def index
  end
  
  def mailing
    @users = User.where(:mailing => true)
    render 'mailing', :layout => nil
  end
  
end
