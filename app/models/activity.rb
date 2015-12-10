# coding: utf-8

class Activity < ActiveRecord::Base
  
  belongs_to :noticeable, :polymorphic => true
  
  def from
    User.find(self.from_user_id)
  end
  
end

# == Schema Information
#
# Table name: activities
#
#  id              :integer(4)      not null, primary key
#  noticeable_type :string(255)
#  noticeable_id   :integer(4)
#  from_user_id    :integer(4)
#  to_user_id      :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#

