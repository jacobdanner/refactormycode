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

ActiveRecord::Schema.define(:version => 20110420045837) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codes", :force => true do |t|
    t.string   "title"
    t.text     "comment"
    t.text     "code"
    t.string   "language"
    t.datetime "created_at"
    t.integer  "user_id"
    t.integer  "refactors_count", :default => 0
    t.string   "trackback_url"
    t.string   "permalink"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer "code_id"
    t.integer "user_id"
    t.string  "email"
    t.string  "name"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.binary  "server_url"
    t.string  "handle"
    t.binary  "secret"
    t.integer "issued"
    t.integer "lifetime"
    t.string  "assoc_type"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "refactor_id"
    t.datetime "created_at"
    t.integer  "value"
  end

  create_table "refactors", :force => true do |t|
    t.integer  "code_id"
    t.string   "title"
    t.text     "comment"
    t.text     "code"
    t.string   "language"
    t.datetime "created_at"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_email"
    t.string   "user_website"
    t.boolean  "spam",          :default => false
    t.float    "spaminess"
    t.string   "signature"
    t.integer  "ratings_count", :default => 0
    t.integer  "rating",        :default => 0
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string  "name"
    t.string  "email"
    t.string  "identity_url"
    t.string  "website"
    t.string  "token"
    t.boolean "admin",                    :default => false
    t.float   "rating",                   :default => 0.0
    t.integer "refactors_count",          :default => 0
    t.string  "alternative_identity_url"
  end

end
