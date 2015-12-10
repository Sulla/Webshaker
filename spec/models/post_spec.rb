require 'spec_helper'

describe Post do
  pending "add some examples to (or delete) #{__FILE__}"
end



# == Schema Information
#
# Table name: posts
#
#  id           :integer(4)      not null, primary key
#  title        :string(255)
#  content      :text
#  post_type_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  user_id      :integer(4)
#  validated    :boolean(1)      default(FALSE)
#  accepted_at  :datetime
#

