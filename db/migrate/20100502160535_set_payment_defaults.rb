class SetPaymentDefaults < ActiveRecord::Migration
  def self.up
    change_column_default(:carts, :is_paid, 0)
    change_column_default(:carts, :is_zipped, 0)
    change_column_default(:cart_items, :is_zipped, 0)
  end

  def self.down
  end
end
