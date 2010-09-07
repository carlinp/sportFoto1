class AddUserIdToPhotographer < ActiveRecord::Migration
  def self.up
    add_column :photographers, :user_id, :int
  end

  def self.down
    remove_column :photographers, :user_id
  end
end
