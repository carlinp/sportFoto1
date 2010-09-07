class RenamePhotographersEventTypesJointablecolumns < ActiveRecord::Migration
  def self.up
    change_table :photographers_event_types do |t|
      t.rename :photographers_id, :photographer_id
      t.rename :event_types_id, :event_type_id
    end
  end

  def self.down
    rename_column :photographers_event_types, :photographer_id, :photographers_id
    rename_column :photographers_event_types, :event_type_id, :event_types_id
  end
end
