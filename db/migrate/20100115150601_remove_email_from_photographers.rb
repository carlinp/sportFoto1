class RemoveEmailFromPhotographers < ActiveRecord::Migration
  def self.up
    remove_column :photographers, :email
  end

  def self.down
    add_column :photographers, :email, :string
  end
end
