class CreateMovieUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :movie_users do |t|
      t.integer :movie_id
      t.integer :user_id
    end
  end
end
