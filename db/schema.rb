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

ActiveRecord::Schema.define(version: 20141217144042) do

  create_table "editors", force: true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "email"
    t.integer  "inviter_id"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "editors", ["accepted_at"], name: "index_editors_on_accepted_at"
  add_index "editors", ["created_at"], name: "index_editors_on_created_at"
  add_index "editors", ["email", "accepted_at"], name: "index_editors_on_email_and_accepted_at"
  add_index "editors", ["email"], name: "index_editors_on_email"
  add_index "editors", ["inviter_id"], name: "index_editors_on_inviter_id"
  add_index "editors", ["survey_id"], name: "index_editors_on_survey_id"
  add_index "editors", ["user_id"], name: "index_editors_on_user_id"

  create_table "invites", force: true do |t|
    t.integer  "survey_id"
    t.string   "token"
    t.string   "email"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["email"], name: "index_invites_on_email"
  add_index "invites", ["survey_id"], name: "index_invites_on_survey_id"
  add_index "invites", ["token"], name: "index_invites_on_token"

  create_table "item_ranks", force: true do |t|
    t.integer  "response_id"
    t.integer  "survey_item_id"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_ranks", ["rank"], name: "index_item_ranks_on_rank"
  add_index "item_ranks", ["response_id", "rank"], name: "index_item_ranks_on_response_id_and_rank"
  add_index "item_ranks", ["response_id"], name: "index_item_ranks_on_response_id"
  add_index "item_ranks", ["survey_item_id"], name: "index_item_ranks_on_survey_item_id"

  create_table "responses", force: true do |t|
    t.integer  "survey_id"
    t.integer  "invite_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "name"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["created_at"], name: "index_responses_on_created_at"
  add_index "responses", ["email"], name: "index_responses_on_email"
  add_index "responses", ["invite_id"], name: "index_responses_on_invite_id"
  add_index "responses", ["survey_id"], name: "index_responses_on_survey_id"
  add_index "responses", ["user_id"], name: "index_responses_on_user_id"

  create_table "survey_items", force: true do |t|
    t.integer  "survey_id"
    t.string   "headline"
    t.text     "description"
    t.string   "thumbnail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_items", ["survey_id"], name: "index_survey_items_on_survey_id"

  create_table "surveys", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "permalink"
    t.string   "headline"
    t.text     "subheader"
    t.string   "thanks_headline"
    t.text     "thanks_subheader"
    t.string   "thanks_continue_url"
    t.boolean  "invite_required"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "required_google_apps_domain_login"
  end

  add_index "surveys", ["created_at"], name: "index_surveys_on_created_at"
  add_index "surveys", ["invite_required"], name: "index_surveys_on_invite_required"
  add_index "surveys", ["permalink"], name: "index_surveys_on_permalink"
  add_index "surveys", ["updated_at"], name: "index_surveys_on_updated_at"
  add_index "surveys", ["user_id"], name: "index_surveys_on_user_id"

  create_table "users", force: true do |t|
    t.string   "googleid"
    t.string   "name"
    t.string   "email"
    t.string   "picurl"
    t.boolean  "superuser"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["googleid"], name: "index_users_on_googleid"
  add_index "users", ["superuser"], name: "index_users_on_superuser"

end
