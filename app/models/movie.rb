class Movie < ApplicationRecord
  has_and_belongs_to_many :categories, -> { distinct }
  has_and_belongs_to_many :genres, -> { distinct }
  has_many :credits
  has_many :people, through: :credits
  has_many :user_movies
  has_many :users, through: :user_movies
end
