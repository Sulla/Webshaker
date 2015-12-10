# coding: utf-8


class Admin::PostsController < Admin::AdminController
  before_filter :set_menu
    
  def index
    ids = Post.find_by_sql("SELECT p.* FROM posts p, users u WHERE p.user_id = u.id AND u.role_id = 1 AND p.post_type_id = 2").map(&:id)
    post = Post.arel_table
    if ids.size > 0
      @posts = Post.send(:with_exclusive_scope) { Post.where(post[:id].not_in(ids)) }
    else
      @posts = Post.send(:with_exclusive_scope) { Post.limit(1000) }
    end
    @posts = Post.send(:with_exclusive_scope) { @posts.where(:refused_at => nil).order('updated_at desc') }
  end
  
  def show
    @post = Post.send(:with_exclusive_scope) { Post.find(params[:id]) }
  end
  
  def edit
    @post = Post.send(:with_exclusive_scope) { Post.find(params[:id]) }
    @post.unsaved_associated_model = @post.associated_model
  end
  
  def update
    @post = Post.send(:with_exclusive_scope) { Post.find(params[:id]) }
    if @post.update_from_type(params, @post.user)
      redirect_to @post, :notice => "The post has successfully been updated"
    else
      render 'edit'
    end
  end
  
  def destroy
    Post.send(:with_exclusive_scope) { Post.destroy(params[:id]) }
    head :ok
  end
  
  def validate
    @post = Post.send(:with_exclusive_scope) { Post.find(params[:id]) }
    
    if params[:go] == 'accept'
      @post.validated = true
      Notifier.accept_post(@post).deliver
      @post.create_activity
      @post.accepted_at = Time.now      
      @post.created_at = Time.now
      Alert.notify(@post)
    else
      @post.validated = false
      Notifier.refuse_post(@post, params[:message]).deliver      
      @post.refused_at = Time.now
    end
    
    @post.save
    
    render :json => { :validated => "#{@post.validated}", :date => Time.now }
  end
  
  def visibility
    @post = Post.send(:with_exclusive_scope) { Post.find(params[:id]) }
    
    if @post.online
      @post.update_attribute(:online, false)
    else
      @post.update_attribute(:online, true)      
    end 
    
    render :json => { :validated => "#{@post.online}" }
  end
  
  private
  
  def set_menu
    @current_menu = 'posts'
  end
end