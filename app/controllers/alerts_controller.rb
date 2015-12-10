# coding: utf-8

class AlertsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    alert = Alert.where(:user_id => current_user.id, :model => params[:model]).first
    
    if alert
      alert.destroy
    else
      Alert.create(:user_id => current_user.id, :model => params[:model])
    end
    
    head :ok
  end
  
end