class AddPhotoExifsTable < ActiveRecord::Migration
  def self.up
    create_table :exifs do |t|
      t.string :width
      t.string :height
      t.string :model
      t.datetime :date_time
      t.string :exposure_time
      t.float  :f_number
    end

    add_column :photos, :exif_id, :int

  end

  def self.down
    drop_table :photos_exifs
    remove_column :photos, :exif_id
  end
end
