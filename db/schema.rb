# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_21_224327) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "author_comments", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_author_comments_on_author_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "book_comments", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_comments_on_book_id"
  end

  create_table "book_genres", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "genre_id", null: false
    t.index ["book_id"], name: "index_book_genres_on_book_id"
    t.index ["genre_id"], name: "index_book_genres_on_genre_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.text "blurb", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "author_id"
    t.integer "lock_version"
    t.integer "in_stock", default: 0, null: false
    t.string "aasm_state", default: "stocked", null: false
    t.integer "position"
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["position"], name: "index_books_on_position"
    t.index ["title"], name: "index_books_on_title", unique: true
  end

  create_table "buyers", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "calendar_days", primary_key: "day", id: :date, force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.integer "day_of_month", null: false
    t.integer "day_of_week", null: false
    t.integer "quarter", null: false
    t.boolean "business_day", null: false
    t.boolean "weekday", null: false
  end

  create_table "genre_groups", force: :cascade do |t|
    t.string "genre_group_key", null: false
    t.bigint "genre_id", null: false
    t.index ["genre_group_key", "genre_id"], name: "index_genre_groups_on_genre_group_key_and_genre_id", unique: true
    t.index ["genre_id"], name: "index_genre_groups_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "order_line_items", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "order_id", null: false
    t.integer "unit_price", null: false
    t.integer "quantity", null: false
    t.index ["book_id"], name: "index_order_line_items_on_book_id"
    t.index ["order_id"], name: "index_order_line_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "shipping_address_id", null: false
    t.datetime "placed_at", null: false
    t.datetime "canceled_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyer_id"], name: "index_orders_on_buyer_id"
    t.index ["shipping_address_id"], name: "index_orders_on_shipping_address_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "bio"
    t.date "birth"
    t.date "death"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_id"], name: "index_profiles_on_author_id", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.datetime "expires_at", null: false
    t.index ["book_id"], name: "index_reservations_on_book_id"
    t.index ["expires_at"], name: "index_reservations_on_expires_at"
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "placed_at"
    t.integer "revenue"
    t.integer "unit_price"
    t.integer "quantity"
    t.integer "order_line_item_id"
    t.integer "order_id"
    t.integer "book_id"
    t.integer "author_id"
    t.integer "buyer_id"
    t.string "state", limit: 2
    t.date "placed_on"
    t.string "genre_group_key"
  end

  create_table "shipping_addresses", force: :cascade do |t|
    t.string "state"
    t.bigint "buyer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyer_id"], name: "index_shipping_addresses_on_buyer_id"
  end

  add_foreign_key "author_comments", "authors"
  add_foreign_key "book_comments", "books"
  add_foreign_key "book_genres", "books"
  add_foreign_key "book_genres", "genres"
  add_foreign_key "books", "authors", on_delete: :restrict
  add_foreign_key "genre_groups", "genres"
  add_foreign_key "order_line_items", "books"
  add_foreign_key "order_line_items", "orders"
  add_foreign_key "orders", "buyers"
  add_foreign_key "orders", "shipping_addresses"
  add_foreign_key "profiles", "authors", on_delete: :restrict
  add_foreign_key "reservations", "books"
  add_foreign_key "shipping_addresses", "buyers"
end
