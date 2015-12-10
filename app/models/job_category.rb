# coding: utf-8

class JobCategory < ActiveRecord::Base
  
  has_and_belongs_to_many :jobs
  
end

# == Schema Information
#
# Table name: job_categories
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

