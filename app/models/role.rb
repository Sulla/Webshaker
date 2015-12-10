# coding: utf-8

class Role < ActiveRecord::Base
  
  default_scope order(:position)
  
end

# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

