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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140415210510) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: true do |t|
    t.string   "name"
    t.string   "tag"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "wunderlist_id"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "integrations", force: true do |t|
    t.string   "access_token"
    t.integer  "wunderlist_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "integrations", ["wunderlist_user_id"], name: "index_integrations_on_wunderlist_user_id", using: :btree

  create_table "lists", force: true do |t|
    t.integer  "wunderlist_id"
    t.json     "data"
    t.boolean  "synced"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree
  add_index "lists", ["wunderlist_id"], name: "index_lists_on_wunderlist_id", using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "wunderlist_id"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "wunderlist_id"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
