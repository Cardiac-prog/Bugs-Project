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

ActiveRecord::Schema[7.2].define(version: 2024_09_10_215254) do
  create_table "bugs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "category"
    t.integer "priority"
    t.integer "reported_by_id", null: false
    t.integer "assigned_to_id", null: false
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_bugs_on_assigned_to_id"
    t.index ["project_id"], name: "index_bugs_on_project_id"
    t.index ["reported_by_id"], name: "index_bugs_on_reported_by_id"
  end

  create_table "bugs_users", id: false, force: :cascade do |t|
    t.integer "bug_id", null: false
    t.integer "user_id", null: false
    t.index ["bug_id", "user_id"], name: "index_bugs_users_on_bug_id_and_user_id", unique: true
    t.index ["user_id", "bug_id"], name: "index_bugs_users_on_user_id_and_bug_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "manager_id", null: false
    t.index ["manager_id"], name: "index_projects_on_manager_id"
  end

  create_table "projects_qas", id: false, force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_qas_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_projects_qas_on_project_id"
    t.index ["user_id"], name: "index_projects_qas_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bugs", "projects"
  add_foreign_key "bugs", "users", column: "assigned_to_id"
  add_foreign_key "bugs", "users", column: "reported_by_id"
  add_foreign_key "projects", "users", column: "manager_id"
  add_foreign_key "projects_qas", "projects"
  add_foreign_key "projects_qas", "users"
end
