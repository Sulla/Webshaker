# coding: utf-8

class Attachment < ActiveRecord::Base
  
  has_attached_file :picture, :styles => { :portfolio => "620x620>", :medium => "300x300>", :thumb => "100x100#" }
  
  belongs_to :user
  
  def as_json(options={})
   { :id => id, :picture_thumb => picture.url(:thumb) }
  end
  
  def self.find_pendings_by_user(user_id)
    where(:user_id => user_id, :post_id => nil)
  end
  
  def size(type = nil)
    Paperclip::Geometry.from_file("#{Rails.root}/public#{picture.url(type).split('?')[0]}")
  end
  
  def self.attach_to_post(post)
    attachments = find_pendings_by_user(post.user_id)
    attachments.each do |attach|
      attach.post_id = post.id
      attach.save
    end
  end
  
end

# == Schema Information
#
# Table name: attachments
#
#  id                   :integer(4)      not null, primary key
#  post_id              :integer(4)
#  user_id              :integer(4)
#  online               :boolean(1)
#  name                 :string(255)
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer(4)
#  picture_updated_at   :datetime
#  created_at           :datetime
#  updated_at           :datetime
#

