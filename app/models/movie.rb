class Movie < ActiveRecord::Base
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  has_many :movie_genres
  has_many :movie_users
  has_many :genres, through: :movie_genres
  has_many :users, through: :movie_users

end
