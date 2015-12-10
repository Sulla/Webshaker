# coding: utf-8

class Job < ActiveRecord::Base
  
  default_scope order('created_at desc')
  
  has_and_belongs_to_many :job_categories
  belongs_to :job_type
  belongs_to :post
  belongs_to :company
  
  validates :job_type_id, :presence => true
  
  def self.search(keywords)
    keywords = "%#{keywords}%"
    find_by_sql(["SELECT * FROM jobs, posts WHERE jobs.post_id = posts.id AND (posts.title LIKE ? OR posts.content LIKE ? OR jobs.skills LIKE ? OR jobs.how_to_apply LIKE ?)", keywords, keywords, keywords, keywords])
  end
  
end


# == Schema Information
#
# Table name: jobs
#
#  id           :integer(4)      not null, primary key
#  post_id      :integer(4)
#  company_id   :integer(4)
#  skills       :text
#  how_to_apply :text
#  created_at   :datetime
#  updated_at   :datetime
#  job_type_id  :integer(4)
#

