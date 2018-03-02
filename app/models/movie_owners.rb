class MovieOwner < ActiveRecord::Base

  belongs_to :owner
  belongs_to :movie

end
