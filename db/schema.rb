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

ActiveRecord::Schema[7.0].define(version: 2025_05_19_152750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assignments", force: :cascade do |t|
    t.float "coverage"
    t.bigint "requirement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "user_id", null: false
    t.text "feedback"
    t.index ["requirement_id"], name: "index_assignments_on_requirement_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

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

  create_table "dynamic_datasets", force: :cascade do |t|
    t.string "name"
    t.text "code"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.index ["project_id"], name: "index_dynamic_datasets_on_project_id"
  end

  create_table "fixed_bid_contract_models", force: :cascade do |t|
    t.boolean "fixed_timeline", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "user_id"
    t.string "state"
    t.datetime "closed_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.string "issue_id"
    t.string "issue_type"
    t.string "title"
    t.datetime "reported_at"
    t.string "tts_id"
    t.boolean "bug", default: false, null: false
    t.string "parent_tts_id"
    t.string "board_column"
    t.string "sprint"
    t.datetime "sprint_start_date"
    t.datetime "sprint_end_date"
    t.index ["project_id"], name: "index_issues_on_project_id"
  end

  create_table "maintenance_contract_models", force: :cascade do |t|
    t.string "delivery_period"
    t.float "expected_hours_per_period"
    t.float "revenue_per_period"
    t.boolean "accumulate_hours", default: false, null: false
    t.boolean "charge_upfront", default: false, null: false
    t.float "hourly_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "date"
    t.float "amount"
    t.bigint "statement_of_work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statement_of_work_id"], name: "index_payments_on_statement_of_work_id"
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

  create_table "project_reports", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_reports_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "billable", default: true, null: false
    t.string "slack_channel"
    t.json "metadata"
    t.string "slug"
    t.string "logo_url"
    t.boolean "sync_ticket_tracking_system", default: false, null: false
    t.boolean "sync_source_control", default: false, null: false
    t.string "logo_background_color"
    t.boolean "display_tasks_metrics", default: false, null: false
    t.boolean "display_code_metrics", default: false, null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "requirements", force: :cascade do |t|
    t.bigint "profession_id", null: false
    t.bigint "statement_of_work_id", null: false
    t.float "coverage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.index ["profession_id"], name: "index_requirements_on_profession_id"
    t.index ["statement_of_work_id"], name: "index_requirements_on_statement_of_work_id"
  end

  create_table "retainer_contract_models", force: :cascade do |t|
    t.boolean "charge_upfront", default: false, null: false
    t.float "revenue_per_period"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "expected_hours_per_period", default: 0.0
  end

  create_table "salaries", force: :cascade do |t|
    t.float "yearly_salary"
    t.datetime "start_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_salaries_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "professional_area"
    t.index "lower((name)::text)", name: "index_skills_on_lower_name", unique: true
  end

  create_table "statement_of_work_financial_reports", force: :cascade do |t|
    t.integer "statement_of_work_id", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.float "total_executed_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statement_of_work_id"], name: "index_sow_financial_reports_on_sow_id"
  end

  create_table "statement_of_works", force: :cascade do |t|
    t.float "total_revenue"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "contract_model_id"
    t.string "contract_model_type"
    t.index ["contract_model_id", "contract_model_type"], name: "index_sow_on_contract_model"
    t.index ["project_id"], name: "index_statement_of_works_on_project_id"
  end

  create_table "time_and_materials_at_cost_contract_models", force: :cascade do |t|
    t.boolean "allow_overflow", default: false, null: false
    t.string "limit_by"
    t.float "management_factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "hours_amount"
  end

  create_table "time_and_materials_contract_models", force: :cascade do |t|
    t.float "hourly_price"
    t.float "hours_amount"
    t.boolean "allow_overflow", default: false, null: false
    t.string "limit_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_entries", force: :cascade do |t|
    t.date "date"
    t.float "hours"
    t.bigint "user_id", null: false
    t.bigint "statement_of_work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "user_id", "statement_of_work_id"], name: "index_time_entries_on_date_and_user_id_and_sow_id", unique: true
    t.index ["statement_of_work_id"], name: "index_time_entries_on_statement_of_work_id"
    t.index ["user_id"], name: "index_time_entries_on_user_id"
  end

  create_table "time_off_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_offs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "time_off_type_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["starts_at", "ends_at", "time_off_type_id", "user_id"], name: "index_time_offs_on_unique_combination", unique: true
    t.index ["time_off_type_id"], name: "index_time_offs_on_time_off_type_id"
    t.index ["user_id"], name: "index_time_offs_on_user_id"
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
    t.float "years_of_experience"
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true
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
    t.boolean "internal", default: true, null: false
    t.text "history"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profession_id"], name: "index_users_on_profession_id"
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assignments", "requirements"
  add_foreign_key "assignments", "users"
  add_foreign_key "certifications", "users"
  add_foreign_key "dynamic_datasets", "projects"
  add_foreign_key "issues", "projects"
  add_foreign_key "payments", "statement_of_works"
  add_foreign_key "project_reports", "projects"
  add_foreign_key "projects", "customers"
  add_foreign_key "requirements", "professions"
  add_foreign_key "requirements", "statement_of_works"
  add_foreign_key "salaries", "users"
  add_foreign_key "statement_of_works", "projects"
  add_foreign_key "time_entries", "statement_of_works"
  add_foreign_key "time_entries", "users"
  add_foreign_key "time_offs", "time_off_types"
  add_foreign_key "time_offs", "users"
  add_foreign_key "user_permissions", "permissions"
  add_foreign_key "user_permissions", "users"
  add_foreign_key "user_service_identifiers", "customers"
  add_foreign_key "user_service_identifiers", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "users", "professions"
end
