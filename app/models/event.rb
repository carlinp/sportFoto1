class Event < ActiveRecord::Base
  belongs_to :event_type
  has_many :photos

  validates_presence_of :title, :location, :event_start

  def approved_photos_count
    photo_count = Photo.count_by_sql "SELECT COUNT(id) FROM photos WHERE is_approved=1 and event_id=#{id}"
    return photo_count
  end

end
