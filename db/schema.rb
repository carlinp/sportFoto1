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

ActiveRecord::Schema.define(:version => 20100923154843) do

  create_table "cart_items", :force => true do |t|
    t.integer "cart_id"
    t.integer "photo_id"
    t.boolean "is_zipped",               :default => false
    t.integer "price",                   :default => 0
    t.boolean "is_paid_to_photographer", :default => false
  end

  create_table "carts", :force => true do |t|
    t.string   "carthash"
    t.text     "response"
    t.boolean  "is_paid",     :default => false
    t.boolean  "is_zipped",   :default => false
    t.string   "zipfile"
    t.datetime "paymentdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title",                            :null => false
    t.text     "description"
    t.string   "banner"
    t.string   "gps"
    t.string   "fingerprint"
    t.datetime "event_start",                      :null => false
    t.datetime "event_end"
    t.integer  "event_type_id"
    t.boolean  "is_approved",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  create_table "exifs", :force => true do |t|
    t.string   "width"
    t.string   "height"
    t.string   "model"
    t.datetime "date_time"
    t.string   "exposure_time"
    t.float    "f_number"
  end

  create_table "payment_notifications", :force => true do |t|
    t.text    "params"
    t.integer "cart_id"
    t.string  "status"
    t.string  "transaction_id"
  end

  create_table "photographers", :force => true do |t|
    t.string   "firstname",                         :null => false
    t.string   "lastname",                          :null => false
    t.text     "contact",                           :null => false
    t.boolean  "is_approved",    :default => false
    t.boolean  "is_active",      :default => false
    t.boolean  "is_public",      :default => false
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "paypal_address", :default => ""
  end

  create_table "photographers_event_types", :force => true do |t|
    t.integer "photographer_id"
    t.integer "event_type_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "filename",                           :null => false
    t.string   "path",                               :null => false
    t.string   "startnumber"
    t.string   "description"
    t.string   "fingerprint"
    t.boolean  "is_processed",    :default => false
    t.boolean  "is_approved",     :default => false
    t.boolean  "is_processing",   :default => false
    t.boolean  "has_startnumber", :default => false
    t.integer  "photographer_id"
    t.integer  "event_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exif_id"
    t.integer  "price",           :default => 0
    t.string   "currency"
    t.integer  "spot_id"
    t.integer  "num_download",    :default => 0
  end

  create_table "photos_startnumbers", :force => true do |t|
    t.string   "startnumber"
    t.integer  "photo_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spots", :force => true do |t|
    t.string  "name"
    t.string  "gps_lat"
    t.string  "gps_long"
    t.integer "event_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
