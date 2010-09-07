class AddCheckoutsTable < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.integer :cart_id
      t.integer :photo_id
      t.boolean :is_zipped
    end

    create_table :carts do |t|
      t.string :carthash
      t.text :response
      t.boolean :is_paid
      t.boolean :is_zipped
      t.string :zipfile
      t.datetime :paymentdate
      t.timestamps
    end

    add_column :photos, :price, :integer
    add_column :photos, :currency, :string

  end

  def self.down
    drop_table :cart_items
    drop_table :carts
    remove_column :photos, :price
    remove_column :photos, :currency
  end
end
