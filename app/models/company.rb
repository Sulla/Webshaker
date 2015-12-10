# coding: utf-8

class Company < ActiveRecord::Base
  include Geokit::Geocoders

  has_many :workers
  has_many :links, :as => :linkable
  
  validates :name, :presence => true
  validates :street, :presence => true
  validates :zipcode, :presence => true
  validates :city, :presence => true    
  
  default_scope order('name')
  
  has_attached_file :avatar, :styles => { :medium => "300x300#", :thumb => "100x100#" }
  
  def set_owner(user)
    Worker.create(:user_id => user.id, :company_id => self.id, :admin => true, :removable => false, :validated => true, :title => 'Owner')
  end
  
  def work_requests
    Worker.where(:company_id => self.id, :validated => false).order(:created_at)
  end
  
  def admin
    Worker.where(:company_id => self.id, :admin => true, :validated => true).first
  end
  
  def admin_request
    Worker.where(:company_id => self.id, :admin => true).first
  end  
  
  def full_address
    "#{street}, #{zipcode} #{city}, Belgium"
  end
  
  def fullname
    name
  end
  
  def set_coordinates
    res = Geokit::Geocoders::GoogleGeocoder.geocode(full_address)
    self.lat = res.lat
    self.lng = res.lng
    save
  end
  
  def admins_ids
    workers = Worker.where(:company_id => self.id, :admin => true)
    ids = []
    workers.each do |w|
      ids << w.user.id
    end
    ids
  end
  
  def self.get_random_sql
    sql = ""
    begin
      if ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::Mysql2Adapter)
        sql = "RAND()"
      end
    rescue
      begin
        if ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::MysqlAdapter)
          sql = "RAND()"
        end
      rescue
        sql = "RANDOM()"
      end
    end
      
    sql
  end
  
  def posts
    Post.where(:user_id => admins_ids)
  end
  
  def likes
    Like.where(:likable_id => self.id, :likable_type => 'Company').count
  end
  
  def self.search(keywords)
    keywords = "%#{keywords}%"
    with_users.where(["name LIKE ? OR city LIKE ?", keywords, keywords])
  end
  
  def self.top(limit = nil)
    limit = "LIMIT #{limit}" if limit
    find_by_sql("SELECT cp.*, count(likes.id) as total FROM companies cp, likes WHERE cp.id = likes.likable_id AND likes.likable_type = 'Company' GROUP BY likes.likable_id ORDER BY total DESC #{limit}")
  end
  
  def self.with_users(treated_ids = nil)
    workers = Worker.find_by_sql("SELECT DISTINCT(company_id) as company_id FROM workers")
    ids = workers.map(&:company_id)
    result = where(:id => ids)
    
    if treated_ids.present? && !treated_ids.nil?
      treated_ids = treated_ids.split("_")
      treated_ids_int = []
      treated_ids.each do |i|
        treated_ids_int << i.to_i
      end

      arel = Company.arel_table
      result = result.where(arel[:id].not_in(treated_ids_int))
    end
    
    result
  end
  
  def self.with_users_ordered_by_likes(limit, offset = 0, like = '')
    workers = Worker.find_by_sql("SELECT DISTINCT(company_id) as company_id FROM workers")
    ids = workers.map(&:company_id)
    
    if like.present?
      find_by_sql(["SELECT cp.*, count(likes.id) as total FROM companies cp, likes WHERE cp.id = likes.likable_id AND likes.likable_type = 'Company' AND (name LIKE ? OR city LIKE ?) GROUP BY likes.likable_id ORDER BY total DESC LIMIT #{limit} OFFSET #{offset}", like, like])
    else
      find_by_sql("SELECT cp.*, count(likes.id) as total FROM companies cp, likes WHERE cp.id = likes.likable_id AND likes.likable_type = 'Company' GROUP BY likes.likable_id ORDER BY total DESC LIMIT #{limit} OFFSET #{offset}")          
    end
  end
  
  def id
    i = read_attribute(:id)
    
    if i && self.name.present?
      i = "#{read_attribute(:id)}-#{self.name.gsub(' ','-').gsub('?','').gsub('!','').gsub('é','e').gsub('è','e').gsub('ê','e').gsub('ù','u').gsub('à','a').gsub('ç','c').gsub('\'','').gsub('"','').gsub('î','').gsub('ô','').gsub('û','').gsub('ü','').gsub('ë','').gsub('ï','').gsub('(','').gsub(')','').gsub('€','').gsub('$','').gsub('*','').gsub(',','').gsub('.','').gsub('/','').gsub('+','').gsub('@','').gsub('&','').gsub('§','').gsub('%','').gsub('£','').gsub(';','').gsub(':','')}".downcase
    end
    
    i
  end
  
  def clean_id
    read_attribute(:id)
  end
  
end


# == Schema Information
#
# Table name: companies
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  street              :string(255)
#  zipcode             :string(255)
#  city                :string(255)
#  phone               :string(255)
#  email               :string(255)
#  lat                 :float
#  lng                 :float
#  created_at          :datetime
#  updated_at          :datetime
#  summary             :text
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime
#  validated           :boolean(1)      default(FALSE)
#

