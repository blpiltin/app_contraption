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

ActiveRecord::Schema.define(:version => 20130203024835) do

  create_table "app_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "app_types", ["name"], :name => "index_app_types_on_name", :unique => true

  create_table "apps", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "latlong"
    t.string   "search_words"
    t.text     "description"
    t.string   "icon_uid"
    t.string   "splash_uid"
    t.integer  "app_type_id"
    t.integer  "user_id"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "apps", ["name", "user_id"], :name => "index_apps_on_name_and_user_id", :unique => true

  create_table "gadget_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gadget_types", ["name"], :name => "index_gadget_types_on_name", :unique => true

  create_table "gadgets", :force => true do |t|
    t.string   "label"
    t.text     "description"
    t.string   "icon_uid"
    t.integer  "position"
    t.integer  "gadget_type_id"
    t.integer  "app_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "gadgets", ["app_id", "gadget_type_id"], :name => "index_gadgets_on_app_id_and_gadget_type_id", :unique => true

  create_table "menu_categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_uid"
    t.string   "thumbnail_uid"
    t.integer  "position"
    t.integer  "gadget_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "menu_categories", ["name", "gadget_id"], :name => "index_menu_categories_on_name_and_gadget_id", :unique => true

  create_table "menu_items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_uid"
    t.string   "thumbnail_uid"
    t.decimal  "price"
    t.integer  "position"
    t.integer  "menu_category_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "menu_items", ["name", "menu_category_id"], :name => "index_menu_items_on_name_and_menu_category_id", :unique => true

  create_table "messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "messages", ["email"], :name => "index_messages_on_email"

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
