class CreateMovieOwners < ActiveRecord::Migration[5.1]
  def change
    create_table :movie_owners do |t|
      t.integer :movie_id
      t.integer :owner_id
    end
  end
end
