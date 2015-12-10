# coding: utf-8

class School < ActiveRecord::Base
  
  default_scope order('name')  
  
  validates :name, :presence => true, :uniqueness => true
  
end


# == Schema Information
#
# Table name: schools
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  validated  :boolean(1)      default(FALSE)
#

