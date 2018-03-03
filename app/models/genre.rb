class Genre < ActiveRecord::Base
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  has_many :movie_genres
  has_many :movies, through: :movie_genres

end
