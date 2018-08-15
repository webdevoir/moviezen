class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :profile_url
      t.string :slug
      t.integer :tmdb_id

      t.timestamps
    end
  end
end
