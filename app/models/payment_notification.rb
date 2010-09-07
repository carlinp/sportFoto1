class PaymentNotification < ActiveRecord::Base
  belongs_to :cart
  serialize :params
  after_create :mark_cart_as_purchased

  private
  def mark_cart_as_purchased
    if status == "Completed"
      cart.update_attribute(:paymentdate, Time.now)
      cart.update_attribute(:is_paid, 1)
      cart.update_attribute(:zipfile, self.transaction_id+".zip")
    end
  end
end