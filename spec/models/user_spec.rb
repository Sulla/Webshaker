require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end




# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  directory              :boolean(1)
#  role_id                :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer(4)
#  avatar_updated_at      :datetime
#  admin                  :boolean(1)
#  school_id              :integer(4)
#  company_id             :integer(4)
#  freelance_name         :string(255)
#  job_title              :string(255)
#  company_admin_request  :boolean(1)
#

