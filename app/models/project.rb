# coding: utf-8

class Project < ActiveRecord::Base

  belongs_to :post

  def clean_url
    u = self.url
    u = "http://#{u}" unless u.include?('http://')
    u
  end

end

# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  post_id    :integer(4)
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

