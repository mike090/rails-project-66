# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_08_26_134115) do

  create_table "repositories", force: :cascade do |t|
    t.string "name", null: false
    t.string "full_name", null: false
    t.string "language", null: false
    t.boolean "check_state", default: false, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "github_id", default: 0, null: false
    t.index ["full_name"], name: "index_repositories_on_full_name", unique: true
    t.index ["user_id", "github_id"], name: "index_repositories_on_user_id_and_github_id", unique: true
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "nickname", null: false
    t.string "token", null: false
    t.string "name"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
  end

  add_foreign_key "repositories", "users"
end
