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

ActiveRecord::Schema.define(:version => 20130508003801) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "upvote",     :default => 0
    t.integer  "downvote",   :default => 0
  end

  add_index "comments", ["profile_id"], :name => "index_comments_on_profile_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "profile_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "favorites", ["profile_id"], :name => "index_favorites_on_profile_id"
  add_index "favorites", ["user_id"], :name => "index_favorites_on_user_id"

  create_table "profiles", :force => true do |t|
    t.string   "fbid"
    t.text     "total_ratings", :default => "{}"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "ratings", :force => true do |t|
    t.string   "category"
    t.float    "rate"
    t.integer  "user_id"
    t.integer  "profile_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "fbid"
    t.string   "name"
    t.string   "email"
    t.string   "gender"
    t.string   "token"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "friend_list"
    t.string   "gender_pref"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "comment_id",                     :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "up",         :default => "true", :null => false
  end

  add_index "votes", ["comment_id"], :name => "index_votes_on_comment_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
