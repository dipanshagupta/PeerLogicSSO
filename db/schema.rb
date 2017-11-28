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

ActiveRecord::Schema.define(version: 20171128232848) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apis", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apis_clients", id: false, force: :cascade do |t|
    t.integer "api_id", null: false
    t.integer "client_id", null: false
    t.index ["api_id", "client_id"], name: "index_apis_clients_on_api_id_and_client_id", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hasKey"
    t.boolean "requested"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "keys", force: :cascade do |t|
    t.string "key"
    t.string "initial_value"
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ttl"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
  end

  add_foreign_key "clients", "users"
end
