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

ActiveRecord::Schema.define(version: 20170410214459) do

  create_table "entries", force: :cascade do |t|
    t.integer  "institution_id"
    t.integer  "location_id"
    t.integer  "ap_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "orgssid_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "country"
    t.integer  "institution_type"
    t.string   "inst_realm"
    t.string   "address"
    t.string   "city"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "apikey"
  end

  create_table "loc_names", force: :cascade do |t|
    t.string   "lang"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "address"
    t.integer  "street_nr"
    t.string   "city"
    t.string   "country"
    t.string   "longitude"
    t.string   "latitude"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "institution_id"
  end

  create_table "orginfos", force: :cascade do |t|
    t.string   "lang"
    t.string   "url"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "orgnames", force: :cascade do |t|
    t.string   "lang"
    t.string   "name"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "orgpolicies", force: :cascade do |t|
    t.string   "lang"
    t.string   "url"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "orgssids", force: :cascade do |t|
    t.integer  "number"
    t.integer  "institution_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.boolean  "port_restrict"
    t.boolean  "transp_proxy"
    t.boolean  "ipv6"
    t.boolean  "nat"
    t.boolean  "wpa_tkip"
    t.boolean  "wpa_aes"
    t.boolean  "wpa2_tkip"
    t.boolean  "wpa2_aes"
    t.boolean  "wired"
  end

  add_index "orgssids", ["id", "institution_id"], name: "index_orgssids_on_id_and_institution_id"

end
