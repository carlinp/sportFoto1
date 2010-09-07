require 'zip/zip'
require 'zip/zipfilesystem'

class Cart < ActiveRecord::Base
  has_many :cart_items

  def total_price
    total=0
    cart_items.to_a.each do |item|
      total+=item.photo.price
    end
    total
  end

  def paypal_url(return_url, notify_url)
    values = {
      :business => $app_config['paypal_business_address'],
      :cmd => '_cart',
      :upload => '1',
      :return => return_url,
      :invoice => id,
      :notify_url => notify_url
    }
    cart_items.each_with_index do |item, index|
      values.merge!({
          "amount_#{index+1}" => item.photo.price,
          "item_name_#{index+1}" => item.photo.filename,
          "item_number_#{index+1}" => item.id,
          "quantity_#{index+1}" => 1
        })
    end
    $app_config['paypal_url']+values.map {|k,v| "#{k}=#{v}" }.join("&")
  end

  def bundle
   bundle_filename = File.join(RAILS_ROOT,'data',self.zipfile)
       # check to see if the file exists already, and if it does, delete it.
   if File.file?(bundle_filename)
     File.delete(bundle_filename)
   end

   # open or create the zip file
   Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
     |zipfile|
     # collect the album's tracks
     self.cart_items.collect {
       |cart_item|
         # add each track to the archive, names using the track's attributes
         zipfile.add( cart_item.photo.event_id.to_s+"_"+cart_item.photo.photographer_id.to_s+"_"+cart_item.photo.filename, File.join(RAILS_ROOT,'data', cart_item.photo.event_id.to_s, cart_item.photo.photographer_id.to_s, cart_item.photo.fingerprint))
         cart_item.update_attribute(:is_zipped, 1)
       }
   }

   # set read permissions on the file
   File.chmod(0644, bundle_filename)

    self.is_zipped = 1
   # save the object
   self.save

  end
  
end