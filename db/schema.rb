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

ActiveRecord::Schema.define(version: 2018_08_14_212226) do

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_movies", id: false, force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "category_id", null: false
  end

  create_table "credits", force: :cascade do |t|
    t.integer "cast_id"
    t.string "credit_id"
    t.string "character"
    t.integer "order"
    t.string "department"
    t.string "job"
    t.integer "person_id"
    t.integer "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_credits_on_movie_id"
    t.index ["person_id"], name: "index_credits_on_person_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres_movies", id: false, force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "genre_id", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.integer "tmdb_id"
    t.string "imdb_id"
    t.string "slug"
    t.string "poster_url"
    t.string "backdrop_url"
    t.string "tagline"
    t.text "overview"
    t.date "release_date"
    t.integer "runtime"
    t.string "trailer_key"
    t.string "certification"
    t.float "tomato_rating"
    t.float "imdb_rating"
    t.float "metacritic_rating"
    t.integer "tmdb_vote_count"
    t.float "tmdb_vote_avg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "profile_url"
    t.string "slug"
    t.integer "tmdb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_movies", force: :cascade do |t|
    t.boolean "is_favorite"
    t.boolean "is_watchlist"
    t.integer "user_id"
    t.integer "movie_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_user_movies_on_movie_id"
    t.index ["user_id"], name: "index_user_movies_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "profile_url"
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
