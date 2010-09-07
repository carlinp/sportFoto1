class SetPhotosPriceDefault < ActiveRecord::Migration
  def self.up
    change_column_default(:photos, :price, 0)
  end

  def self.down
  end
end
