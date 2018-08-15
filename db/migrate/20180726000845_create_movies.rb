class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.integer :tmdb_id
      t.string :imdb_id
      t.string :slug
      t.string :poster_url
      t.string :backdrop_url
      t.string :tagline
      t.text :overview
      t.date :release_date
      t.integer :runtime
      t.string :trailer_key
      t.string :certification
      t.float :tomato_rating
      t.float :imdb_rating
      t.float :metacritic_rating
      t.integer :tmdb_vote_count
      t.float :tmdb_vote_avg
      t.timestamps
    end
  end
end
