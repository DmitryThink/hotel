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

ActiveRecord::Schema.define(version: 20180724073405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  create_table "messages", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "months", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "number"
    t.integer "1"
    t.integer "2"
    t.integer "3"
    t.integer "4"
    t.integer "5"
    t.integer "6"
    t.integer "7"
    t.integer "8"
    t.integer "9"
    t.integer "10"
    t.integer "11"
    t.integer "12"
    t.integer "13"
    t.integer "14"
    t.integer "15"
    t.integer "16"
    t.integer "17"
    t.integer "18"
    t.integer "19"
    t.integer "20"
    t.integer "21"
    t.integer "22"
    t.integer "23"
    t.integer "24"
    t.integer "25"
    t.integer "26"
    t.integer "27"
    t.integer "28"
    t.integer "39"
    t.integer "30"
    t.integer "31"
    t.integer "32"
    t.integer "33"
    t.integer "34"
    t.integer "35"
    t.integer "36"
    t.integer "37"
    t.integer "38"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "last4"
    t.decimal "amount"
    t.boolean "success"
    t.string "authorization_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "date_from", null: false
    t.datetime "date_to", null: false
    t.float "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id"
    t.bigint "client_id"
    t.boolean "paid"
    t.string "message"
    t.boolean "prepaid"
    t.index ["client_id"], name: "index_reservations_on_client_id"
    t.index ["room_id"], name: "index_reservations_on_room_id"
  end

  create_table "reservations_room_dates", id: false, force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "room_date_id", null: false
    t.index ["reservation_id", "room_date_id"], name: "reservations_room_dates_index"
  end

  create_table "room_dates", force: :cascade do |t|
    t.date "date"
    t.integer "number"
    t.float "price"
    t.bigint "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_room_dates_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "number_of_people", null: false
    t.integer "type_of_room"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tolk_locales", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_tolk_locales_on_name", unique: true
  end

  create_table "tolk_phrases", force: :cascade do |t|
    t.text "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", force: :cascade do |t|
    t.integer "phrase_id"
    t.integer "locale_id"
    t.text "text"
    t.text "previous_text"
    t.boolean "primary_updated", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["phrase_id", "locale_id"], name: "index_tolk_translations_on_phrase_id_and_locale_id", unique: true
  end

  add_foreign_key "room_dates", "rooms"
end
