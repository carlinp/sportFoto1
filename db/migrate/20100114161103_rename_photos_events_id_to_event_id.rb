class RenamePhotosEventsIdToEventId < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.rename :photographers_id, :photographer_id
      t.rename :events_id, :event_id
      t.rename :categories_id, :category_id
    end

  end

  def self.down
    rename_column :photos, :photographer_id, :photographers_id
    rename_column :photos, :event_id, :events_id
    rename_column :photos, :category_id, :categories_id
  end
end
