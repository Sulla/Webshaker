# coding: utf-8

class Admin::CommentsController < Admin::AdminController
  before_filter :set_menu
  
  def index
    @comments = Comment.order('id desc')
  end
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to [:admin, @comment], :notice => "The comment has been successfully updated"
    else
      render 'edit'
    end
  end
  
  def destroy
    Comment.destroy(params[:id])
    head :ok
  end
  
  private
  
  def set_menu
    @current_menu = 'comments'
  end

end