# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080902152123) do

  create_table "boards", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.text     "description"
    t.integer  "group_id"
    t.integer  "posts_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clips", :force => true do |t|
    t.integer  "size"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diggs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "ip",         :limit => 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "friend_id",   :null => false
    t.datetime "created_at"
    t.datetime "accepted_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.string   "name"
    t.text     "description"
    t.integer  "boards_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "read_count",                  :default => 0
    t.integer  "replies_count",               :default => 0
    t.integer  "diggs_count",                 :default => 0
    t.integer  "clips_count",                 :default => 0
    t.boolean  "sticky",                      :default => false
    t.string   "ip",            :limit => 24
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "board_id"
    t.integer  "open_level",                  :default => 99
  end

  create_table "replies", :force => true do |t|
    t.text     "body"
    t.string   "ip",         :limit => 15
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "author"
    t.string   "password"
    t.string   "homepage"
    t.boolean  "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "identity_url"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
  end

end
