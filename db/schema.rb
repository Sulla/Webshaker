# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120304155700) do

  create_table "activities", :force => true do |t|
    t.string   "noticeable_type"
    t.integer  "noticeable_id"
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "alerts", :force => true do |t|
    t.integer  "user_id"
    t.string   "model"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "attachments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.boolean  "online"
    t.string   "name"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "codes", :force => true do |t|
    t.string   "email"
    t.string   "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "notification",     :default => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "phone"
    t.string   "email"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "summary"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "validated",           :default => false
    t.string   "baseline"
  end

  create_table "events", :force => true do |t|
    t.integer  "post_id"
    t.datetime "occurs_on"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "link"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.string   "access"
    t.string   "registration"
    t.float    "lat"
    t.float    "lng"
  end

  create_table "interviews", :force => true do |t|
    t.integer  "post_id"
    t.string   "movie_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "job_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "job_categories_jobs", :id => false, :force => true do |t|
    t.integer "job_id"
    t.integer "job_category_id"
  end

  create_table "job_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "jobs", :force => true do |t|
    t.integer  "post_id"
    t.integer  "company_id"
    t.text     "skills"
    t.text     "how_to_apply"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "job_type_id"
    t.string   "location"
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "likable_id"
    t.string   "likable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "link_types", :force => true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.integer  "link_type_id"
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "mailings", :force => true do |t|
    t.string   "model"
    t.integer  "resource_id"
    t.boolean  "sent",        :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "post_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "post_type_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "user_id"
    t.boolean  "validated",    :default => false
    t.datetime "accepted_at"
    t.datetime "refused_at"
    t.boolean  "online",       :default => true
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.text     "summary"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.integer  "post_id"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "validated",  :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",   :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "firstname"
    t.string   "lastname"
    t.boolean  "directory"
    t.integer  "role_id"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin"
    t.integer  "school_id"
    t.integer  "company_id"
    t.string   "freelance_name"
    t.string   "job_title"
    t.boolean  "company_admin_request"
    t.string   "street"
    t.string   "zipcode"
    t.string   "city"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "mailing",                               :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "title"
    t.boolean  "admin",      :default => false
    t.boolean  "removable",  :default => true
    t.boolean  "validated",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
