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

ActiveRecord::Schema[8.0].define(version: 2026_02_12_040250) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "awesome_lists", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "github_repo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_commit_at"
    t.boolean "skip_external_links", default: true, null: false
    t.datetime "processing_started_at"
    t.datetime "processing_completed_at"
    t.string "state", default: "pending", null: false
    t.datetime "last_synced_at"
    t.datetime "last_pushed_at"
    t.integer "sync_threshold", default: 10
    t.boolean "archived", default: false, null: false
    t.datetime "archived_at"
    t.text "readme_content"
    t.index ["archived", "updated_at"], name: "index_awesome_lists_on_archived_and_updated_at"
    t.index ["archived"], name: "index_awesome_lists_on_archived"
    t.index ["last_synced_at"], name: "index_awesome_lists_on_last_synced_at"
    t.index ["state"], name: "index_awesome_lists_on_state"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "awesome_list_id", null: false
    t.integer "parent_id"
    t.string "name", null: false
    t.integer "repo_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_id"], name: "index_categories_on_awesome_list_id"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "category_items", force: :cascade do |t|
    t.string "name"
    t.string "github_repo"
    t.string "demo_url"
    t.string "primary_url"
    t.text "description"
    t.integer "commits_past_year"
    t.datetime "last_commit_at"
    t.integer "stars"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "previous_stars"
    t.text "github_description"
    t.integer "stars_30d"
    t.integer "stars_90d"
    t.datetime "star_history_fetched_at"
    t.index ["category_id"], name: "index_category_items_on_category_id"
    t.index ["stars", "previous_stars"], name: "index_category_items_on_stars_and_previous_stars"
  end

  create_table "github_api_requests", force: :cascade do |t|
    t.string "endpoint"
    t.datetime "requested_at"
    t.integer "response_status"
    t.string "owner"
    t.string "repo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repo_stats", force: :cascade do |t|
    t.integer "awesome_list_id", null: false
    t.integer "stars"
    t.integer "commits_past_year"
    t.datetime "last_commit_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_id"], name: "index_repo_stats_on_awesome_list_id"
  end

  create_table "repos", force: :cascade do |t|
    t.string "github_repo", null: false
    t.string "description"
    t.integer "stars"
    t.integer "previous_stars"
    t.datetime "last_commit_at"
    t.integer "stars_30d"
    t.integer "stars_90d"
    t.datetime "star_history_fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_repo"], name: "index_repos_on_github_repo", unique: true
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "star_snapshots", force: :cascade do |t|
    t.bigint "repo_id", null: false
    t.integer "stars", null: false
    t.date "snapshot_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repo_id", "snapshot_date"], name: "index_star_snapshots_on_repo_id_and_snapshot_date", unique: true
    t.index ["repo_id"], name: "index_star_snapshots_on_repo_id"
    t.index ["snapshot_date"], name: "index_star_snapshots_on_snapshot_date"
  end

  create_table "sync_logs", force: :cascade do |t|
    t.bigint "awesome_list_id", null: false
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.integer "items_checked", default: 0
    t.integer "items_updated", default: 0
    t.string "status", null: false
    t.text "error_message"
    t.string "git_commit_sha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_id"], name: "index_sync_logs_on_awesome_list_id"
  end

  add_foreign_key "categories", "awesome_lists"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "category_items", "categories"
  add_foreign_key "repo_stats", "awesome_lists"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "star_snapshots", "repos"
  add_foreign_key "sync_logs", "awesome_lists"
end
