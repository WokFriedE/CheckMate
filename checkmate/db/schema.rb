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

ActiveRecord::Schema[8.0].define(version: 2025_12_02_054116) do
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
    t.integer "item_id"
  end

  create_table "item_details", force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "item_name"
    t.datetime "last_taken"
    t.string "item_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_details_on_item_id", unique: true
  end

  create_table "item_settings", force: :cascade do |t|
    t.integer "item_id"
    t.integer "owner_org_id"
    t.integer "reg_max_check"
    t.integer "reg_max_total_quantity"
    t.integer "reg_prebook_timeframe"
    t.integer "reg_borrow_time"
    t.integer "sup_max_checkout"
    t.integer "sup_max_total_quantity"
    t.integer "sup_prebook_timeframe"
    t.integer "sup_borrow_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "msg_id", null: false
    t.string "from"
    t.string "to"
    t.datetime "scheduled_send_time", precision: nil
    t.datetime "send_time", precision: nil
    t.datetime "receive_time", precision: nil
    t.datetime "read_time", precision: nil
    t.text "msg_content"
    t.string "msg_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["msg_id"], name: "index_messages_on_msg_id", unique: true
  end

  create_table "order_details", force: :cascade do |t|
    t.integer "order_id"
    t.integer "item_id"
    t.integer "item_count"
    t.datetime "due_date", precision: nil
    t.integer "owner_org_id"
    t.time "checkout_time"
    t.string "approval_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "order_id", null: false
    t.datetime "order_date", precision: nil
    t.boolean "return_status"
    t.string "order_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["order_id"], name: "index_orders_on_order_id", unique: true
  end

  create_table "org_logs", force: :cascade do |t|
    t.uuid "user_id"
    t.integer "org_id"
    t.text "operation"
    t.datetime "time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "org_roles", force: :cascade do |t|
    t.integer "org_id", null: false
    t.uuid "user_id", null: false
    t.string "user_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id", "user_id"], name: "index_org_roles_on_org_id_and_user_id", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.integer "org_id", null: false
    t.string "org_name"
    t.string "org_location"
    t.integer "parent_org_id"
    t.float "prebook_timeframe"
    t.boolean "public_access"
    t.string "org_pwd"
    t.string "access_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_organizations_on_org_id", unique: true
  end

  create_table "returns", force: :cascade do |t|
    t.integer "order_id"
    t.integer "item_id"
    t.integer "return_count"
    t.datetime "return_date", precision: nil
    t.boolean "verify_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_data", force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "name"
    t.string "contact_num"
    t.string "address"
    t.string "designation"
    t.bigint "njit_id"
    t.boolean "returns_pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.index ["njit_id"], name: "index_user_data_on_njit_id", unique: true
    t.index ["user_id"], name: "index_user_data_on_user_id", unique: true
  end

  add_foreign_key "inventories", "item_details", column: "item_id", primary_key: "item_id"
  add_foreign_key "inventories", "organizations", column: "owner_org_id", primary_key: "org_id"
  add_foreign_key "item_settings", "item_details", column: "item_id", primary_key: "item_id"
  add_foreign_key "order_details", "item_details", column: "item_id", primary_key: "item_id"
  add_foreign_key "order_details", "orders", primary_key: "order_id"
  add_foreign_key "order_details", "organizations", column: "owner_org_id", primary_key: "org_id"
  add_foreign_key "orders", "user_data", column: "user_id", primary_key: "user_id"
  add_foreign_key "org_roles", "organizations", column: "org_id", primary_key: "org_id"
  add_foreign_key "org_roles", "user_data", column: "user_id", primary_key: "user_id"
  add_foreign_key "returns", "item_details", column: "item_id", primary_key: "item_id"
  add_foreign_key "returns", "orders", primary_key: "order_id"
  add_foreign_key "user_data", "auth.users", name: "fk_user_data_auth_users", on_delete: :cascade
end
