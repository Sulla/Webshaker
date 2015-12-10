require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
end


# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)
#  content          :text
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  notification     :boolean(1)      default(FALSE)
#

