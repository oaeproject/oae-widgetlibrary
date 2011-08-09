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

ActiveRecord::Schema.define(:version => 20110809005019) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_widgets", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "widget_id"
  end

  create_table "icons", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.string   "image_updated_at"
    t.integer  "user_id"
    t.integer  "widget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "states", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

end
