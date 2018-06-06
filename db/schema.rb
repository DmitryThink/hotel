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

ActiveRecord::Schema.define(version: 20180603072505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
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
    t.string "name", null: false
    t.string "surname", null: false
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
    t.string "name", null: false
    t.string "surname", null: false
    t.float "salary", null: false
    t.string "license"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maids", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
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
    t.string "name", null: false
    t.string "surname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
