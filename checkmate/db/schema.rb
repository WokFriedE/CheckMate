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

ActiveRecord::Schema[8.0].define(version: 2025_11_07_054529) do
  create_table "Organizations", force: :cascade do |t|
    t.string "org_name"
    t.string "org_location"
    t.integer "parent_org_id"
    t.float "prebook_timeframe"
    t.boolean "public_access"
    t.string "org_pwd"
    t.string "access_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "org_roles", force: :cascade do |t|
    t.integer "org_id"
    t.integer "user_id"
    t.string "user_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
