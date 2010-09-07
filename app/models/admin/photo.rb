class Admin::Photo < ActiveRecord::Base
  belongs_to :photographer
  belongs_to :event
  belongs_to :category
  belongs_to :exif
end
