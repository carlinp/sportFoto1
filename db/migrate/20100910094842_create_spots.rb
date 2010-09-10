class CreateSpots < ActiveRecord::Migration
  def self.up
    create_table :spots do |t|
      t.string :name
      t.string :gps_lat
      t.string :gps_long
      t.integer :event_id
    end

    add_column :photos, :spot_id, :int
  end

  def self.down
    drop_table :spots
    remove_column :photos, :spot_id
  end
end
