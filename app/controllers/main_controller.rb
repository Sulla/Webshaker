# coding: utf-8

class MainController < ApplicationController
  
  skip_before_filter :check_beta, :only => [:beta]
  
  def index
  end
  def about
  end
  def faq
  end
  def benjamin
  end
	def privacy
  end
  def terms
  end
  def advertise
  end
  
  def welcome
  end
  
  def feed
    @posts = []
    ids = Post.find_by_sql("SELECT p.* FROM posts p, users u WHERE p.user_id = u.id AND u.role_id = 1 AND p.post_type_id = 2").map(&:id)
    if ids.size > 0
      post = Post.arel_table
      @posts = Post.where(post[:id].not_in(ids)).limit(30).order('created_at desc')      
    else
      @posts = Post.limit(10).order('created_at desc')      
    end
  end
  
  def beta
    if params[:code].present? && params[:email].present?
      exists = Code.where(:code => params[:code], :email => params[:email])
      if exists.size == 1
        session[:beta] = 'go'
        cookies[:beta] = { :value => params[:code], :expires => 1.year.from_now }
        redirect_to root_url
      else
        cookies[:beta] = nil
        redirect_to '/beta', :error => "Invalid code!"
      end
    else
      render :layout => nil
    end
  end
end
