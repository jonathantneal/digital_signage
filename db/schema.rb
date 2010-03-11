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

ActiveRecord::Schema.define(:version => 20100223010111) do

  create_table "schedules", :force => true do |t|
    t.integer  "slide_id",                      :null => false
    t.string   "when",                          :null => false
    t.boolean  "active",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signs", :force => true do |t|
    t.string   "name",          :limit => 20,                    :null => false
    t.string   "title",         :limit => 50,                    :null => false
    t.integer  "width",                                          :null => false
    t.integer  "height",                                         :null => false
    t.boolean  "video",                       :default => false, :null => false
    t.boolean  "audio",                       :default => false, :null => false
    t.time     "on"
    t.time     "off"
    t.datetime "last_check_in"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "slots", :force => true do |t|
    t.integer  "sign_id",                   :null => false
    t.integer  "slide_id",                  :null => false
    t.integer  "order",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",           :limit => 20,                  :null => false
    t.string   "first_name",         :limit => 20,  :default => "", :null => false
    t.string   "last_name",          :limit => 20,  :default => "", :null => false
    t.string   "email",              :limit => 50,  :default => "", :null => false
    t.integer  "roles_mask",                        :default => 0,  :null => false
    t.string   "persistence_token",  :limit => 128, :default => "", :null => false
    t.integer  "login_count",                       :default => 0,  :null => false
    t.integer  "failed_login_count",                :default => 0,  :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",   :limit => 15,  :default => "", :null => false
    t.string   "last_login_ip",      :limit => 15,  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
