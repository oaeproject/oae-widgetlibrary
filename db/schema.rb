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

ActiveRecord::Schema.define(:version => 20111214203828) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_widgets", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "widget_id"
  end

  create_table "languages", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.string   "region"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_widgets", :id => false, :force => true do |t|
    t.integer "language_id"
    t.integer "widget_id"
  end

  create_table "ratings", :force => true do |t|
    t.text     "review"
    t.integer  "stars"
    t.integer  "widget_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "screenshots", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.string   "image_updated_at"
    t.integer  "widget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                                 :default => false
    t.boolean  "reviewer",                              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "info"
    t.text     "summary"
    t.string   "occupation"
    t.string   "homepage"
    t.string   "location"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.string   "avatar_file_size"
    t.string   "avatar_updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "widgets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "features"
    t.datetime "released_on"
    t.float    "average_rating"
    t.integer  "state_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.string   "icon_file_size"
    t.string   "icon_updated_at"
    t.string   "code_file_name"
    t.string   "code_content_type"
    t.string   "code_file_size"
    t.string   "code_updated_at"
  end

end
