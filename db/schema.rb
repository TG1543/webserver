# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160906074315) do

  create_table "binnacles", force: :cascade do |t|
    t.integer  "iteration_id"
    t.text     "comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.date     "date"
    t.index ["iteration_id"], name: "index_binnacles_on_iteration_id"
  end

  create_table "equipment", force: :cascade do |t|
    t.integer  "iteration_id"
    t.boolean  "active",        default: true
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "serial_number"
    t.index ["iteration_id"], name: "index_equipment_on_iteration_id"
    t.index ["serial_number"], name: "index_equipment_on_serial_number", unique: true
  end

  create_table "experiments", force: :cascade do |t|
    t.string   "description"
    t.integer  "project_id"
    t.integer  "state_id",    default: 1
    t.integer  "result_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["project_id"], name: "index_experiments_on_project_id"
    t.index ["result_id"], name: "index_experiments_on_result_id"
    t.index ["state_id"], name: "index_experiments_on_state_id"
  end

  create_table "iterations", force: :cascade do |t|
    t.integer  "experiment_id"
    t.date     "started_at"
    t.date     "ended_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "state_id",      default: 1
    t.index ["experiment_id"], name: "index_iterations_on_experiment_id"
    t.index ["state_id"], name: "index_iterations_on_state_id"
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plots", force: :cascade do |t|
    t.string   "name"
    t.string   "x_axis"
    t.string   "y_axis"
    t.integer  "iteration_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["iteration_id"], name: "index_plots_on_iteration_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.integer  "state_id",    default: 1
    t.index ["state_id"], name: "index_projects_on_state_id"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_experiments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "experiment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["experiment_id"], name: "index_user_experiments_on_experiment_id"
    t.index ["user_id"], name: "index_user_experiments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "auth_token",             default: ""
    t.string   "name"
    t.boolean  "active",                 default: false
    t.integer  "role_id",                default: 5
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "values", force: :cascade do |t|
    t.float    "quantity"
    t.integer  "parameter_id"
    t.integer  "equipment_id"
    t.integer  "iteration_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["equipment_id"], name: "index_values_on_equipment_id"
    t.index ["iteration_id"], name: "index_values_on_iteration_id"
    t.index ["parameter_id"], name: "index_values_on_parameter_id"
  end

end
