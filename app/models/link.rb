# coding: utf-8

class Link < ActiveRecord::Base
  
  belongs_to :linkable, :polymorphic => true
  belongs_to :link_type
  
  def self.create_for_linkable(params, user)
    link = Link.new(:name => params[:name], :url => params[:url], :link_type_id => params[:type])
    link.linkable_type = params[:linkable].camelcase
    
    if link.linkable_type == 'Profile'
      link.linkable_id = user.profile.id
    elsif link.linkable_type == 'Company'
      link.linkable_id = user.company.id
    end
    
    link.save
    link
  end
  
  def self.update_for_linkable(params, user)
    if params[:linkable].camelcase == 'Profile'
      link = user.profile.links.find(params[:id])
    elsif params[:linkable].camelcase == 'Company'
      link = user.company.links.find(params[:id])
    end
    
    link.name         = params[:name]
    link.url          = params[:url]
    link.link_type_id = params[:type]
    link.save
    
    link
  end
  
  def self.destroy_for_linkable(params, user)
    if params[:linkable].camelcase == 'Profile'
      link = user.profile.links.find(params[:id])
    elsif params[:linkable].camelcase == 'Company'
      link = user.company.links.find(params[:id])
    end
    
    link.destroy
  end
  
end


# == Schema Information
#
# Table name: links
#
#  id            :integer(4)      not null, primary key
#  url           :string(255)
#  name          :string(255)
#  link_type_id  :integer(4)
#  linkable_id   :integer(4)
#  linkable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

