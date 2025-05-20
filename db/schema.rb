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

ActiveRecord::Schema[8.0].define(version: 2025_05_20_171057) do
  create_table "awesome_list_versions", force: :cascade do |t|
    t.integer "awesome_list_id", null: false
    t.integer "stars"
    t.integer "commits_past_year"
    t.datetime "last_commit_at"
    t.integer "repo_count"
    t.integer "category_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_id"], name: "index_awesome_list_versions_on_awesome_list_id"
  end

  create_table "awesome_lists", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "github_repo", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_commit_at"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "awesome_list_version_id", null: false
    t.integer "parent_id"
    t.string "name", null: false
    t.integer "repo_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_version_id"], name: "index_categories_on_awesome_list_version_id"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "repo_stats", force: :cascade do |t|
    t.integer "awesome_list_version_id", null: false
    t.integer "stars"
    t.integer "commits_past_year"
    t.datetime "last_commit_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_version_id"], name: "index_repo_stats_on_awesome_list_version_id"
  end

  add_foreign_key "awesome_list_versions", "awesome_lists"
  add_foreign_key "categories", "awesome_list_versions"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "repo_stats", "awesome_list_versions"
end
