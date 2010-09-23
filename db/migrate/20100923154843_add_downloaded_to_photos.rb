class AddDownloadedToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :num_download, :integer, :default => 0
  end

  def self.down
    remove_column :photos, :num_download
  end
end
