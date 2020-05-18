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

ActiveRecord::Schema.define(version: 2020_05_18_174048) do

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

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.text "blurb", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "author_id"
    t.integer "lock_version"
    t.integer "in_stock", default: 0, null: false
    t.string "aasm_state", default: "stocked", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["title"], name: "index_books_on_title", unique: true
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

  add_foreign_key "author_comments", "authors"
  add_foreign_key "book_comments", "books"
  add_foreign_key "books", "authors", on_delete: :restrict
  add_foreign_key "profiles", "authors", on_delete: :restrict
end
