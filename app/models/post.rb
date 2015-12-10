# coding: utf-8

class Post < ActiveRecord::Base
  
  has_many :attachments, :dependent => :destroy
  belongs_to :user
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates :title, :presence => true
  validates :content, :presence => true  
  
  default_scope where(:validated => true, :online => true)
  
  scope :projects, where(:post_type_id => 2)
  
  before_destroy :remove_bookmarks
  
  attr_accessor :unsaved_associated_model
  
  def self.create_from_type(params, user)
    post = Post.sample_post(params, user)
    
    case params[:post_type_id]
      # article
      when '1'
        post.unsaved_associated_model = post
        
      # project
      when '2'
        project = Project.create(:post_id => post.id)
        project.url = params[:url]
        project.save
        
        post.unsaved_associated_model = project
      # event
      when '3'
        event = Event.create(:post_id => post.id, :occurs_on => params[:occurs_on], :link => params[:link], :registration => params[:registration], :access => params[:access], :street => params[:street], :zipcode => params[:zipcode], :city => params[:city])
        if event.valid?
          event.set_coordinates
        end
        post.unsaved_associated_model = event
        
      # job
      when '4'
        company_id = user.company_admin.id rescue nil
        job = Job.create(:post_id => post.id, :job_type_id => params[:job_type_id], :company_id => company_id, :skills => params[:skills], :how_to_apply => params[:how_to_apply], :location => params[:location])
        
        if params[:job_category]
          params[:job_category].each do |cat|
            job.job_categories << JobCategory.find(cat)
          end
        end
        
        job.save
        
        post.unsaved_associated_model = job
      
      #interview
      when '5'
        interview = Interview.create(:post_id => post.id, :movie_url => params[:movie_url])
        post.unsaved_associated_model = interview
    end
    
    if user.is_admin?
      post.validated = true
      post.accepted_at = Time.now
    end
    
    if post.unsaved_associated_model.valid? && post.valid?
      post.save
      if post.unsaved_associated_model.respond_to?(:post_id=)
        post.unsaved_associated_model.post_id = post.id
        post.unsaved_associated_model.save
      end
      
      if post.is_project?
        Attachment.attach_to_post(post)
      end
    end
    
    post
  end
  
  def update_from_type(params, user)
    self.title = params[:title]
    self.content = params[:content]    
    
    case params[:post_type_id]
      # article
      when '1'
        return save
        
      # project
      when '2'
        project = self.project
        project.url = params[:url]
        
        return save && project.save
        
      # event
      when '3'
        event = self.event
        event.occurs_on = params[:occurs_on]
        event.link = params[:link]
        event.registration = params[:registration]
        event.access = params[:access]
        event.street = params[:street]
        event.zipcode = params[:zipcode]
        event.city = params[:city]
        
        if event.valid?
          event.set_coordinates
        end
        
        return save && event.save
        
      # job
      when '4'
        job = self.job
        job.job_type_id = params[:job_type_id]
        job.skills = params[:skills]
        job.how_to_apply = params[:how_to_apply]
        job.location = params[:location]        
        
        job.job_categories.delete_all
        
        if params[:job_category]
          params[:job_category].each do |cat|
            job.job_categories << JobCategory.find(cat)
          end
        end
        
        return save && job.save
    
      # interview
      when '5'
        interview = self.interview
        interview.movie_url = params[:movie_url]
        
        return save && interview.save
    end
  end
  
  def self.sample_post(params, user)
    post = Post.new
    post.post_type_id = params[:post_type_id]
    post.title = params[:title]
    post.content = params[:content]
    post.validated = false
    post.user_id = user.id
    post
  end
  
  def is_event?
    post_type_id == 3
  end
  
  def is_article?
    post_type_id == 1
  end
  
  def is_project?
    post_type_id == 2
  end
  
  def is_job?
    post_type_id == 4
  end
  
  def is_interview?
    post_type_id == 5
  end
  
  def summary
    summary_with_word(25)
  end
  
  def summary_with_word(nb_word)
    HTML_Truncator.truncate(self.content, nb_word)
  end
  
  def project
    project = Project.where(:post_id => self.id).first
    project.nil? ? Project.new : project
  end
  
  def event
    event = Event.where(:post_id => self.id).first    
    event.nil? ? Event.new : event
  end
  
  def job
    job = Job.where(:post_id => self.id).first    
    job.nil? ? Job.new : job
  end
  
  def interview
    interview = Interview.where(:post_id => self.id).first    
    interview.nil? ? Interview.new : interview
  end  
  
  def associated_model
    if is_event?
      event
    elsif is_article?
      self
    elsif is_project?
      project
    elsif is_job?
      job
    elsif is_interview?
      interview
    end
  end
  
  def likes
    Like.where(:likable_id => self.id, :likable_type => 'Post').count
  end
  
  def self.search(keywords)
    keywords = "%#{keywords}%"
    where(["post_type_id != 4 AND (title LIKE ? OR content LIKE ?)", keywords, keywords])
  end
  
  def type_label

    case self.post_type_id
      # article
      when 1
        return "Article"
        
      # project
      when 2
        return "Project"
        
      # event
      when 3
        return "Event"
        
      # job
      when 4
        return "Job"
        
      # interview
      when 5
        return "Interview"
    end
  end
  
  def get_status
    if validated
      ["Online", "valided"]
    elsif refused_at.present?
      ["Refused", "refused"]
    else
      ["Pending", "pending"]
    end
  end
  
  def associated_data_valid?
    return false if !self.valid?
    associated_model.valid?
  end
  
  def id
    i = read_attribute(:id)
    
    if i && self.title
      "#{read_attribute(:id)}-#{self.title.gsub(' ','-').gsub('?','').gsub('!','').gsub('é','e').gsub('è','e').gsub('ê','e').gsub('ù','u').gsub('à','a').gsub('ç','c').gsub('\'','').gsub('"','').gsub('î','').gsub('ô','').gsub('û','').gsub('ü','').gsub('ë','').gsub('ï','').gsub('(','').gsub(')','').gsub('€','').gsub('$','').gsub('*','').gsub(',','').gsub('.','').gsub('/','').gsub('+','').gsub('@','').gsub('&','').gsub('§','').gsub('%','').gsub('£','').gsub(';','').gsub(':','').gsub('#','')}".downcase
    end
  end
  
  def create_activity
    Activity.create(:noticeable_type => 'Post', :noticeable_id => self.id, :from_user_id => self.user_id)
  end
  
  def remove_bookmarks
    Bookmark.where(:bookmarkable_type => 'Post', :bookmarkable_id => self.id).delete_all
    Like.where(:likable_type => 'Post', :likable_id => self.id).delete_all
  end
  
  def self.top(limit = nil)
    limit = "LIMIT #{limit}" if limit
    ids = Post.find_by_sql("SELECT p.* FROM posts p, users u WHERE p.user_id = u.id AND u.role_id = 1 AND p.post_type_id = 2").map(&:id).join(',')
    find_by_sql(["SELECT p.*, count(likes.id) as total FROM posts p, likes WHERE p.id = likes.likable_id AND p.validated = ? AND p.id NOT IN(?) AND likes.likable_type = 'Post' GROUP BY likes.likable_id ORDER BY total DESC #{limit}", true, ids])
  end
  
end



# == Schema Information
#
# Table name: posts
#
#  id           :integer(4)      not null, primary key
#  title        :string(255)
#  content      :text
#  post_type_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer(4)
#  validated    :boolean(1)      default(FALSE)
#  accepted_at  :datetime
#

