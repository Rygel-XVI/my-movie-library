class Movie < ActiveRecord::Base

  has_many :movie_genres
  has_many :movie_owners
  has_many :genres, through: :movie_genres
  has_many :owners, through: :movie_owners

end
