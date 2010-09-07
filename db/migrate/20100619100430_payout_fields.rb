class PayoutFields < ActiveRecord::Migration
  def self.up
    add_column :cart_items, :price, :int
    add_column :cart_items, :is_paid_to_photographer, :boolean
    add_column :photographers, :paypal_address, :string
    change_column_default :cart_items, :price, 0
    change_column_default :cart_items, :is_paid_to_photographer, 0
    change_column_default :photographers, :paypal_address, ""
  end

  def self.down
    remove_column :cart_items, :price
    remove_column :cart_items, :is_paid_to_photographer
    remove_column :photographers, :paypal_address
  end
end
