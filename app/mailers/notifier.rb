# coding: utf-8

class Notifier < ActionMailer::Base
  default :from => "info@webshaker.be"
  
  def new_comment(user, comment)
    @user    = user    
    @comment = comment
    mail :to => user.email, :subject => "WebShaker - New comment on the post : #{comment.commentable.title}"
  end
  
  def new_post(post)
    @post = post
    mail :to => 'info@webshaker.be', :subject => "WebShaker - Nouveau post à valider"
  end
  
  def accept_post(post)
    @post = post
    mail :to => post.user.email, :subject => "WebShaker - Your post has been accepted"    
  end
  
  def refuse_post(post, message)
    @post = post
    @message = message
    mail :to => post.user.email, :subject => "WebShaker - Your post has been refused"
  end
  
  def invite_admin(email, company)
    @company = company
    mail :to => email, :subject => "WebShaker - Be the admin of your company on WebShaker"
  end

  def check_admin(email, company)
    @company = company
    @email = email
    mail :to => 'info@webshaker.be', :subject => "WebShaker - Check admin"
  end
  
  def new_worker_request(email, company, worker)
    @company = company
    @email = email
    @worker = worker
    mail :to => @email, :subject => "WebShaker - New employee request"    
  end
  
  def accept_worker(worker)
    @worker = worker
    mail :to => @worker.user.email, :subject => "WebShaker - Company request accepted"
  end
  
  def refuse_worker(worker)
    @worker = worker
    mail :to => @worker.user.email, :subject => "WebShaker - Company request refused"
  end
  
  def new_admin(worker)
    @worker = worker
    @company = worker.company
    mail :to => @worker.user.email, :subject => "WebShaker - Your are now admin of #{@company.name}"    
  end
  
  def new_admin_request(worker)
    @worker = worker
    @company = worker.company
    mail :to => @company.admin.email, :subject => "WebShaker - New admin request"
  end
  
  def invitation(current_user, email)
    @user = current_user
    mail :to => email, :subject => "Join #{@user.company.name} on WebShaker!"    
  end
  
  def new_article(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new article"
  end
  
  def new_event(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new event"
  end
  
  def new_project(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new project"
  end
  
  def new_job(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new job"
  end
  
  def new_interview(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new interview"
  end
  
  def new_bookmark(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new bookmark"
  end
  
  def new_like(user, model)
    @item = model
    mail :to => user.email, :subject => "Notification : new like"
  end
end
