class ModifyOwners < ActiveRecord::Migration[5.1]
  def change
    add_column :owners, :password_digest, :string;
    add_column :owners, :email, :string;
  end
end
