class Photo < ActiveRecord::Base
  belongs_to :photographer
  belongs_to :event
  belongs_to :category
  belongs_to :exif
  belongs_to :spot
  has_many :cart_items

  def has_price
    return price > 0
  end

  def is_sold
    return sold_num > 0
  end

  def sold_num
    paid_num = 0
    cart_items.each do |cart_item|
      if cart_item.cart.is_paid?
        paid_num+=1
      end
    end
    return paid_num
  end

  def sold_price_total
    sold_price_total = 0
    cart_items.each do |cart_item|
      if cart_item.cart.is_paid?
        sold_price_total+=cart_item.price
      end
    end
    return sold_price_total
  end

  def paid_price_total
    paid_price_total = 0
    cart_items.each do |cart_item|
      if cart_item.is_paid_to_photographer?
        paid_price_total+=cart_item.price
      end
    end
    return paid_price_total
  end
  
end