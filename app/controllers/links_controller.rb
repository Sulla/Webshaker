# coding: utf-8

class LinksController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    link = Link.create_for_linkable(params, current_user)
    render :json => { :id => link.id, :type_icon => link.link_type.icon, :type_name => link.link_type.name }
  end
  
  def update
    link = Link.update_for_linkable(params, current_user)
    render :json => { 
      :id => link.id, 
      :name => link.name, 
      :url => link.url, 
      :type_icon => link.link_type.icon, 
      :type_name => link.link_type.name 
    }
  end
  
  def destroy
    Link.destroy_for_linkable(params, current_user)
    head :ok
  end
  
  def show
    link = Link.find(params[:id])
    render :json => link
  end
  
end