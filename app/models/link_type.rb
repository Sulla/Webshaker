# coding: utf-8

class LinkType < ActiveRecord::Base
  
  default_scope order(:name)
  
end

# == Schema Information
#
# Table name: link_types
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  icon       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

