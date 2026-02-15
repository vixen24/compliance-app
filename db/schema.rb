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

ActiveRecord::Schema[8.2].define(version: 2026_02_13_084422) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.integer "assessment_control_id", null: false
    t.integer "assessment_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.string "state", default: "draft"
    t.string "status"
    t.datetime "updated_at", null: false
    t.string "url"
    t.integer "user_id", null: false
    t.index ["assessment_control_id", "assessment_id"], name: "index_answers_on_control_and_assessment", unique: true
    t.index ["assessment_id"], name: "index_answers_on_assessment_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "assessment_controls", force: :cascade do |t|
    t.bigint "assessment_id", null: false
    t.string "category"
    t.string "code"
    t.bigint "control_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "domain"
    t.string "evidence"
    t.string "guidiance"
    t.string "name"
    t.text "question"
    t.virtual "search_vector", type: :tsvector, as: "to_tsvector('english'::regconfig, question)", stored: true
    t.datetime "updated_at", null: false
    t.index ["assessment_id", "control_id"], name: "index_assessment_controls_on_assessment_id_and_control_id", unique: true
    t.index ["assessment_id"], name: "index_assessment_controls_on_assessment_id"
    t.index ["control_id"], name: "index_assessment_controls_on_control_id"
    t.index ["search_vector"], name: "index_assessment_controls_on_search_vector", using: :gin
  end

  create_table "assessment_frameworks", force: :cascade do |t|
    t.integer "assessment_id", null: false
    t.datetime "created_at", null: false
    t.integer "framework_id", null: false
    t.datetime "updated_at", null: false
    t.index ["assessment_id"], name: "index_assessment_frameworks_on_assessment_id"
    t.index ["framework_id"], name: "index_assessment_frameworks_on_framework_id"
  end

  create_table "assessments", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.date "due_date"
    t.string "name", null: false
    t.string "status", default: "open", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "version"
    t.index ["team_id"], name: "index_assessments_on_team_id"
    t.index ["user_id"], name: "index_assessments_on_user_id"
  end

  create_table "controls", force: :cascade do |t|
    t.string "category"
    t.string "code"
    t.integer "control_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "domain"
    t.string "name"
    t.text "question", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('english'::regconfig, question)", name: "index_controls_on_question_tsv", using: :gin
    t.index ["code"], name: "index_controls_on_code", unique: true
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer "answer_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "parent_id"
    t.string "role", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["answer_id"], name: "index_feedbacks_on_answer_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "framework_controls", force: :cascade do |t|
    t.string "code", null: false
    t.integer "control_id", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "framework_id", null: false
    t.text "guidance"
    t.string "name"
    t.string "section"
    t.datetime "updated_at", null: false
    t.index ["control_id"], name: "index_framework_controls_on_control_id"
    t.index ["framework_id", "control_id"], name: "index_framework_controls_on_framework_id_and_control_id", unique: true
    t.index ["framework_id"], name: "index_framework_controls_on_framework_id"
  end

  create_table "frameworks", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "version"
    t.index ["code"], name: "index_frameworks_on_code", unique: true
  end

  create_table "magic_links", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "purpose", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["code"], name: "index_magic_links_on_code", unique: true
    t.index ["expires_at"], name: "index_magic_links_on_expires_at"
    t.index ["user_id"], name: "index_magic_links_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "team_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["team_id"], name: "index_team_users_on_team_id"
    t.index ["user_id"], name: "index_team_users_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_teams_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "account_id", null: false
    t.boolean "active", default: true, null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.boolean "force_password_reset"
    t.string "name"
    t.string "password_digest", null: false
    t.string "role", default: "member", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "answers", "assessment_controls"
  add_foreign_key "answers", "assessments"
  add_foreign_key "answers", "users"
  add_foreign_key "assessment_controls", "assessments"
  add_foreign_key "assessment_controls", "controls"
  add_foreign_key "assessment_frameworks", "assessments"
  add_foreign_key "assessment_frameworks", "frameworks"
  add_foreign_key "assessments", "accounts"
  add_foreign_key "assessments", "teams"
  add_foreign_key "assessments", "users"
  add_foreign_key "feedbacks", "answers"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "framework_controls", "controls"
  add_foreign_key "framework_controls", "frameworks"
  add_foreign_key "magic_links", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "users"
  add_foreign_key "teams", "accounts"
  add_foreign_key "users", "accounts"
end
