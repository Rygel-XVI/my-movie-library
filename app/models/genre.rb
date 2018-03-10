class Genre < ActiveRecord::Base
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods

  belongs_to :user
  has_many :movies, through: :users

end
