class User < ActiveRecord::Base

  has_secure_password

  has_many :movie_users
  has_many :movies, through: :movie_users
  has_many :genres, through: :movies

end
