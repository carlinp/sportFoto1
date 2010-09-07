class Starterdb < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      t.string  :name, :null => false
      t.string  :icon
      t.timestamps
    end

    create_table :events do |t|
      t.string  :title, :null => false
      t.text    :description
      t.string  :banner
      t.string  :gps
      t.string  :fingerprint
      t.datetime  :event_start, :null => false
      t.datetime  :event_end
      t.references  :event_types
      t.boolean :is_approved, :default => false
      t.booelan :has_photos, :default => false
      t.timestamps
    end

    create_table :photographers do |t|
      t.string :firstname, :null => false
      t.string :lastname, :null => false
      t.text   :contact, :null => false
      t.string  :email, :null => false
      t.boolean :is_approved, :default => false
      t.boolean :is_active, :default => false
      t.boolean :is_public, :default => false
      t.string  :avatar
      t.timestamps
    end

    create_table :photographers_event_types do |t|
      t.references :photographers
      t.references :event_types
    end

    create_table :categories do |t|
      t.string :name, :null => false
      t.references :events
      t.timestamps
    end

    create_table :photos do |t|
      t.string :filename, :null => false
      t.string :path, :null => false
      t.string :startnumber
      t.string :description
      t.string :fingerprint
      t.boolean :is_processed, :default => false
      t.boolean :is_approved, :default => false
      t.boolean :is_processing, :default => false
      t.boolean :has_startnumber, :default => false
      t.references :photographers
      t.references :events
      t.references :categories
      t.timestamps
    end

    create_table :photos_startnumbers do |t|
      t.string :startnumber
      t.references :photos
      t.references :events
      t.timestamps
    end

  end

  def self.down
    drop_table :event_types
    drop_table :events
    drop_table :photographers
    drop_table :photographers_event_types
    drop_table :categories
    drop_table :photos
    drop_table :photos_startnumbers
  end
end
