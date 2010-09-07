class RenameEventEventTypesToEventType < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.rename :event_types_id, :event_type_id
    end
  end

  def self.down
    rename_column :events, :event_type_id, :event_types_id
  end
end
