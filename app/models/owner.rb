class Owner < ActiveRecord::Base

  has_secure_password

  has_many :movie_owners
  has_many :movies, through: :movie_owners
  has_many :genres, through: :movies

end
