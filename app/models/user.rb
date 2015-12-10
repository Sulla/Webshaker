# coding: utf-8

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :role_id,      :presence => true        
  
  belongs_to :role
  has_many :alerts
  
  validate :company_for_employee, :school_for_student, :name_for_freelance
  
  before_destroy :remove_bookmarks
  
  def company_for_employee
    if self.role_id == 2
      if self.company_id.nil?
        errors.add(:company_id, "cannot be empty!")
      end
      
      if self.firstname.blank?
        errors.add(:firstname, "cannot be empty!")      
      end  
      if self.lastname.blank?
        errors.add(:lastname, "cannot be empty!")      
      end
    end
  end
  
  def school_for_student
    if self.role_id == 1
      if self.school_id.nil?
        errors.add(:schoold_id, "cannot be empty!")
      end
      if self.firstname.blank?
        errors.add(:firstname, "cannot be empty!")      
      end  
      if self.lastname.blank?
        errors.add(:lastname, "cannot be empty!")      
      end
    end
  end
  
  def name_for_freelance
    if self.role_id == 3
      if self.freelance_name.blank?
        errors.add(:freelance_name, "cannot be empty!")      
      end
    end
  end
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :directory, :avatar, :role_id, :freelance_name, :school_id, :company_id, :job_title, :company_admin_request
  attr_protected :admin

  has_one :profile, :dependent => :destroy
  belongs_to :school
  after_create :build_profile
  
  scope :students, where(:role_id => 1).order(:lastname)
  scope :employees, where(:role_id => 2).order(:lastname)
  scope :freelances, where(:role_id => 3).order(:lastname)
  scope :others, where(:role_id => 4).order(:lastname)
  
  has_attached_file :avatar, :styles => { :medium => "300x300#", :thumb => "100x100#" }
  
  has_many :posts, :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  belongs_to :role
  
  def fullname
    if is_freelance?
      self.freelance_name
    else
      "#{firstname} #{lastname}"
    end
  end
  
  def is_admin?
    self.admin
  end
  
  def is_student?
    role_id == 1
  end
  
  def is_employee?
    role_id == 2
  end
  
  def can_join_company?
    return false unless is_employee?
    worker = Worker.where(:user_id => self.id, :validated => true)
    worker.size == 0
  end
  
  def is_freelance?
    role_id == 3
  end
  
  def is_company_owner?
    worker = Worker.where(:user_id => self.id, :admin => true)
    worker.size > 0
  end
  
  
  def is_other?
    role_id == 4
  end
  
  def is_company_admin?
    worker = Worker.where(:user_id => self.id, :admin => true, :validated => true)
    
    if worker.size == 1
      return true
    else
      worker = Worker.where(:user_id => self.id, :admin => true, :validated => false)
      if worker.size == 1
        exists = Worker.where(:company_id => worker.first.company_id, :admin => true, :validated => true)
        if exists.size == 0
          return true
        end
      end
    end
    
    false
  end
  
  def can_admin_company?(company_id)
    worker = Worker.where(:user_id => self.id, :company_id => company_id, :admin => true)
    worker.size == 1
  end
  
  def can_create_company?
    worker = Worker.where(:user_id => self.id, :admin => true, :removable => false)
    worker.size == 0
  end
  
  def company
    worker = Worker.where(:user_id => self.id, :validated => true).first
    worker.nil? ? nil : worker.company
  end
  
  def company_worker
    worker = Worker.where(:user_id => self.id).first
    worker.nil? ? nil : worker.company
  end
  
  def company_admin
    worker = Worker.where(:user_id => self.id, :admin => true, :validated => true).first
    if worker
      worker.company
    else
      worker = Worker.where(:user_id => self.id, :admin => true, :validated => false)
      if worker.size == 1
        exists = Worker.where(:company_id => worker.first.company_id, :admin => true, :validated => true)
        if exists.size == 0
          return worker.first.company
        end
      end
    end
  end
  
  def self.search(keywords)
    keywords = "%#{keywords}%"
    where(["firstname LIKE ? OR lastname LIKE ? OR job_title LIKE ? OR freelance_name LIKE ?", keywords, keywords, keywords, keywords])
  end
  
  def has_liked?(type, id)
    likes.where(:likable_id => id, :likable_type => type).size > 0
  end
  
  def has_bookmarked?(type, id)
    bookmarks.where(:bookmarkable_id => id, :bookmarkable_type => type).size > 0
  end  
  
  def has_permission?(action)
    return true if is_admin?
    
    if is_student?
      [:post_article, :post_event].include?(action)
    elsif is_company_owner? || is_company_admin?
      [:post_article, :post_event, :post_project, :post_job].include?(action)      
    elsif is_employee?
      [:post_article, :post_event].include?(action)
    elsif is_freelance?
      [:post_article, :post_event, :post_project, :post_job].include?(action)
    elsif is_other?
      [:post_article, :post_event].include?(action)      
    end
  end
  
  def count_posts
    Post.send(:with_exclusive_scope) { Post.where(:user_id => self.id).size }
  end
  
  def job_title
    j = read_attribute(:job_title)
    if j.blank?
      if is_company_owner?
        j = "Owner"
        j << " at #{company.name}" if company
      elsif is_student?
        j = "Student"
        j << " at #{school.name}" if school        
      end
    end
    
    return j
  end
  
  def simple_job_title
    read_attribute(:job_title)
  end
  
  def company_admin_request=(val)
    puts val
    if val == 'on'
      write_attribute(:company_admin_request, true)
    end
  end
  
  def my_activities(limit = 3)
    Activity.where(["from_user_id = ? OR to_user_id = ?", self.id, self.id]).order('created_at desc').limit(limit)
  end
  
  def job_where
    str = ""
    if role_id == 1
      if school
        str = "Student at #{school.name}"
      else
        str = "Student"
      end
    elsif role_id == 2
      w = Worker.where(:user_id => self.id).first
      
      if w && w.company
        str = %Q(#{job_title} at <a href="http://vps.webinti.com/webshaker/companies/#{w.company.id}">#{w.company.name}</a>)
      else
        str = "#{job_title}"
      end
    elsif role_id == 3
      str = "#{job_title}"
    elsif role_id == 4
      str = "#{job_title}"
    end
    
    str
  end
  
  def job_where_no_link
    str = ""
    if role_id == 1
      str = "Student at #{school.name}"
    elsif role_id == 2
      w = Worker.where(:user_id => self.id).first
      
      if w && w.company
        str = %Q(#{job_title} at #{w.company.name})
      else
        str = "#{job_title}"
      end
    elsif role_id == 3
      str = "#{job_title}"
    elsif role_id == 4
      str = "#{job_title}"
    end
    
    str
  end
  
  def company_name
    str = ""
    w = Worker.where(:user_id => self.id).first
    if w && w.company
      str = w.company.name
    end
    str
  end
  
  def full_address
    "#{street}, #{zipcode} #{city}, Belgium"
  end
  
  def set_coordinates
    res = Geokit::Geocoders::GoogleGeocoder.geocode(full_address)
    self.lat = res.lat
    self.lng = res.lng
    save
  end
  
  def self.ordered_by_likes(limit, role_id, offset = 0, like = '')
    if like.present?
      find_by_sql(["SELECT u.*, count(likes.id) as total FROM users u, profiles p, likes WHERE u.id = p.user_id AND u.role_id = #{role_id} AND p.id = likes.likable_id AND likes.likable_type = 'Profile' AND(lastname LIKE ? OR firstname LIKE ? OR job_title LIKE ?) GROUP BY likes.likable_id ORDER BY total DESC LIMIT #{limit} OFFSET #{offset}", like, like, like])
    else
      find_by_sql("SELECT u.*, count(likes.id) as total FROM users u, profiles p, likes WHERE u.id = p.user_id AND u.role_id = #{role_id} AND p.id = likes.likable_id AND likes.likable_type = 'Profile' GROUP BY likes.likable_id ORDER BY total DESC LIMIT #{limit} OFFSET #{offset}")      
    end 
  end
  
  def self.ordered_by_likes_freelance(limit, role_id, offset = 0, like = '')
    if like.present?
      find_by_sql(["SELECT u.*, count(likes.id) as total FROM users u, profiles p, likes WHERE u.id = p.user_id AND u.role_id = #{role_id} AND p.id = likes.likable_id AND likes.likable_type = 'Profile' AND(freelance_name LIKE ? OR job_title LIKE ?) GROUP BY likes.likable_id ORDER BY total DESC LIMIT #{limit} OFFSET #{offset}", like, like])
    else
      find_by_sql("SELECT u.*, count(likes.id) as total FROM users u, profiles p, likes WHERE u.id = p.user_id AND u.role_id = #{role_id} AND p.id = likes.likable_id AND likes.likable_type = 'Profile' GROUP BY likes.likable_id ORDER BY total DESC LIMIT #{limit} OFFSET #{offset}")      
    end 
  end
  
  def name
    self.freelance_name
  end
  
  def self.top(role_id, limit = nil)
    limit = "LIMIT #{limit}" if limit
    find_by_sql("SELECT u.*, count(likes.id) as total FROM users u, profiles p, likes WHERE u.id = p.user_id AND p.id = likes.likable_id AND u.role_id = #{role_id} AND likes.likable_type = 'Profile' GROUP BY likes.likable_id ORDER BY total DESC #{limit}")
  end
  
  def has_alert_for?(model)
    alerts.where(:model => model).first.present?
  end
  
  def clean_id
    read_attribute(:id)
  end
  
  private
  
  def build_profile
    self.profile = Profile.create(:user_id => self.id)
    save
    
    if self.company_id
      worker = Worker.where(:user_id => self.id, :company_id => self.company_id).first
      if !worker
        worker = Worker.create(:user_id => self.id, :company_id => self.company_id, :admin => self.company_admin_request)
        
        company = Company.find(self.company_id)
        if company.admin
          Notifier.new_worker_request(company.admin.user.email, company, worker).deliver
        end
      end
    end
    
    Activity.create(:noticeable_type => 'Registration', :from_user_id => self.id)
    
    if self.company_admin_request
      Activity.create(:noticeable_type => 'Admin', :noticeable_id => self.company_id, :from_user_id => self.id)
      Notifier.check_admin(self.email, Company.find(self.company_id)).deliver
    end
    
    if self.street && self.zipcode && self.city
      set_coordinates
    end
    
    if self.role_id == 4
      self.directory = true
      save
    end
  end
  
  def remove_bookmarks
    Bookmark.where(:bookmarkable_type => 'Profile', :bookmarkable_id => self.try(:profile).try(:id)).delete_all
    Worker.where(:user_id => self.id).delete_all
  end
end




# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  directory              :boolean(1)
#  role_id                :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer(4)
#  avatar_updated_at      :datetime
#  admin                  :boolean(1)
#  school_id              :integer(4)
#  company_id             :integer(4)
#  freelance_name         :string(255)
#  job_title              :string(255)
#  company_admin_request  :boolean(1)
#

