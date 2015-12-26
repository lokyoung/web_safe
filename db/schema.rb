# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151226062313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announces", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "announces", ["user_id", "created_at"], name: "index_announces_on_user_id_and_created_at", using: :btree
  add_index "announces", ["user_id"], name: "index_announces_on_user_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id", "created_at"], name: "index_answers_on_user_id_and_created_at", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "topic_id"
    t.string   "comment_to"
  end

  add_index "comments", ["answer_id"], name: "index_comments_on_answer_id", using: :btree
  add_index "comments", ["topic_id"], name: "index_comments_on_topic_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "coursewares", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "coursefile"
    t.boolean  "isvideo",     default: false
  end

  add_index "coursewares", ["user_id", "created_at"], name: "index_coursewares_on_user_id_and_created_at", using: :btree
  add_index "coursewares", ["user_id"], name: "index_coursewares_on_user_id", using: :btree

  create_table "experiments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "experimentfile"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "experiments", ["user_id"], name: "index_experiments_on_user_id", using: :btree

  create_table "experiments_stuclasses", id: false, force: :cascade do |t|
    t.integer "experiment_id"
    t.integer "stuclass_id"
  end

  create_table "homeworks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "homeworkfile"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "homeworks", ["user_id", "created_at"], name: "index_homeworks_on_user_id_and_created_at", using: :btree
  add_index "homeworks", ["user_id"], name: "index_homeworks_on_user_id", using: :btree

  create_table "homeworks_stuclasses", id: false, force: :cascade do |t|
    t.integer "homework_id"
    t.integer "stuclass_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "unread"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "issolved",   default: false
  end

  add_index "questions", ["user_id", "created_at"], name: "index_questions_on_user_id_and_created_at", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "stuclasses", force: :cascade do |t|
    t.string   "scname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stuhomeworks", force: :cascade do |t|
    t.string   "stuhomeworkfile"
    t.integer  "user_id"
    t.integer  "mark"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "ischecked",       default: false
    t.integer  "homework_id"
    t.text     "remark"
  end

  add_index "stuhomeworks", ["homework_id"], name: "index_stuhomeworks_on_homework_id", using: :btree
  add_index "stuhomeworks", ["user_id", "created_at"], name: "index_stuhomeworks_on_user_id_and_created_at", using: :btree
  add_index "stuhomeworks", ["user_id"], name: "index_stuhomeworks_on_user_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "password_digest"
    t.boolean  "teacher",         default: false
    t.string   "sid"
    t.string   "remember_digest"
    t.string   "type",            default: "Student"
    t.integer  "stuclass_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["stuclass_id"], name: "index_users_on_stuclass_id", using: :btree

  add_foreign_key "announces", "users"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "comments", "answers"
  add_foreign_key "comments", "topics"
  add_foreign_key "comments", "users"
  add_foreign_key "coursewares", "users"
  add_foreign_key "experiments", "users"
  add_foreign_key "homeworks", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "stuhomeworks", "users"
  add_foreign_key "topics", "users"
  add_foreign_key "users", "stuclasses"
end
