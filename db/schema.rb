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

ActiveRecord::Schema.define(:version => 20120206212614) do

  create_table "deals", :force => true do |t|
    t.string   "title"
    t.float    "old_price"
    t.float    "current_price"
    t.string   "cover_img"
    t.text     "description"
    t.date     "deal_date"
    t.string   "asin"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_id"
  end

  create_table "emails", :force => true do |t|
    t.string   "mc_campaign_id"
    t.integer  "deal_id"
    t.string   "mc_list_id"
    t.string   "mc_campaign_type", :default => "regular"
    t.string   "subject"
    t.string   "from_email"
    t.string   "from_name"
    t.text     "email_html"
    t.text     "email_text"
    t.integer  "sent",             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
