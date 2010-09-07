class RenameEventsIdInCategories < ActiveRecord::Migration
  def self.up
    rename_column :categories, :events_id, :event_id
    rename_column :photos_startnumbers, :events_id, :event_id
    rename_column :photos_startnumbers, :photos_id, :photo_id
  end

  def self.down
    rename_column :categories, :event_id, :events_id
    rename_column :photos_startnumbers, :event_id, :events_id
    rename_column :photos_startnumbers, :photo_id, :photos_id
  end
end
