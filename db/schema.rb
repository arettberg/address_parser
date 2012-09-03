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

ActiveRecord::Schema.define(:version => 20120902073519) do

  create_table "addresses", :force => true do |t|
    t.text     "text_block"
    t.string   "name_1"
    t.string   "name_2"
    t.string   "name_3"
    t.string   "salutation"
    t.string   "suffix"
    t.string   "street_number"
    t.string   "street_name"
    t.string   "unit_number"
    t.string   "city"
    t.string   "state"
    t.integer  "zip_5"
    t.integer  "zip_4"
    t.integer  "text_block_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "text_blocks", :force => true do |t|
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
