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

ActiveRecord::Schema[8.0].define(version: 2025_11_07_060512) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "inventories", force: :cascade do |t|
    t.integer "owner_org_id"
    t.integer "item_count"
    t.string "inventory_name"
    t.string "item_category"
    t.boolean "can_prebook"
    t.boolean "lock_status"
    t.string "request_mode"
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

  create_table "organizations", force: :cascade do |t|
    t.integer "org_id"
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

  add_foreign_key "org_roles", "organizations", column: "org_id"
end
