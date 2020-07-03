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

ActiveRecord::Schema.define(version: 2020_07_03_162513) do

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.float "price"
    t.integer "user_id"
    t.integer "location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "water"
    t.integer "acres_mile"
    t.string "fish_species"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "username"
    t.string "password"
  end

end
