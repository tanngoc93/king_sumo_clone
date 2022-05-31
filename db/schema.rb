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

ActiveRecord::Schema[7.0].define(version: 2022_05_31_025836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bonus_entries", force: :cascade do |t|
    t.integer "name"
    t.string "action_text"
    t.string "action_url"
    t.integer "action_points", default: 0, null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_bonus_entries_on_campaign_id"
  end

  create_table "bonus_entry_managements", force: :cascade do |t|
    t.bigint "contestant_id", null: false
    t.bigint "bonus_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bonus_entry_id"], name: "index_bonus_entry_managements_on_bonus_entry_id"
    t.index ["contestant_id"], name: "index_bonus_entry_managements_on_contestant_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "starts_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.datetime "awarded_at", precision: nil
    t.string "timezone"
    t.boolean "gdpr"
    t.string "offered_by_name"
    t.string "offered_by_url"
    t.integer "currency_unit", default: 0, null: false
    t.integer "number_of_winners", default: 0, null: false
    t.string "winner_prize_name"
    t.float "winner_prize_value", default: 0.0, null: false
    t.integer "number_of_runners_up", default: 0, null: false
    t.string "runner_up_prize_name"
    t.float "runner_up_prize_value", default: 0.0, null: false
    t.integer "total_contestants", default: 0
    t.integer "total_entries", default: 0
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "rules_and_terms", default: ""
    t.index ["slug"], name: "index_campaigns_on_slug", unique: true
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "contestants", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "registered_ip"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at", precision: nil
    t.string "confirmed_ip"
    t.datetime "confirmed_at", precision: nil
    t.string "country_code"
    t.integer "total_points", default: 0, null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret_code"
    t.boolean "confirmed", default: false, null: false
    t.integer "total_referrals", default: 0, null: false
    t.string "referral_code"
    t.integer "referred_by_id"
    t.index ["campaign_id"], name: "index_contestants_on_campaign_id"
    t.index ["secret_code"], name: "index_contestants_on_secret_code", unique: true
  end

  create_table "downloads", force: :cascade do |t|
    t.integer "status"
    t.string "file_name"
    t.string "file_type"
    t.bigint "user_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_downloads_on_campaign_id"
    t.index ["user_id"], name: "index_downloads_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "campaign_id"
    t.index ["campaign_id"], name: "index_images_on_campaign_id"
  end

  create_table "seed_migration_data_migrations", id: :serial, force: :cascade do |t|
    t.string "version"
    t.integer "runtime"
    t.datetime "migrated_on", precision: nil
  end

  create_table "share_action_managements", force: :cascade do |t|
    t.bigint "contestant_id", null: false
    t.bigint "share_action_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contestant_id"], name: "index_share_action_managements_on_contestant_id"
    t.index ["share_action_id"], name: "index_share_action_managements_on_share_action_id"
  end

  create_table "share_actions", force: :cascade do |t|
    t.integer "name"
    t.string "action_text"
    t.string "action_url"
    t.integer "action_points"
    t.boolean "checked", default: false, null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_share_actions_on_campaign_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_scopes"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_type", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bonus_entries", "campaigns"
  add_foreign_key "bonus_entry_managements", "bonus_entries"
  add_foreign_key "bonus_entry_managements", "contestants"
  add_foreign_key "campaigns", "users"
  add_foreign_key "contestants", "campaigns"
  add_foreign_key "downloads", "campaigns"
  add_foreign_key "downloads", "users"
  add_foreign_key "share_action_managements", "contestants"
  add_foreign_key "share_action_managements", "share_actions"
  add_foreign_key "share_actions", "campaigns"
end
