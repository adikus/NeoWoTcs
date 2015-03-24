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

ActiveRecord::Schema.define(version: 20141221192748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clans", force: true do |t|
    t.text     "description"
    t.string   "motto"
    t.string   "name"
    t.string   "tag"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "player_stats", force: true do |t|
    t.integer  "player_id",    limit: 8
    t.integer  "battles"
    t.integer  "wins"
    t.integer  "defeats"
    t.integer  "survived"
    t.integer  "frags"
    t.float    "accuracy"
    t.integer  "damage"
    t.integer  "capture"
    t.integer  "defense"
    t.integer  "experience"
    t.float    "wn8"
    t.float    "efficiency"
    t.float    "average_tier"
    t.float    "sc3"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spotted"
  end

  create_table "player_tanks", force: true do |t|
    t.integer  "player_id",       limit: 8
    t.integer  "tank_id"
    t.integer  "battles"
    t.integer  "wins"
    t.integer  "mark_of_mastery"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.integer  "clan_id",    limit: 8
    t.integer  "status"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tanks", force: true do |t|
    t.string   "name"
    t.string   "name_i18n"
    t.string   "nation"
    t.string   "tank_type"
    t.integer  "level"
    t.string   "contour_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
