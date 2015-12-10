require 'spec_helper'

describe Company do
  pending "add some examples to (or delete) #{__FILE__}"
end



# == Schema Information
#
# Table name: companies
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  street              :string(255)
#  zipcode             :string(255)
#  city                :string(255)
#  phone               :string(255)
#  email               :string(255)
#  lat                 :float
#  lng                 :float
#  created_at          :datetime
#  updated_at          :datetime
#  summary             :text
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer(4)
#  avatar_updated_at   :datetime
#  validated           :boolean(1)      default(FALSE)
#

