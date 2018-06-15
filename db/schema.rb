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

ActiveRecord::Schema.define(version: 20180614122244) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "phone_number"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "constant_orders", force: :cascade do |t|
    t.datetime "time", null: false
    t.float "price"
    t.datetime "date_from"
    t.datetime "date_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cooks", force: :cascade do |t|
    t.float "salary", null: false
    t.string "education"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cooks_meals", id: false, force: :cascade do |t|
    t.bigint "meal_id", null: false
    t.bigint "cook_id", null: false
    t.index ["meal_id", "cook_id"], name: "index_cooks_meals_on_meal_id_and_cook_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.float "salary", null: false
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maids", force: :cascade do |t|
    t.float "salary", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maids_rooms", id: false, force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "maid_id", null: false
    t.index ["room_id", "maid_id"], name: "index_maids_rooms_on_room_id_and_maid_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meals_orders", id: false, force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "meal_id", null: false
    t.index ["order_id", "meal_id"], name: "index_meals_orders_on_order_id_and_meal_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "time", null: false
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "reservation_id"
    t.index ["reservation_id"], name: "index_orders_on_reservation_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.string "personable_type"
    t.bigint "personable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personable_type", "personable_id"], name: "index_people_on_personable_type_and_personable_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "date_from", null: false
    t.datetime "date_to", null: false
    t.float "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.bigint "room_id"
    t.integer "payment"
    t.string "step"
    t.boolean "paid"
    t.index ["client_id"], name: "index_reservations_on_client_id"
    t.index ["room_id"], name: "index_reservations_on_room_id"
  end

  create_table "reservations_visitors", id: false, force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "visitor_id", null: false
    t.index ["reservation_id", "visitor_id"], name: "index_reservations_visitors_on_reservation_id_and_visitor_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "number_of_people", null: false
    t.float "price", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_of_room", default: 0, null: false
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "time"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driver_id"
    t.index ["driver_id"], name: "index_trips_on_driver_id"
  end

  create_table "trips_visitors", id: false, force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.bigint "visitor_id", null: false
    t.index ["trip_id", "visitor_id"], name: "index_trips_visitors_on_trip_id_and_visitor_id"
  end

  create_table "visitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workers", force: :cascade do |t|
    t.string "workable_type"
    t.bigint "workable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workable_type", "workable_id"], name: "index_workers_on_workable_type_and_workable_id"
  end

end
