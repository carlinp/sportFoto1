class CartItem < ActiveRecord::Base
  belongs_to :photo
  belongs_to :cart
  after_create :copy_photo_price

  private
  def copy_photo_price
    update_attribute(:price, photo.price)
  end

end