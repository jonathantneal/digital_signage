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

ActiveRecord::Schema.define(:version => 20101030231207) do

  create_table "announcements", :force => true do |t|
    t.datetime "show_at"
    t.text     "announcement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.string   "slug"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "slide_id",                      :null => false
    t.string   "when",                          :null => false
    t.boolean  "active",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "signs", :force => true do |t|
    t.string   "name",                :limit => 20,                           :null => false
    t.string   "title",               :limit => 50,                           :null => false
    t.boolean  "video",                             :default => false,        :null => false
    t.boolean  "audio",                             :default => false,        :null => false
    t.time     "on"
    t.time     "off"
    t.datetime "last_check_in"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_screen_mode",                  :default => "fullscreen"
    t.float    "transition_duration",               :default => 1.0
    t.integer  "reload_interval",                   :default => 300
    t.integer  "check_in_interval",                 :default => 180
    t.string   "last_ip"
  end

  create_table "slides", :force => true do |t|
    t.string   "title",      :limit => 50,                       :null => false
    t.text     "uri",                                            :null => false
    t.integer  "delay",                    :default => 5,        :null => false
    t.string   "color",      :limit => 6,  :default => "000000", :null => false
    t.boolean  "published",                :default => false,    :null => false
    t.integer  "user_id",                                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resize",                   :default => "",       :null => false
  end

  create_table "slots", :force => true do |t|
    t.integer  "sign_id",                   :null => false
    t.integer  "slide_id",                  :null => false
    t.integer  "order",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",            :limit => 20,                  :null => false
    t.string   "first_name",          :limit => 20,  :default => "", :null => false
    t.string   "last_name",           :limit => 20,  :default => "", :null => false
    t.string   "email",               :limit => 50,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",               :limit => 50,  :default => "", :null => false
    t.string   "department",          :limit => 50,  :default => "", :null => false
    t.string   "photo_url",           :limit => 200, :default => "", :null => false
    t.string   "affiliations",        :limit => 100, :default => "", :null => false
    t.string   "entitlements",        :limit => 500, :default => "", :null => false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

end
