require 'spec_helper'

describe Attachment do
  pending "add some examples to (or delete) #{__FILE__}"
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

