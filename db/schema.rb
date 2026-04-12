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

ActiveRecord::Schema[8.2].define(version: 2026_04_12_155726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "mfa_enabled", default: false, null: false
    t.string "name", null: false
    t.boolean "password_complexity", default: true, null: false
    t.integer "session_timeout"
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

  create_table "assessment_batches", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.string "status", default: "open", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index "lower((name)::text)", name: "index_assessment_batches_on_lower_name", unique: true
    t.index ["account_id"], name: "index_assessment_batches_on_account_id"
    t.index ["name", "status"], name: "index_assessment_batches_on_name_and_status"
    t.index ["user_id"], name: "index_assessment_batches_on_user_id"
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
    t.bigint "assessment_batch_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.date "due_date"
    t.string "name", null: false
    t.string "status", default: "open", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "version"
    t.index ["assessment_batch_id"], name: "index_assessments_on_assessment_batch_id"
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

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
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
    t.tsvector "search_vector"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["search_vector"], name: "index_users_on_search_vector", using: :gin
  end

  add_foreign_key "answers", "assessment_controls"
  add_foreign_key "answers", "assessments"
  add_foreign_key "answers", "users"
  add_foreign_key "assessment_batches", "accounts"
  add_foreign_key "assessment_batches", "users"
  add_foreign_key "assessment_controls", "assessments"
  add_foreign_key "assessment_controls", "controls"
  add_foreign_key "assessment_frameworks", "assessments"
  add_foreign_key "assessment_frameworks", "frameworks"
  add_foreign_key "assessments", "accounts"
  add_foreign_key "assessments", "assessment_batches"
  add_foreign_key "assessments", "teams"
  add_foreign_key "assessments", "users"
  add_foreign_key "framework_controls", "controls"
  add_foreign_key "framework_controls", "frameworks"
  add_foreign_key "magic_links", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "users"
  add_foreign_key "teams", "accounts"
  add_foreign_key "users", "accounts"
end
