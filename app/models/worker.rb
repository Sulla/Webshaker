# coding: utf-8

class Worker < ActiveRecord::Base
  
  attr_protected :removable
  
  belongs_to :company
  belongs_to :user
  
  scope :validated, where(:validated => true)
  
  def self.search(keywords)
    find_by_sql(["SELECT w.* FROM workers w, companies c WHERE w.company_id = c.id AND c.name LIKE ?", "%#{keywords}%"])
  end
  
end

# == Schema Information
#
# Table name: workers
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  company_id :integer(4)
#  title      :string(255)
#  admin      :boolean(1)      default(FALSE)
#  removable  :boolean(1)      default(FALSE)
#  validated  :boolean(1)      default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

