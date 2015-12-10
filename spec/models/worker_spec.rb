require 'spec_helper'

describe Worker do
  pending "add some examples to (or delete) #{__FILE__}"
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

