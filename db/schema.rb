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

ActiveRecord::Schema[7.0].define(version: 2023_10_25_221849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "certifications", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_certifications_on_user_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notifications_token"
    t.string "source_control_token"
    t.string "ticket_tracking_system_token"
    t.string "slug"
    t.string "ticket_tracking_system"
    t.index ["name"], name: "index_customers_on_name", unique: true
    t.index ["slug"], name: "index_customers_on_slug", unique: true
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

  create_table "issues", force: :cascade do |t|
    t.float "effort"
    t.bigint "user_id", null: false
    t.string "state"
    t.datetime "closed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.string "issue_id"
    t.string "issue_type"
    t.string "title"
    t.index ["project_id"], name: "index_issues_on_project_id"
    t.index ["user_id"], name: "index_issues_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "target"
    t.string "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "billable", default: true, null: false
    t.string "slack_channel"
    t.date "start_date"
    t.date "end_date"
    t.json "metadata"
    t.string "slug"
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statement_of_works", force: :cascade do |t|
    t.string "model"
    t.float "hourly_revenue"
    t.float "total_revenue"
    t.float "total_hours"
    t.string "hour_delivery_schedule"
    t.boolean "limit_by_delivery_schedule"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_statement_of_works_on_project_id"
  end

  create_table "user_permissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "permission_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_user_permissions_on_permission_id"
    t.index ["user_id", "permission_id"], name: "index_user_permissions_on_user_id_and_permission_id", unique: true
    t.index ["user_id"], name: "index_user_permissions_on_user_id"
  end

  create_table "user_service_identifiers", force: :cascade do |t|
    t.string "service_name"
    t.bigint "customer_id", null: false
    t.bigint "user_id", null: false
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_user_service_identifiers_on_customer_id"
    t.index ["user_id"], name: "index_user_service_identifiers_on_user_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.string "level"
    t.integer "last_applied_in_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "google_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "profession_id"
    t.string "image_url"
    t.string "contract_type"
    t.string "seniority"
    t.boolean "active", default: true, null: false
    t.string "country"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["google_id"], name: "index_users_on_google_id", unique: true
    t.index ["profession_id"], name: "index_users_on_profession_id"
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "certifications", "users"
  add_foreign_key "issues", "projects"
  add_foreign_key "issues", "users"
  add_foreign_key "projects", "customers"
  add_foreign_key "statement_of_works", "projects"
  add_foreign_key "user_permissions", "permissions"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "user_service_identifiers", "customers"
  add_foreign_key "user_service_identifiers", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "users", "professions"
end
