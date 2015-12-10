# coding: utf-8

class ActivitiesController < ApplicationController
  
  def index
    @activities = current_user.my_activities(1000)
  end
  
end